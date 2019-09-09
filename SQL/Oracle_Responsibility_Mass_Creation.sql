select
DISTINCT   'UAL '  ||  responsibility_name,
       application_name,
       'UAL_' || r.RESPONSIBILITY_KEY,
       mnu.USER_MENU_NAME,
       security_group_name,
       req.REQUEST_GROUP_NAME
/*       greatest(u.start_date, ur.start_date, r.start_date) start_date,
       least(nvl(u.end_date, nvl(ur.end_date, r.end_date)),
             nvl(ur.end_date, nvl(u.end_date, r.end_date)),
             nvl(r.end_date, nvl(u.end_date, ur.end_date))) end_date*/
  from fnd_user               u,
       fnd_user_resp_groups   ur,
       fnd_responsibility_vl  r,
       fnd_application_vl     a,
       fnd_security_groups_vl s,
       apps.fnd_menus_vl      mnu,
       apps.fnd_request_groups    req
 where a.application_id = r.application_id
   and u.user_id = ur.user_id
   and r.application_id = ur.responsibility_application_id
   and r.responsibility_id = ur.responsibility_id
   AND mnu.MENU_ID = r.MENU_ID
   AND r.REQUEST_GROUP_ID = req.REQUEST_GROUP_ID
   and ur.start_date <= sysdate
   and nvl(ur.end_date, sysdate + 1 ) > sysdate
   and u.start_date <= sysdate
   and nvl(u.end_date, sysdate + 1 ) > sysdate
   and r.start_date <= sysdate
   and nvl(r.end_date, sysdate + 1 ) > sysdate
   and ur.security_group_id = s.security_group_id
--   and to_char(greatest(u.start_date, ur.start_date, r.start_date), 'yyyy-mm-dd') between '2015-04-01' and '2015-10-31'
   AND USER_NAME IN ('AERA.KIM',
                     'BYOUNGCHUL.HWANG',
                     'BYUNGJIN.NA',
                     'EUNJU.LEE',
                     'GIJU.HWANG',
                     'HYEONHO.AN',
                     'HYUNJUNG.CHOI',
                     'JAESUN.SONG',
                     'MIJIN.KIM',
                     'SOOHO.KIM',
                     'SUNGDO.JUN',
                     'WOONYEOM.KIM',
                     'BYOUNGCHUL.HWANG',
                     'GIJU.HWANG',
                     'GUHWAN.KIM',
                     'HYUNJUNG.CHOI',
                     'SOOBONG.KIM',
                     'SUNGHYO.PARK',
                     'WOONYEOM.KIM',
                     'BYOUNGCHUL.HWANG',
                     'BYUNGJIN.NA',
                     'CHULSOON.KANG',
                     'DAEWOOK.LEE',
                     'GEUNYOUNG.BAE',
                     'HYUNJUNG.CHOI',
                     'JAERYUN.PARK',
                     'KOANGHO.CHA',
                     'SANGYEOB.LEE',
                     'SEUNGHWAN.CHOI',
                     'SUKHYANG.KIM',
                     'SUNGEUN.JEONG',
                     'SUNGHYO.PARK',
                     'WOOJEUNG.KIM',
                     'YOUNGJIN.HONG',
                     'CHULSOON.KANG',
                     'SANGSOO.SHIN')
 order by 1,
          3,
          security_group_name;

권한 목록 업로드 후 프로시져 실행

begin
  -- Call the procedure
  xxran_responsibility;
end;