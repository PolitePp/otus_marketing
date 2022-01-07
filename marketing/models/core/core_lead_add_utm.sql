select
     alf.id as id

     --clients
     , client_email
     , client_phone
     , client_clientid

     --users
     , user_name
     , user_group_name

     --leads
     , lead_name
     , lead_status
     , lead_pipeline
     , lead_loss_reason
     , lead_is_deleted

     --contacts
     , contact_name
     , contact_email
     , contact_phone

     --companies
     , company_name
     , company_email
     , company_phone

     , dt_created
     , dt_closed

     --accounts
     , account_status
     , account_caption
     , account_enabled
     , account_service

     , alf.price

     --traffic
     , ala_source.value as source_value
     , ala_medium.value as medium_value
     , ala_campaign.value as campaign_value
     , ala_content.value as content_value
     , splitByChar('|', coalesce(ala_content.value, ''))[indexOf(splitByChar('|', coalesce(ala_content.value, '')), 'cid') + 1] as cid
     , splitByChar('|', coalesce(ala_content.value, ''))[indexOf(splitByChar('|', coalesce(ala_content.value, '')), 'kwd') + 1] as kwd
     , splitByChar('|', coalesce(ala_content.value, ''))[indexOf(splitByChar('|', coalesce(ala_content.value, '')), 'gid') + 1] as gid
     , splitByChar('|', coalesce(ala_content.value, ''))[indexOf(splitByChar('|', coalesce(ala_content.value, '')), 'aid') + 1] as aid
from {{ ref('core_lead')}} alf
left join marketing_tutorial.amocrm_leads_attributes ala_source
on alf.leads_id = ala_source.leads_id
    and ala_source.name = 'utm_source'
left join marketing_tutorial.amocrm_leads_attributes ala_medium
on alf.leads_id = ala_medium.leads_id
    and ala_medium.name = 'utm_medium'
left join marketing_tutorial.amocrm_leads_attributes ala_campaign
on alf.leads_id = ala_campaign.leads_id
    and ala_campaign.name = 'utm_campaign'
left join marketing_tutorial.amocrm_leads_attributes ala_content
on alf.leads_id = ala_content.leads_id
    and ala_content.name = 'utm_content'