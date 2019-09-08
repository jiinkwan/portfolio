================================================================================================
#. 01 테이블스페이스별 파일 목록을 보기
================================================================================================
SELECT  SUBSTRB(TABLESPACE_NAME,1,10)               AS "테이블스페이스",
        SUBSTRB(FILE_NAME, 1, 50)                   AS "파일명",
        TO_CHAR(BLOCKS,'999,999,990')               AS "블럭수",
        TO_CHAR(BYTES,'99,999,999')                 AS "크기"
FROM    DBA_DATA_FILES
ORDER BY TABLESPACE_NAME, FILE_NAME;

================================================================================================
#. 02 테이블스페이스별 정보 보기
================================================================================================

SELECT A.TABLESPACE_NAME          AS "TABLESPACE",
       A.INITIAL_EXTENT/1024      AS "INIT(K)",
       A.NEXT_EXTENT/1024         AS "NEXT(K)",
       A.MIN_EXTENTS              AS "MIN",
       A.MAX_EXTENTS              AS "MAX",      
       A.PCT_INCREASE             AS "PCT_INC(%)",
       B.FILE_NAME                AS "FILE_NAME",
       B.BLOCKS*C.VALUE/1024/1024 AS "SIZE(M)",
       B.STATUS                   AS "STATUS"
FROM   DBA_TABLESPACES A,
       DBA_DATA_FILES B,
       V$PARAMETER C
WHERE  A.TABLESPACE_NAME = B.TABLESPACE_NAME
AND    C.NAME = 'db_block_size'
ORDER BY 1,2;

================================================================================================
#. 03 테이블스페이스별 사용하는 파일의 크기 합 보기
================================================================================================
SELECT SUBSTRB(TABLESPACE_NAME,1,10)                AS TABLESPACE,
       TO_CHAR(SUM(BYTES),'9,999,999,999,990')      AS BYTES,
       TO_CHAR(SUM(BLOCKS), '9,999,999,990')        AS BLOCKS
FROM   DBA_DATA_FILES
GROUP BY TABLESPACE_NAME
UNION ALL
SELECT '총계',
       TO_CHAR(SUM(BYTES),'9,999,999,999,990')      AS BYTES,
       TO_CHAR(SUM(BLOCKS), '9,999,999,990')        AS BLOCKS
FROM   DBA_DATA_FILES;

================================================================================================
#. 04 테이블스페이스별 디스크 사용량 보기
================================================================================================
SELECT A.TABLESPACE_NAME                               AS "TABLESPACE",
       A.INIT                                          AS "INIT(K)",
       A.NEXT                                          AS "NEXT(K)",
       A.MIN                                           AS "MIN",
       A.MAX                                           AS "MAX",      
       A.PCT_INC                                       AS "PCT_INC(%)",      
       TO_CHAR(B.TOTAL, '999,999,999,990')             AS "총량(바이트)",
       TO_CHAR(C.FREE,  '999,999,999,990')             AS "남은량(바이트)",
       TO_CHAR(B.BLOCKS, '9,999,990')                  AS "총블럭",
       TO_CHAR(D.BLOCKS,  '9,999,990')                 AS "사용블럭",
       TO_CHAR(100*NVL(D.BLOCKS,0)/B.BLOCKS, '999.99') AS "사용율%"
FROM  (SELECT TABLESPACE_NAME,                         
              INITIAL_EXTENT/1024                      AS INIT,
              NEXT_EXTENT/1024                         AS NEXT,
              MIN_EXTENTS                              AS MIN,
              MAX_EXTENTS                              AS MAX,      
              PCT_INCREASE                             AS PCT_INC
       FROM   DBA_TABLESPACES) A,
      (SELECT TABLESPACE_NAME,
              SUM(BYTES)                               AS TOTAL,
              SUM(BLOCKS)                              AS BLOCKS
       FROM   DBA_DATA_FILES
       GROUP BY TABLESPACE_NAME) B,
      (SELECT TABLESPACE_NAME,
              SUM(BYTES)                               AS FREE
       FROM   DBA_FREE_SPACE
       GROUP BY TABLESPACE_NAME) C,
      (SELECT TABLESPACE_NAME,
              SUM(BLOCKS)                              AS BLOCKS
       FROM DBA_EXTENTS
       GROUP BY TABLESPACE_NAME) D
WHERE  A.TABLESPACE_NAME = B.TABLESPACE_NAME(+)
AND    A.TABLESPACE_NAME = C.TABLESPACE_NAME(+)
AND    A.TABLESPACE_NAME = D.TABLESPACE_NAME(+)
ORDER BY A.TABLESPACE_NAME ;

================================================================================================
#. 05 테이블스페이스의 테이블 명 보기
================================================================================================
SELECT TABLESPACE_NAME,
       TABLE_NAME
FROM   USER_TABLES
WHERE  TABLESPACE_NAME = UPPER('&테이블스페이스명')
ORDER BY TABLESPACE_NAME, TABLE_NAME;

