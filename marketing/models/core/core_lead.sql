select
     cityHash64(coalesce(alf.account_id, 0), coalesce(alf.clientids_id, 0), coalesce(alf.users_id, 0)
     , coalesce(alf.leads_id, 0), coalesce(alf.contacts_id, 0), coalesce(alf.companies_id, 0)
     , coalesce(alf.unsorteds_id, 0), coalesce(alf.created_id, 0), coalesce(alf.closed_id, 0), coalesce(alf.price, 0)) as id
     , alf.leads_id as leads_id

     --clients
     , gc.email as client_email
     , gc.phone as client_phone
     , gc.clientid as client_clientid

     --users
     , au.name as user_name
     , au.group_name as user_group_name

     --leads
     , al.name as lead_name
     , al.status as lead_status
     , al.pipeline as lead_pipeline
     , al.loss_reason as lead_loss_reason
     , al.is_deleted as lead_is_deleted

     --contacts
     , acon.name as contact_name
     , acon.email as contact_email
     , acon.phone as contact_phone

     --companies
     , acmp.name as company_name
     , acmp.email as company_email
     , acmp.phone as company_phone

     , dt_created.dt as dt_created
     , dt_closed.dt as dt_closed

     --accounts
     , ga.status as account_status
     , ga.caption as account_caption
     , ga.enabled as account_enabled
     , ga.service as account_service

     , alf.price as price

     --traffic
--      , ala_source.value as source_value
--      , ala_medium.value as medium_value
--      , ala_campaign.value as campaign_value
--      , ala_content.value as content_value
--      , splitByChar('|', coalesce(ala_content.value, ''))[indexOf(splitByChar('|', coalesce(ala_content.value, '')), 'cid') + 1] as cid
--      , splitByChar('|', coalesce(ala_content.value, ''))[indexOf(splitByChar('|', coalesce(ala_content.value, '')), 'kwd') + 1] as kwd
--      , splitByChar('|', coalesce(ala_content.value, ''))[indexOf(splitByChar('|', coalesce(ala_content.value, '')), 'gid') + 1] as gid
--      , splitByChar('|', coalesce(ala_content.value, ''))[indexOf(splitByChar('|', coalesce(ala_content.value, '')), 'aid') + 1] as aid
from marketing_tutorial.amocrm_leads_facts alf
left join marketing_tutorial.general_clientids gc
on alf.clientids_id = gc.id
left join marketing_tutorial.amocrm_users au
on alf.users_id = au.id
left join marketing_tutorial.amocrm_leads al
on alf.leads_id = al.id
left join marketing_tutorial.amocrm_contacts acon
on alf.contacts_id = acon.id
left join marketing_tutorial.amocrm_companies acmp
on alf.companies_id = acmp.id
left join marketing_tutorial.general_dates dt_created
on alf.created_id = dt_created.id
left join marketing_tutorial.general_dates dt_closed
on alf.closed_id = dt_closed.id
left join marketing_tutorial.general_accounts ga
on alf.account_id = ga.account_id
-- left join marketing_tutorial.amocrm_leads_attributes ala_source
-- on alf.leads_id = ala_source.leads_id
--     and ala_source.name = 'utm_source'
-- left join marketing_tutorial.amocrm_leads_attributes ala_medium
-- on alf.leads_id = ala_medium.leads_id
--     and ala_medium.name = 'utm_medium'
-- left join marketing_tutorial.amocrm_leads_attributes ala_campaign
-- on alf.leads_id = ala_campaign.leads_id
--     and ala_campaign.name = 'utm_campaign'
-- left join marketing_tutorial.amocrm_leads_attributes ala_content
-- on alf.leads_id = ala_content.leads_id
--     and ala_content.name = 'utm_content'