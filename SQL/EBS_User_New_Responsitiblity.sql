select distinct user_name,
       application_name,
--       responsibility_name,
--       security_group_name,
       greatest(u.start_date, ur.start_date, r.start_date) start_date,
       least(nvl (u.end_date, nvl(ur.end_date, r.end_date)),
             nvl(ur.end_date, nvl (u.end_date, r.end_date)),
             nvl(r.end_date, nvl (u.end_date, ur.end_date))) end_date,
       to_char(u.last_update_date, 'yyyy-mm-dd') last_update_date,
       to_char(u.creation_date, 'yyyy-mm-dd') creation_date
  from fnd_user               u,
       fnd_user_resp_groups   ur,
       fnd_responsibility_vl  r,
       fnd_application_vl     a,
       fnd_security_groups_vl s
 where a.application_id = r.application_id
   and u.user_id = ur.user_id
   and r.application_id = ur.responsibility_application_id
   and r.responsibility_id = ur.responsibility_id
   and ur.start_date <= sysdate
   and nvl(ur.end_date, sysdate + 1 ) > sysdate
   and u.start_date <= sysdate
   and nvl(u.end_date, sysdate + 1 ) > sysdate
   and r.start_date <= sysdate
   and nvl(r.end_date, sysdate + 1 ) > sysdate
   and ur.security_group_id = s.security_group_id
   and to_char( greatest(u.start_date, ur.start_date, r.start_date), 'yyyy-mm-dd') between '2015-11-01' and '2016-03-31'
   and to_char(u.last_update_date, 'yyyy-mm-dd') between '2015-11-01' and '2016-03-31'
   and to_char(u.creation_date, 'yyyy-mm-dd') not between '2015-11-01' and '2016-03-31'
 order by user_name
--          application_name,
--          responsibility_name,
 --         security_group_name;