================================================================================================
#. 06 ROLLBACK SEGMENT의 사용상황 보기
================================================================================================
: EXTENTS = 현재 할당된 EXTENT의 수
: EXTENDS = 마지막 트랜잭션에 의해 할당된 EXTENT의 수
SELECT SUBSTRB(A.SEGMENT_NAME, 1, 10)       AS SEGMENT_NAME,
       SUBSTRB(A.TABLESPACE_NAME, 1, 10)    AS TABLESPACE_NAME,
       TO_CHAR(A.SEGMENT_ID, '99,999')      AS SEG_ID,
       TO_CHAR(A.MAX_EXTENTS, '999,999')    AS MAX_EXT,
       TO_CHAR(B.EXTENTS, '999,999')        AS EXTENTS,
       TO_CHAR(B.EXTENDS, '999,999')        AS EXTENDS,
       TO_CHAR((A.INITIAL_EXTENT + (B.EXTENTS-1)*A.NEXT_EXTENT)/1000000, '9,999.999') AS "ALLOC(MB)",
       TO_CHAR(XACTS,'9,999')               AS XACTS
FROM   DBA_ROLLBACK_SEGS A, V$ROLLSTAT B
WHERE  A.SEGMENT_ID = B.USN(+)
ORDER BY 1;

================================================================================================
#. 07 CONSTRAINT 보기
================================================================================================
SELECT DECODE(A.CONSTRAINT_TYPE,
              'P', 'Primary Key',
              'R', 'Foreign Key',
              'C', 'Table Check',
              'V', 'View Check',
              'U', 'Unique', '?')        AS "유형",
       SUBSTRB(A.CONSTRAINT_NAME, 1, 25) AS CONSTRAINT_NAME,
       B.POSITION,
       SUBSTRB(B.COLUMN_NAME, 1, 25)     AS COLUMN_NAME
FROM   DBA_CONSTRAINTS A, DBA_CONS_COLUMNS B
WHERE  A.CONSTRAINT_NAME = B.CONSTRAINT_NAME
AND    A.OWNER = 'E_LUCIS'
AND    A.TABLE_NAME = UPPER('&테이블명')
ORDER BY 1, 2, 3 ;

================================================================================================
#. 08 INDEX 보기
================================================================================================
SELECT A.INDEX_NAME,
       A.UNIQUENESS,
       TO_CHAR(COLUMN_POSITION, '999') AS POS,
       SUBSTRB(COLUMN_NAME, 1, 33)     AS COLUMN_NAME
FROM   USER_INDEXES A, USER_IND_COLUMNS B
WHERE  A.INDEX_NAME = B.INDEX_NAME
AND    A.TABLE_OWNER = UPPER('E_LUCIS')
AND    A.TABLE_NAME =  UPPER('&테이블명')
ORDER BY 1, 3 ;

================================================================================================
#. 09 전체 INDEX 보기
================================================================================================
SELECT SUBSTRB(A.TABLE_NAME,1,22)      AS TABLE_NAME,
       SUBSTRB(A.INDEX_NAME,1,23)      AS INDEX_NAME,
       SUBSTRB(A.UNIQUENESS,1,7)       AS UNIQUE,
       TO_CHAR(COLUMN_POSITION, '999') AS POS,
       SUBSTRB(COLUMN_NAME,1,20)       AS COLUMN_NAME
FROM   DBA_INDEXES A, DBA_IND_COLUMNS B
WHERE  A.INDEX_NAME = B.INDEX_NAME
AND    A.TABLE_OWNER = B.TABLE_OWNER
AND    A.TABLE_OWNER = 'E_LUCIS'
ORDER BY 1, 2, 3 ;

================================================================================================
#. 10 인덱스에 대한 컬럼 조회
================================================================================================
SELECT TABLE_NAME,
       INDEX_NAME,
       COLUMN_POSITION,
       COLUMN_NAME
FROM   USER_IND_COLUMNS
ORDER BY TABLE_NAME, INDEX_NAME, COLUMN_POSITION;

================================================================================================
#. 11 테이블에 LOCK이 걸렸는지를 보기
================================================================================================
SELECT A.SID,
       A.SERIAL#,
       SUBSTRB(A.USERNAME,1,16)      AS USERNAME,
       SUBSTRB(A.MACHINE,1,30)       AS MACHINE,
       A.TERMINAL,
       A.OSUSER,
       A.PROGRAM,
       SUBSTRB(TO_CHAR(A.LOGON_TIME,'MM/DD HH24:MI:SS'),1,14) AS LOGON_TIME,
       SUBSTRB(C.OBJECT_NAME, 1, 58) AS OBJECT_NAME
FROM   V$SESSION A,V$LOCK B,DBA_OBJECTS C
WHERE  A.SID = B.SID
AND    B.ID1 = C.OBJECT_ID
AND    B.TYPE = 'TM'
AND    C.OBJECT_NAME LIKE UPPER('&테이블명');

