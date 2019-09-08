select
       res.RESPONSIBILITY_ID
     , res.responsibility_name
     , app.application_name
     , app.APPLICATION_ID
     , exc.RULE_TYPE
     , decode(exc.rule_type,'F',(select function_name || ',' || description
                                   from fnd_form_functions_vl fnc
                                  where fnc.function_id = exc.action_id
                                )
                           ,'M',(select menu_name || ',' || description
                                   from fnd_menus_vl imn
                                   where imn.menu_id = exc.action_id
                                )
                           , to_char(exc.action_id)
             ) Excluded_Menu_Or_func
     , exc.ACTION_ID
  from apps.fnd_responsibility_vl res
     , apps.fnd_application_vl    app
     , apps.fnd_data_groups       dat
     , apps.fnd_menus_vl          mnu
     , apps.fnd_request_groups    req
     , apps.fnd_application_vl    apd
     , apps.fnd_application_vl    apr
     , apps.fnd_resp_functions    exc
 where res.application_id            = app.application_id
   and res.data_group_id             = dat.data_group_id
   and res.data_group_application_id = apd.application_id
   and res.menu_id                   = mnu.menu_id
   and req.request_group_id          = res.request_group_id
   and req.application_id            = res.group_application_id
   and apr.application_id            = req.application_id
   and exc.application_id            = res.application_id
   and exc.responsibility_id         = res.responsibility_id
   AND res.RESPONSIBILITY_NAME IN (select
DISTINCT       responsibility_name
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
);