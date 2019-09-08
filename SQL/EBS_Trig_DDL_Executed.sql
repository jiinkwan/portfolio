CREATE OR REPLACE TRIGGER apps.NOV_DDL_TRIGGER
          AFTER DDL ON DATABASE
DECLARE

            S_PROGRAM  VARCHAR2(48);
            S_MACHINE  VARCHAR2(64);
            S_OSUSER   VARCHAR2(32);
            S_IP       VARCHAR2(32);
            S_SQLERRM  VARCHAR2(128);
            S_SQL_LIST ORA_NAME_LIST_T;
            S_SQL_TEXT VARCHAR2(2000) := NULL;
            S_NUMBER   BINARY_INTEGER;

          BEGIN

           IF DICTIONARY_OBJ_TYPE LIKE 'SEQUE%'
              AND DICTIONARY_OBJ_NAME LIKE 'MRP_%' THEN       
             RETURN;
           END IF;

           SELECT SUBSTRB(PROGRAM,1,48),
                  SUBSTRB(MACHINE,1,64),
                  SUBSTRB(OSUSER,1,32),
                  SUBSTRB(sys_context('USERENV','IP_ADDRESS'),1,32)
           INTO   S_PROGRAM, S_MACHINE, S_OSUSER, S_IP
           FROM   V$SESSION
           WHERE  AUDSID = USERENV('SESSIONID') AND ROWNUM <2 ;

           IF (ORA_SYSEVENT = 'GRANT' or ORA_SYSEVENT = 'REVOKE') THEN
             S_NUMBER := ORA_SQL_TXT (S_SQL_LIST);
             FOR I IN 1..LEAST(S_NUMBER,4) LOOP             -- SQL@: MAX 64*4=256 Bytes
               S_SQL_TEXT := S_SQL_TEXT||S_SQL_LIST(I);
             END LOOP;
           END IF;

           INSERT INTO apps.NOV_DDL_TABLE
                 (
                  GATHER_DATE,
                  USERNAME,
                  OBJECT_TYPE,
                  OBJECT_NAME,
                  ACTION_EVENT,
                  PROGRAM,
                  MACHINE,
                  IP_ADDRESS,
                  OSUSER,
                  SQL_TEXT
                 )
           VALUES( SYSDATE,
                   SUBSTRB(ORA_LOGIN_USER,1,32),
                   SUBSTRB(ORA_DICT_OBJ_TYPE,1,32),
                   SUBSTRB(ORA_DICT_OBJ_NAME,1,128),
                   SUBSTRB(ORA_SYSEVENT,1,32),
                   S_PROGRAM,
                   S_MACHINE,
                   S_IP,
                   S_OSUSER,
                   S_SQL_TEXT );

          EXCEPTION
           WHEN OTHERS THEN
               S_SQLERRM := SUBSTRB('DDL TRIGGER : '||SQLERRM,1,32);
               INSERT INTO apps.NOV_DDL_TABLE
                     (
                      GATHER_DATE,
                      USERNAME,
                      ACTION_EVENT
                     )
               VALUES ( SYSDATE,
                        SUBSTRB(ORA_LOGIN_USER,1,32),
                        S_SQLERRM );
          END;


CREATE TABLE APPS.NOV_DDL_TABLE
(
 GATHER_DATE    DATE,
 USERNAME       VARCHAR2 (32),
 OBJECT_TYPE    VARCHAR2 (32),
 OBJECT_NAME    VARCHAR2 (128),
 ACTION_EVENT   VARCHAR2 (32),
 PROGRAM        VARCHAR2 (72),
 MACHINE        VARCHAR2 (64),
 IP_ADDRESS     VARCHAR2 (32),
 OSUSER         VARCHAR2 (32),
 SQL_TEXT       VARCHAR2 (2000)
)
TABLESPACE APPS_TS_TX_DATA
PCTFREE 5
INITRANS 5
MAXTRANS 255
STORAGE
(
 INITIAL 10485760
 NEXT 131072
 MINEXTENTS 1
 MAXEXTENTS UNLIMITED
 PCTINCREASE 0
 BUFFER_POOL DEFAULT
)
LOGGING
DISABLE ROW MOVEMENT ;

COMMENT ON TABLE APPS.NOV_DDL_TABLE IS 'DDL변경 logging' ;

CREATE INDEX APPS.NOV_DDL_INDEX
ON APPS.NOV_DDL_TABLE
(
 GATHER_DATE ASC
)
TABLESPACE APPS_TS_TX_IDX
PCTFREE 5
INITRANS 5
MAXTRANS 255
STORAGE
(
 INITIAL 1048576
 NEXT 131072
 MINEXTENTS 1
 MAXEXTENTS UNLIMITED
 PCTINCREASE 0
 BUFFER_POOL DEFAULT
)
LOGGING
NOCOMPRESS
NOPARALLEL ;