================================================================================================
#. 12 Lock을 잡고있는 세션과 기다리는 세션 조회
================================================================================================
SELECT DECODE(B.LOCKWAIT,NULL,' ','w') AS WW,
       B.SID,B.SERIAL#            AS SER#,
       SUBSTR(B.MACHINE,1,10)     AS MACHINE,
       SUBSTR(B.PROGRAM,1,15)     AS PROGRAM,
       SUBSTR(A.OBJECT_NAME,1,17) AS OBJ_NAME,
       SUBSTR(B.STATUS,1,1)       AS S,
       DECODE(B.COMMAND,0,NULL,2,'INSERT',6,'UPDATE',7,'DELETE',
              B.COMMAND )         AS SQLCMD,
       B.PROCESS                  AS PGM_PSS
FROM V$SESSION B,
   ( SELECT A.SID,
            DECODE(B.OWNER,NULL,A.TYPE||'..ing',
                   B.OWNER||'.'||B.OBJECT_NAME ) AS OBJECT_NAME
     FROM V$LOCK A, DBA_OBJECTS B
     WHERE A.ID1 = B.OBJECT_ID (+)
     GROUP BY A.SID,
            DECODE(B.OWNER,NULL,A.TYPE||'..ing',
                   B.OWNER||'.'||B.OBJECT_NAME ) ) A
WHERE B.SID = A.SID
AND   B.TADDR IS NOT NULL;

================================================================================================
#. 13 테이블에 걸린 비정상적 LOCK 풀기
================================================================================================
ALTER SYSTEM KILL SESSION '&SID,&SERIAL' ;

================================================================================================
#. 14 연결되어 있는 OS 사용자 및 프로그램 조회
================================================================================================
SELECT SID,
       SERIAL#,
       OSUSER,
       SUBSTRB(USERNAME,1,10)  AS USER_NAME,
       SUBSTRB(PROGRAM,1,30)   AS PROGRAM_NAME,
       STATUS,
       TO_CHAR(LOGON_TIME, 'YYYY/MM/DD HH:MI') AS LOGON_TIME
FROM   V$SESSION
WHERE  TYPE != ‘BACKGROUND’
AND    STATUS = ‘ACTIVE’;

================================================================================================
#. 15 위치별 space를  아는 방법
================================================================================================
SELECT SUBSTRB(A.FILE_NAME,1,40) AS FILE_NAME,
       A.FILE_ID,
       B.FREE_BYTES/1024         AS FREE_BYTES,
       B.MAX_BYTES/1024          AS MAX_BYTES
FROM   DBA_DATA_FILES A,
     ( SELECT FILE_ID,
              SUM(BYTES)         AS FREE_BYTES,
              MAX(BYTES)         AS MAX_BYTES
       FROM   DBA_FREE_SPACE
       GROUP BY FILE_ID ) B
WHERE  A.FILE_ID = B.FILE_ID
AND    A.TABLESPACE_NAME = UPPER('&테이블스페이스명')
ORDER BY A.FILE_NAME;

================================================================================================
#. 16 DB Link 보기
================================================================================================
SELECT SUBSTRB(U.NAME,1,10)                    AS OWNER,
       SUBSTRB(L.NAME,1,20)                    AS DB_LINK,
       SUBSTRB(L.HOST,1,10)                    AS HOST,
       SUBSTRB(L.USERID||'/'||L.PASSWORD,1,15) AS USERPASS
FROM   SYS.LINK$ L, SYS.USER$ U
WHERE  L.OWNER# = U.USER#;

================================================================================================
#. 17 테이블 생성일자 보기
================================================================================================
SELECT SUBSTRB(OBJECT_NAME,1,15)  AS OBJECT_NAME,
       CREATED,
       LAST_DDL_TIME,
       TIMESTAMP,
       STATUS       
FROM   USER_OBJECTS
WHERE  OBJECT_NAME = UPPER('&테이블명')
AND    OBJECT_TYPE = 'TABLE';

================================================================================================
#. 18 테이블의 크기 및 블록 보기
================================================================================================
SELECT SUBSTR(SEGMENT_NAME,1,20),
       BYTES,
       BLOCKS
FROM   USER_SEGMENTS
WHERE  SEGMENT_NAME = UPPER('&테이블명');

================================================================================================
#. 19 View의 정의 내역 보기
================================================================================================
SET LONG 100000
SELECT TEXT
FROM   USER_VIEWS
WHERE  VIEW_NAME LIKE UPPER('&뷰_이름');

================================================================================================
#. 20 파티션 테이블의 파티션 범위 보기
================================================================================================
SELECT SUBSTRB(PARTITION_NAME,1,30)  AS PARTITION_NAME,
       SUBSTRB(TABLESPACE_NAME,1,30) AS TABLESPACE_NAME,
       HIGH_VALUE
FROM   USER_TAB_PARTITIONS
WHERE  TABLE_NAME = UPPER('&테이블명');

