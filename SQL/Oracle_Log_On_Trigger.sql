create or replace trigger MAXIMO_LOGON_TRIGGER AFTER logon on MAXIMO.schema
declare
--hFile utl_file.file_type;
user_context varchar2(100);
begin
        if upper(to_char(SYS_CONTEXT('USERENV','HOST'))) NOT in
          ('SELNAPLVORAAD02',
          'SELNAPWVMAXDD01',
          'SELNAPWVMAXDD02',
          'SELNAPWVMAXDP01',
          'SELNAPLVORAAD03',
          'SELNAPLVORADD02',
          'SELNAPLVORADD03',
          'SELNAPLVORAAP01',
          'SELNAPLVORAAP02',
          'SELNAPLVORAAP03',
          'SELNAPLVORADP02',
          'SELNAPLVORADP03',
          'SELNAPLVTIBAQ01',
          'SEOULORA20',
          'SEOULORA21',
          'NOVELIS\SROWM14027',
          'SELNAPWVFBSAD01',
          'SELNAPWVFBSAP01',
          'NOVELIS\SELNAPWVMESDP04',
          'NOVELIS\SELNAPWVMESDP05',
          'NOVELIS\SELNAPWVBIADP01',
          'SELNAPLVTIBAP01.NOVELIS.BIZ',
          'SELNAPLVTIBAP02.NOVELIS.BIZ',
          'SELNAPLVTIBAP03.NOVELIS.BIZ',
          'SELNAPLVTIBAP04.NOVELIS.BIZ',
          'SELNAPLVTIBAP05.NOVELIS.BIZ',
          'SELNAPLVTIBAP01',
          'SELNAPLVTIBAP02',
          'SELNAPLVTIBAP03',
          'SELNAPLVTIBAP04',
          'SELNAPLVTIBAP05',
          'NOVELIS\INSIDEKOREADB',
          'SELNAPLVTIBAP04/10.93.11.91',
          'NOVELIS\SELNAPWVWEBAP02',
          'SELNAPLVTIBAP02/10.93.11.89') THEN
--          hFile := utl_file.fopen('/APP/oracle/PROD/temp', 'connection.log', 'a');
          insert into system.MAXIMO_LOGON_TRIGGER (log_date, HOST, IP_ADDRESS, SESSION_USER_0, SESSION_USERID_0, STATUS,OS_USER,SESSION_ID_0)
          select to_char(sysdate, 'YYYY-MM-DD HH24:MI'), SYS_CONTEXT('USERENV','HOST'),SYS_CONTEXT('USERENV', 'IP_ADDRESS'),SYS_CONTEXT('USERENV', 'SESSION_USER'),SYS_CONTEXT('USERENV','SESSION_USERID'), 'LOGON --',SYS_CONTEXT('USERENV','OS_USER'), SYS_CONTEXT('USERENV','SESSIONID') from dual;
--          SELECT to_char(sysdate, 'YYYY-MM-DD HH24:MI:SS') || ' ' || SYS_CONTEXT('USERENV','HOST') || ' ' ||SYS_CONTEXT('USERENV', 'IP_ADDRESS') || ' ' || SYS_CONTEXT('USERENV', 'SESSION_USER') || ' ' || --SYS_CONTEXT('USERENV','SESSION_USERID') || ' ' || SYS_CONTEXT('USERENV','OS_USER') || ' ' || SYS_CONTEXT('USERENV','SESSIONID') into user_context FROM dual;
--          utl_file.putf(hFile, '%s %s %s LOGON', to_char(sysdate, 'YYYY-MM-DD HH24:MI:SS'), SYS_CONTEXT('USERENV','HOST'), SYS_CONTEXT('USERENV', 'IP_ADDRESS'), SYS_CONTEXT('USERENV', 'SESSION_USER'));
--          UTL_MAIL.send('oraprod@novelis.com','jinkwan.hong@novelis.com',NULL,NULL,'Apps Logon', user_context,'text/plain; charset=eue-kr',NULL);
--          utl_file.fclose(hFile);
          COMMIT;
  end if;
--exception
--        when others then
--                if utl_file.is_open(hFile) then
--                        utl_file.fclose(hFile);
--                end if;
end;