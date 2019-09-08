--1. Buffer Cache Hit Ratio

SELECT ROUND(((1-(SUM(DECODE(name, 'physical reads', value,0))/
(SUM(DECODE(name, 'db block gets', value,0))+
(SUM(DECODE(name, 'consistent gets', value, 0))))))*100),2) || '%' "Buffer Cache Hit Ratio"
FROM V$SYSSTAT;

--2. Library Cache Hit Ratio

SELECT (1-SUM (reloads)/SUM(pins))*100 "Library Cache Hit Ratio"
From V$LIBRARYCACHE;


--3. Data Dictionary Cache Hit Ratio

SELECT (1-SUM(getmisses)/SUM(gets))*100 "Data Dictionary Hit Ratio"
FROM V$ROWCACHE;

 

-- 테이블 스페이스 사용량

SELECT a.tablespace_name,
             a.total "Total(Mb)",
             a.total - b.free "Used(Mb)",
             nvl(b.free,0) "Free(Mb)",
             round((a.total - nvl(b.free,0))*100/total,0)  "Used(%)"
from    (   select     tablespace_name,
                            round((sum(bytes)/1024/1024),0) as total
               from       dba_data_files
               group by tablespace_name) a,
         (     select     tablespace_name,
                             round((sum(bytes)/1024/1024),0) as free
               from        dba_free_space
               group by  tablespace_name) b
where      a.tablespace_name = b.tablespace_name(+)
order by   a.tablespace_name;

 
--오라클서버의 메모리

select * from v$sgastat

select pool, sum(bytes) "SIZE"
from v$sgastat
where pool = 'shared pool'
group by pool



--cpu를 많이 사용하는 쿼리문과 프로세스아이디,시리얼번호,머신 알아내기

select c.sql_text
,b.SID
, b.SERIAL#
,b.machine
,b.OSUSER
,b.logon_time --이 쿼리를 호출한 시간
from v$process a, v$session b, v$sqltext c
where a.addr = b.paddr
and b.sql_hash_value = c.hash_value
--and a.spid = '675958'
order by c.PIECE

 
 
--cpu를 많이 사용하는 쿼리문과 프로세스아이디,시리얼번호,머신 알아내기

select c.sql_text
from v$process a, v$session b, v$sqltext c
where a.addr = b.paddr
and b.sql_hash_value = c.hash_value
and a.spid = '171'
order by c.PIECE



--프로세스 아이디를 이용하여 쿼리문 알아내기

select c.sql_text
,b.SID
, b.SERIAL#
,b.machine
,b.OSUSER
,b.logon_time --이 쿼리를 호출한 시간
from v$process a, v$session b, v$sqltext c
where a.addr = b.paddr
and b.sql_hash_value = c.hash_value
and a.spid = '1708032' --1912870/
order by c.PIECE

  

--세션 죽이기(SID,SERAIL#)

--ALTER SYSTEM KILL SESSION '8,4093'

--오라클 세션과 관련된 테이블*/

--select count(*) from v$session where machine ='머신이름' and schemaname ='스키마이름'

 

--현재 커서 수 확인

SELECT sid, count(sid) cursor
FROM V$OPEN_CURSOR
WHERE user_name = 'ilips'
GROUP BY sid
ORDER BY cursor DESC

SELECT sql_text, count(sid) cnt
FROM v$OPEN_CURSOR
GROUP BY sql_text
ORDER BY cnt DESC

select * from v$session_wait

select sid, serial#, username, taddr, used_ublk, used_urec
 from v$transaction t, v$session s
 where t.addr = s.taddr;

select *  from sys.v_$open_cursor



--V$LOCK 을 사용한 잠금 경합 모니터링

SELECT s.username, s.sid, s.serial#, s.logon_time,
    DECODE(l.type, 'TM', 'TABLE LOCK',
          'TX', 'ROW LOCK',
       NULL) "LOCK LEVEL",
    o.owner, o.object_name, o.object_type
FROM v$session s, v$lock l, dba_objects o
WHERE s.sid = l.sid
AND o.object_id = l.id1
AND s.username IS NOT NULL

 

--락이 걸린 세션 자세히 알아보기

select a.sid, a.serial#,a.username,a.process,b.object_name,
decode(c.lmode,2,'RS',3,'RX',4,'S',5,'SRX',8,'X','NO') "TABLE LOCK",
decode (a.command,2,'INSERT',3,'SELECT',6,'UPDATE',7,'DELETE',12,'DROP TABLE',26,'LOCK TABLE','UNknown') "SQL",
decode(a.lockwait, NULL,'NO wait','Wait') "STATUS"
from v$session a,dba_objects b, v$lock c
where a.sid=c.sid and b.object_id=c.id1
and c.type='TM'

 

--락이 걸린 세션 간단히 알아보기

select a.sid, a.serial#, b.type, c.object_name, a.program, a.lockwait,
       a.logon_time, a.process, a.osuser, a.terminal
from v$session a, v$lock b, dba_objects c
where a.sid = b.sid
  and b.id1 = c.object_id
  and b.type = 'TM';

select a.sid, a.serial#, a.username, a.process, b.object_name
from v$session a , dba_objects b, v$lock c
where a.sid=c.sid and b.object_id = c.id1
and c.type = 'TM'

 
--락이 걸린 세션을 찾아 내어 세션을 죽이려고 해도 죽지 않는 경우
--아래 쿼리문으로 OS단의 PROCESS ID를 찾아내어 OS에서 죽인다
--kill -9 프로세스아이디

select substr(s.username,1,11) "ORACLE USER", p.pid "PROCESS ID",
s.sid "SESSION ID", s.serial#, osuser "OS USER",
p.spid "PROC SPID",s.process "SESS SPID", s.lockwait "LOCK WAIT"
from v$process p, v$session s, v$access a
where a.sid=s.sid and
p.addr=s.paddr and
s.username != 'SYS'

--위 쿼리문의 결과가 있다면 락이 걸린 세션이 있다는것이므로 아래의 쿼리문으로 세션을 죽인다

ALTER SYSTEM KILL SESSION '11,39061'

1. 세션별 CPU Time, Memory 사용량
 
select s.sid, s.serial#, p.spid as "os pid", s.username, s.module, s.sql_id, event, seconds_in_wait,
st.value/100 as "cpu sec",
round(pga_used_mem/1024/1024) "pga_tot(mb)",
round(pga_used_mem/1024/1024) "pga_per_sess(mb)"
from v$sesstat st, v$statname sn, v$session s, v$process p
where sn.name = 'CPU used by this session' -- cpu
and st.statistic# = sn.statistic#
and st.sid = s.sid
and s.paddr = p.addr
and s.last_call_et < 1800 -- active within last 1/2 hour
and s.logon_time > (SYSDATE - 240/1440) -- sessions logged on within 4 hours
order by st.value
 
 
 
 
2. Client별 Memory 사용량
 
select machine,status,count(*) cnt, 
       round(sum(pga_used_mem)/1024/1024) "pga_tot(mb)",
       round(sum(pga_used_mem)/count(*)/1024/1024) "pga_per_sess(mb)"
from v$session s, v$process p
where 1=1
--and s.status='active'
and s.paddr=p.addr
and type <> 'BACKGROUND'
group by machine,status
order by 1
 
 