================================================================================================
#. 21 PRIMARY KEY 재생성 방법
================================================================================================
- PRIMARY KEY DROP
ALTER TABLE EMP DROP PRIMARY KEY;
- PRIMARY KEY 생성
ALTER TABLE EMP ADD CONSTRAINT EMP_PK PRIMARY KEY(EMPNO)
USING INDEX STORAGE(INITIAL 1M NEXT 1M PCTINCREASE 0)
TABLESPACE USERS;

================================================================================================
#. 22 PRIMARY KEY를 REFERENCE 하는 FOREIGN KEY 찾기
================================================================================================
SELECT C.NAME  CONSTRAINT_NAME
FROM   DBA_OBJECTS A,
       CDEF$       B,
       CON$        C
WHERE  A.OBJECT_NAME = UPPER('&테이블명')
AND    A.OBJECT_ID = B.ROBJ#
AND    B.CON#      = C.CON#;

================================================================================================
#. 23 동일한 자료 삭제 방법
================================================================================================
DELETE
FROM   EMP E   
WHERE  E.ROWID > ( SELECT MIN(X.ROWID)   
          FROM   EMP X   
WHERE  X.EMPNO = E.EMPNO );

================================================================================================
#. 24 1시간 이상 유휴 상태인 세션
================================================================================================
SELECT SID,SERIAL#,USERNAME,TRUNC
      (LAST_CALL_ET/3600,2)||' HR'
      LAST_CALL_ET
FROM V$SESSION
WHERE LAST_CALL_ET > 3600
AND USERNAME IS NOT NULL;

================================================================================================
#. 25 Oracle Process의 정보
================================================================================================
SELECT   /*+ RULE */
         S.STATUS "STATUS", S.SERIAL# "SERIAL#", S.TYPE "TYPE",
         S.USERNAME "DB USER", S.OSUSER "CLIENT USER", S.SERVER "SERVER",
         S.MACHINE "MACHINE", S.MODULE "MODULE", S.TERMINAL "TERMINAL",
         S.PROGRAM "PROGRAM", P.PROGRAM "O.S. PROGRAM",
         S.LOGON_TIME "CONNECT TIME", LOCKWAIT "LOCK WAIT",
         SI.PHYSICAL_READS "PHYSICAL READS", SI.BLOCK_GETS "BLOCK GETS",
         SI.CONSISTENT_GETS "CONSISTENT GETS",
         SI.BLOCK_CHANGES "BLOCK CHANGES",
         SI.CONSISTENT_CHANGES "CONSISTENT CHANGES", S.PROCESS "PROCESS",
         P.SPID, P.PID, S.SERIAL#, SI.SID, S.SQL_ADDRESS "ADDRESS",
         S.SQL_HASH_VALUE "SQL HASH", S.ACTION
FROM V$SESSION S, V$PROCESS P, SYS.V_$SESS_IO SI
WHERE S.PADDR = P.ADDR(+)
     AND SI.SID(+) = S.SID
     AND S.USERNAME IS NOT NULL
     AND NVL (S.OSUSER, 'X') <> 'SYSTEM'
     AND S.TYPE <> 'BACKGROUND'
ORDER BY 3;

================================================================================================
#. 26 중복인덱스 체크
================================================================================================
SELECT O1.NAME||'.'||N1.NAME  REDUNDANT_INDEX,
       O2.NAME||'.'||N2.NAME  SUFFICIENT_INDEX
FROM   SYS.ICOL$  IC1,  SYS.ICOL$  IC2,  SYS.IND$  I1,  SYS.OBJ$  N1,
       SYS.OBJ$  N2,  SYS.USER$  O1,  SYS.USER$  O2
WHERE  IC1.POS# = 1 AND  IC2.BO# = IC1.BO# AND  IC2.OBJ# != IC1.OBJ#
AND    IC2.POS# = 1 AND  IC2.INTCOL# = IC1.INTCOL# AND  I1.OBJ# = IC1.OBJ#
AND    BITAND(I1.PROPERTY, 1) = 0
AND    ( SELECT MAX(POS#) * (MAX(POS#) + 1) / 2
         FROM   SYS.ICOL$
         WHERE  OBJ# = IC1.OBJ# ) =
       ( SELECT SUM(XC1.POS#)
         FROM   SYS.ICOL$ XC1,
                SYS.ICOL$ XC2
         WHERE  XC1.OBJ# = IC1.OBJ#
         AND    XC2.OBJ# = IC2.OBJ#
         AND    XC1.POS# = XC2.POS#
         AND    XC1.INTCOL# = XC2.INTCOL# )
AND    N1.OBJ# = IC1.OBJ#
AND    N2.OBJ# = IC2.OBJ#
AND    O1.USER# = N1.OWNER#
AND    O2.USER# = N2.OWNER#;

================================================================================================
#. 27 공간의 90% 이상을 사용하고 있는 Tablespace
================================================================================================
SELECT X.TABLESPACE_NAME,
       TOTAL_SIZE/1024/1024 TOTAL_SIZE,
       USED_SIZE/1024/1024 USED_SIZE,
       (ROUND( USED_SIZE/TOTAL_SIZE,2))*100 USED_RATIO
FROM  (SELECT TABLESPACE_NAME,
              SUM(BYTES) TOTAL_SIZE
       FROM   DBA_DATA_FILES
       GROUP BY TABLESPACE_NAME
      ) X,
      (SELECT TABLESPACE_NAME,
              SUM(BYTES)  USED_SIZE
       FROM   DBA_EXTENTS
       GROUP BY TABLESPACE_NAME
      ) Y
WHERE  X.TABLESPACE_NAME = Y.TABLESPACE_NAME (+)
AND    Y.USED_SIZE > .9 * X.TOTAL_SIZE;

================================================================================================
#. 28 현재 Extension 횟수가 MaxExtents의 80% 이상인 경우
================================================================================================
SELECT TABLESPACE_NAME,
       OWNER,
       SEGMENT_NAME,
       SEGMENT_TYPE,
       EXTENTS,
       MAX_EXTENTS
FROM   SYS.DBA_SEGMENTS S
WHERE  EXTENTS / MAX_EXTENTS > .8
AND    MAX_EXTENTS > 0
ORDER BY TABLESPACE_NAME, OWNER, SEGMENT_NAME ;

================================================================================================
#. 29 Active Session 중 Idle Time이 긴 작업
================================================================================================
SELECT VS.SID ||','|| VS.SERIAL# " SID" ,
       VP.SPID,
       VS.MACHINE,
       VS.PROGRAM,
       VS.MODULE,
       VS.STATUS ,
       TO_CHAR (VS.LOGON_TIME, 'MM/DD HH24:MI' ) LOGIN_TIME,
       ROUND(VS.LAST_CALL_ET/60) "IDLE"
FROM   V$SESSION VS,
       V$PROCESS VP
WHERE  VS.STATUS = 'ACTIVE'
AND    VS.SID NOT IN (1,2,3,4,5,6,7)
AND    VS.PADDR = VP.ADDR
ORDER BY 8;

================================================================================================
#. 30 DBUser 별로 Session 정보를 조회
================================================================================================
SELECT S.USERNAME,
       S.SID,
       S.SERIAL#,
       P.SPID,
       S.OSUSER,
       S.MACHINE,
       S.PROGRAM,
       TO_CHAR(S.LOGON_TIME, 'MM/DD HH24:MI') "LOGON_TIME",
       ROUND(S.LAST_CALL_ET/60) "IDLE"
FROM   V$SESSION S,
       V$PROCESS P
WHERE  S.PADDR = P.ADDR
AND    S.USERNAME LIKE UPPER('&DBUSER%')
ORDER BY 9;

================================================================================================
#. 31 사용자 session 중에서 2시간 이상 idle 상태가 지속되는 session을 kill
================================================================================================
SET PAGESIZE 0
SPOOL KILLIDLE3.SQL

SELECT DISTINCT '!KILL -9 ' || B.SPID,
      'ALTER SYSTEM KILL SESSION ''' || A.SID || ',' || A.SERIAL# || ''' ;'
FROM   V$SESSION A,
       V$PROCESS B
WHERE  A.PADDR IN
      (SELECT S.PADDR
       FROM   V$SESSION S
       WHERE  STATUS = 'INACTIVE'
       GROUP BY S.PADDR
       HAVING MIN(ROUND(LAST_CALL_ET/60)) > 120 )
AND    A.PADDR = B.ADDR
AND    A.STATUS = 'INACTIVE';

SPOOL OFF

================================================================================================
#. 32 사용자별 오브젝트 수
================================================================================================
SELECT OWNER                                        AS "OWNER",
       SUM(DECODE(OBJECT_TYPE,'TABLE',1,0))         AS "TABLE",
       SUM(DECODE(OBJECT_TYPE,'INDEX',1,0))         AS "INDEX",
       SUM(DECODE(OBJECT_TYPE,'SYNONYM',1,0))       AS "SYNONYMS",
       SUM(DECODE(OBJECT_TYPE,'SEQUENCE',1,0))      AS "SEQUENCES",
       SUM(DECODE(OBJECT_TYPE,'VIEW',1,0))          AS "VIEWS",
       SUM(DECODE(OBJECT_TYPE,'CLUSTER',1,0))       AS "CLUSTERS",
       SUM(DECODE(OBJECT_TYPE,'DATABASE LINK',1,0)) AS "DBLINKS",
       SUM(DECODE(OBJECT_TYPE,'PACKAGE',1,0))       AS "PACKAGES",
       SUM(DECODE(OBJECT_TYPE,'PACKAGE BODY',1,0))  AS "PACKAGE_BODY",
       SUM(DECODE(OBJECT_TYPE,'PROCEDURE',1,0))     AS "PROCEDURES",
       SUM(DECODE(OBJECT_TYPE,'FUNCTION',1,0))      AS "FUNCTION"
FROM   DBA_OBJECTS
GROUP BY OWNER;

================================================================================================
#. 33 Object별 테이블스페이스 및 데이터파일
================================================================================================
SELECT DISTINCT E.SEGMENT_NAME,
       E.TABLESPACE_NAME,
       F.FILE_NAME
FROM   DBA_EXTENTS E,
       DBA_DATA_FILES F
WHERE  E.FILE_ID      = F.FILE_ID
AND    E.SEGMENT_TYPE = 'TABLE'
AND    E.TABLESPACE_NAME NOT IN ('SYSTEM', 'TOOLS');

================================================================================================
#. 34 작업 중인 데이터베이스 트랜잭션 조회
================================================================================================
SELECT S.SID,
       S.SERIAL#,
       S.STATUS,
       S.OSUSER,
       S.USERNAME,
       T.STATUS,
       T.START_TIME
FROM   V$SESSION S,
       V$TRANSACTION T,
       DBA_ROLLBACK_SEGS R
WHERE  S.TADDR  = T.ADDR
AND    T.XIDUSN = R.SEGMENT_ID;

================================================================================================
#. 35 열려 있는 커서 조회
================================================================================================
SELECT A.SID,
       A.OSUSER,
       COUNT(B.SID) AS "CURSOR",
       A.PROGRAM,
       A.STATUS
FROM   V$SESSION A,
       V$OPEN_CURSOR B
WHERE  A.SID = B.SID(+)
GROUP BY A.SID, A.OSUSER, A.PROGRAM, A.STATUS;

================================================================================================
#. 36 잠금 발생 유형 조회
================================================================================================
SELECT A.SID,
       DECODE(A.TYPE,
              'MR', 'MEDIA RECOVERY',
              'RT', 'REDO THREAD',
              'UN', 'USER_NAME',
              'TX', 'TRANSACTION',
              'TM', 'DML',
              'UL', 'PL/SQL USER LOCK',
              'DX', 'DISTRIBUTED XACTION',
              'CF', 'CONTROL FILE',
              'IS', 'INSTANCE STATE',
              'FS', 'FILE SET',
              'IR', 'INSTANCE RECOVERY',
              'FS', 'FILE SET',
              'ST', 'DISK SPACE TRANSACTION',
              'TS', 'TEMP SEGMENT',
              'IV', 'LIBRARY CACHE INVAILDATION',
              'LS', 'LOG START OR SWITCH',
              'RW', 'ROW WAIT',
              'SQ', 'SEQUENCE NUMBER',
              'TE', 'EXTEND TABLE',
              'TT', 'TEMP TABLE',
              A.TYPE) AS "LOCK_TYPE",
       DECODE(A.LMODE,
              0, 'NONE',
              1, 'NULL',
              2, 'ROW-S(SS)',
              3, 'ROW-X(SX)',
              4, 'SHARE',
              5, 'S/ROW-X(SSX)',
              6, 'EXCLUSIVE',
              TO_CHAR(A.LMODE)) AS "MODE_HELD",
       DECODE(A.REQUEST,
              0, 'NONE',
              1, 'NULL',
              2, 'ROW-S(SS)',
              3, 'ROW-X(SX)',
              4, 'SHARE',
              5, 'S/ROW-X(SSX)',
              6, 'EXCLUSIVE',
              TO_CHAR(A.REQUEST)) AS "MODE_REQUESTED",
       TO_CHAR(A.ID1) AS "LOCK_ID1",
       TO_CHAR(A.ID2) AS "LOCK_ID2",
       DECODE(BLOCK, 0, 'NOT BLOCKING',
                     1, 'BLOCKING',
                     2, 'GLOBAL',
                     TO_CHAR(BLOCK)) AS "BLOCKING_OTHERS"             
FROM   V$LOCK A
WHERE (ID1, ID2) IN ( SELECT B.ID1, ID2
                      FROM   V$LOCK B
WHERE  B.ID1 = A.ID1 );

================================================================================================
#. 37 테이블의 PK를 구성하는 컬럼 조회
================================================================================================
SELECT A.TABLE_NAME,
       B.CONSTRAINT_NAME,
       C.COLUMN_NAME     
FROM   USER_TABLES A,
       USER_CONSTRAINTS B,
       USER_CONS_COLUMNS C
WHERE  A.TABLE_NAME = B.TABLE_NAME
AND    B.CONSTRAINT_NAME = C.CONSTRAINT_NAME
AND    B.CONSTRAINT_TYPE = 'P';

================================================================================================
#. 38 오브젝트에 접속되어 있는 프로그램 조회
================================================================================================
SELECT SUBSTR(B.OBJECT,1,15)  AS OBJECT,
       SUBSTR(A.PROGRAM,1,15) AS PROGRAM,
       COUNT(*)               AS CNT
FROM   V$SESSION A,
       V$ACCESS B
WHERE  A.SID = B.SID
AND    B.OWNER NOT IN ('SYS')
AND    A.TYPE != 'BACKGROUND'
AND    B.OBJECT LIKE UPPER('&OBJECT_NAME')||'%'
GROUP BY B.OBJECT, SUBSTR(A.PROGRAM,1,15);

================================================================================================
#. 39 잠금 상태 오브젝트 조회
================================================================================================
SELECT A.SESSION_ID,
       B.SERIAL#,
       A.OS_USER_NAME,
       A.ORACLE_USERNAME,
       C.OBJECT_NAME,
       A.LOCKED_MODE,
       A.XIDUSN
FROM   V$LOCKED_OBJECT A,
       V$SESSION B,
       DBA_OBJECTS C
WHERE  A.OBJECT_ID = C.OBJECT_ID
AND    A.SESSION_ID = B.SID;

================================================================================================
#. 40 잠금 SQL 구문 조회
================================================================================================
SELECT B.USERNAME AS USERNAME,
       C.SID      AS SID,
       C.OWNER    AS OBJECT_OWNER,
       C.OBJECT   AS OBJECT,
       B.LOCKWAIT,
       A.PIECE,
       A.SQL_TEXT AS SQL
FROM   V$SQLTEXT A,
       V$SESSION B,
       V$ACCESS  C
WHERE  A.ADDRESS = B.SQL_ADDRESS
AND    A.HASH_VALUE = B.SQL_HASH_VALUE
AND    B.SID = C.SID
AND    C.OWNER != 'SYS';

================================================================================================
#. 41 롤백 세그먼트 경합 조회
================================================================================================
SELECT NAME T0,
       GETS T1,
       WAITS T2,
       TO_CHAR(TRUNC(WAITS/GETS*100,2),099.99)||' %' T3,
       TO_CHAR(ROUND(RSSIZE/1024)) T4,
       SHRINKS T5,
       EXTENDS T6
FROM   V$ROLLSTAT,
       V$ROLLNAME
WHERE  V$ROLLSTAT.USN = V$ROLLNAME.USN;

================================================================================================
#. 42 CPU를 많이 사용하는 세션의 식별
================================================================================================
SELECT A.SID,
       C.SERIAL#,
       A.VALUE,
       C.USERNAME,
       C.STATUS,
       C.PROGRAM
FROM   V$SESSTAT A,
       V$STATNAME B,
       V$SESSION C
WHERE  A.STATISTIC# = B.STATISTIC#
AND    A.SID = C.SID
AND    B.NAME = 'CPU used by this session'
AND    A.VALUE > 0
ORDER BY A.VALUE DESC;

================================================================================================
#. 43 Tablespace별 Table, Index 개수
================================================================================================
SELECT OWNER,
       TABLESPACE_NAME,
       SUM(DECODE(SEGMENT_TYPE,'TABLE',1,0)),
       SUM(DECODE(SEGMENT_TYPE,'INDEX',1,0))
FROM   DBA_SEGMENTS
WHERE  SEGMENT_TYPE IN ('TABLE','INDEX')
GROUP BY OWNER, TABLESPACE_NAME;

================================================================================================
#. 44 Disk Read 가 많은 SQL문 찾기
================================================================================================
SELECT DISK_READS,
       SQL_TEXT
FROM   V$SQLAREA
WHERE  DISK_READS > 100
ORDER BY DISK_READS DESC;

================================================================================================
#. 45 Rollback Segment를 사용하고 있는 SQL문 조회
================================================================================================
SELECT A.NAME,
       B.XACTS,
       C.SID,
       C.SERIAL#,
       C.USERNAME,
       D.SQL_TEXT
FROM   V$ROLLNAME    A,
       V$ROLLSTAT    B,
       V$SESSION     C,
       V$SQLTEXT     D,
       V$TRANSACTION E
WHERE  A.USN = B.USN
AND    B.USN = E.XIDUSN
AND    C.TADDR = E.ADDR
AND    C.SQL_ADDRESS = D.ADDRESS
AND    C.SQL_HASH_VALUE = D.HASH_VALUE
ORDER BY A.NAME, C.SID, D.PIECE;

================================================================================================
#. 46 Index가 없는 Table 조회
================================================================================================
SELECT OWNER,
       TABLE_NAME
FROM  (SELECT OWNER,
              TABLE_NAME
       FROM   DBA_TABLES
       MINUS
       SELECT TABLE_OWNER,
              TABLE_NAME
       FROM   DBA_INDEXES)
WHERE  OWNER NOT IN ('SYS','SYSTEM')
ORDER BY OWNER,TABLE_NAME;

================================================================================================
#. 47 오래도록 수행되는 Full Table Scan를 모니터링
================================================================================================
SELECT SID,
       SERIAL#,
       OPNAME,
       TO_CHAR(START_TIME,'HH24:MI:SS') AS "START",
       (SOFAR/TOTALWORK) * 100 AS "PERCENT_COMPLETE"
FROM   V$SESSION_LONGOPS;

================================================================================================
#. 48 System 테이블스페이스에 비시스템 세그먼트 조회
================================================================================================
SELECT OWNER,
       SEGMENT_NAME,
       SEGMENT_TYPE,
       TABLESPACE_NAME
FROM   DBA_SEGMENTS
WHERE  OWNER NOT IN ('SYS','SYSTEM')
AND    TABLESPACE_NAME = 'SYSTEM';

================================================================================================
#. 49 인덱스의 Delete Space 조회
================================================================================================
SELECT NAME,
       LF_ROWS,
       DEL_LF_ROWS,
       (DEL_LF_ROWS/LF_ROWS)*100 AS "DELETE SPACE %"
FROM   INDEX_STATS 
WHERE  NAME = UPPER('&INDEX_NAME');
Delete Space %  값이 20 % 가 넘으면, 그 인덱스는 다시 작성하는 것이 좋다.

================================================================================================
#. 50 Session별 사용 명령어
================================================================================================
SELECT SESS.SID,
       SESS.SERIAL#,
       SUBSTR(SESS.USERNAME,1,10) "USER NAME",
       SUBSTR(OSUSER,1,11) "OS USER",
       SUBSTR(SESS.MACHINE,1,15) "MACHINE NAME",
       STATUS,
       UPPER(DECODE(NVL(COMMAND, 0),
                0,      '---',
                1,      'CREATE TABLE',
                2,      'INSERT -',
                3,      'SELECT -',
                4,      'CREATE CLUST',
                5,      'ALTER CLUST',
                6,      'UPDATE -',
                7,      'DELETE -',
                8,      'DROP -',
                9,      'CREATE INDEX',
                10,     'DROP INDEX',
                11,     'ALTER INDEX',
                12,     'DROP TABLE',
                13,     'CREATE SEQ',
                14,     'ALTER SEQ',
                15,     'ALTER TABLE',
                16,     'DROP SEQ',
                17,     'GRANT',
                18,     'REVOKE',
                19,     'CREATE SYN',
                20,     'DROP SYN',
                21,     'CREATE VIEW',
                22,     'DROP VIEW',
                23,     'VALIDATE IX',
                24,     'CREATE PROC',
                25,     'ALTER PROC',
                26,     'LOCK TABLE',
                27,     'NO OPERATION',
                28,     'RENAME',
                29,     'COMMENT',
                30,     'AUDIT',
                31,     'NOAUDIT',
                32,     'CREATE DBLINK',
                33,     'DROP DB LINK',
                34,     'CREATE DATABASE',
                35,     'ALTER DATABASE',
                36,     'CREATE RBS',
                37,     'ALTER RBS',
                38,     'DROP RBS',
                39,     'CREATE TABLESPACE',
                40,     'ALTER TABLESPACE',
                41,     'DROP TABLESPACE',
                42,     'ALTER SESSION',
                43,     'ALTER USER',
                44,     'COMMIT',
                45,     'ROLLBACK',
                47,     'PL/SQL EXEC',
                48,     'SET TRANSACTION',
                49,     'SWITCH LOG',
                50,     'EXPLAIN',
                51,     'CREATE USER',
                52,     'CREATE ROLE',
                53,     'DROP USER',
                54,     'DROP ROLE',
                55,     'SET ROLE',
                56,     'CREATE SCHEMA',
                58,     'ALTER TRACING',
                59,     'CREATE TRIGGER',
                61,     'DROP TRIGGER',
                62,     'ANALYZE TABLE',
                63,     'ANALYZE INDEX',
                69,     'DROP PROCEDURE',
                71,     'CREATE SNAP LOG',
                72,     'ALTER SNAP LOG',
                73,     'DROP SNAP LOG',
                74,     'CREATE SNAPSHOT',
                75,     'ALTER SNAPSHOT',
                76,     'DROP SNAPSHOT',
                85,     'TRUNCATE TABLE',
                88,     'ALTER VIEW',
                91,     'CREATE FUNCTION',
                92,     'ALTER FUNCTION',
                93,     'DROP FUNCTION',
                94,     'CREATE PACKAGE',
                95,     'ALTER PACKAGE',
                96,     'DROP PACKAGE',
                46,     'SAVEPOINT')) COMMAND,
      SESS.PROCESS "C.PROC",
      PROC.SPID "S.PROC" ,
      TO_CHAR(SESS.LOGON_TIME,'YYYY-MM-DD HH24:MI')
FROM  V$SESSION SESS,
      V$SESSTAT STAT,
      V$STATNAME NAME,
      V$PROCESS PROC
WHERE SESS.SID = STAT.SID
AND   STAT.STATISTIC# = NAME.STATISTIC#
AND   SESS.USERNAME IS NOT NULL
AND   NAME.NAME = 'RECURSIVE CALLS'
AND   SESS.PADDR = PROC.ADDR
ORDER BY 3,1,2;

================================================================================================
#. 51 딕셔너리/뷰 정보 조회
================================================================================================
SELECT A.TABLE_NAME,
       B.COLUMN_NAME
FROM   DICTIONARY A,
       DICT_COLUMNS B
WHERE  A.TABLE_NAME = B.TABLE_NAME;