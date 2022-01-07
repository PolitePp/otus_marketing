select gd.year, gd.month, ga.service, sum(clicks) as sum_clicks, sum(cost) as sum_cost--, gcf.*
from marketing_tutorial.general_costs_facts gcf
left join marketing_tutorial.general_dates gd
on gcf.dates_id = gd.id
left join marketing_tutorial.general_accounts ga
on gcf.account_id = ga.account_id
group by gd.year, gd.month, ga.service
order by gd.year, gd.month, ga.service;

-- What is costs (clicks) dynamics throughout time?
select
       gd.year
        , gd.month
        , sum(clicks) as sum_clicks
        , sum(cost) as sum_cost
from marketing_tutorial.general_costs_facts gcf
left join marketing_tutorial.general_dates gd
on gcf.dates_id = gd.id
group by gd.year, gd.month
order by gd.year, gd.month;

-- What is the proportion of cost sources: Yandex.Direct, Facebook, Google Ads?
select
       ga.service
        , sum(clicks) as sum_clicks
        , round(((sum(clicks) / sum(sum(clicks)) over ()) * 100)::numeric, 2) as clicks_percent
        , sum(cost) as sum_cost
        , round(((sum(cost) / sum(sum(cost)) over ()) * 100)::numeric, 2) as cost_percent
from marketing_tutorial.general_costs_facts gcf
left join marketing_tutorial.general_accounts ga
on gcf.account_id = ga.account_id
group by ga.service
order by ga.service;

-- Is there any tags (UTM) / IDs (campaign, group, ads, keyword) to identify cost context?
select
        (string_to_array(gt.content, '|'))[array_position(string_to_array(gt.content, '|'), 'cid') + 1] as cid
        , (string_to_array(gt.content, '|'))[array_position(string_to_array(gt.content, '|'), 'kwd') + 1] as kwd
        , (string_to_array(gt.content, '|'))[array_position(string_to_array(gt.content, '|'), 'gid') + 1] as gid
        , (string_to_array(gt.content, '|'))[array_position(string_to_array(gt.content, '|'), 'aid') + 1] as aid
from marketing_tutorial.general_costs_facts gcf
left join marketing_tutorial.general_traffic gt
on gcf.traffic_id = gt.id;

select
     --clients
    gc.email as client_email
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

     , alf.price
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
on alf.account_id = ga.account_id;


select
        gcf.id
        , gd.dt

        , gs.domain
        , gs.description

        , ga.status
        , ga.caption
        , ga.enabled
        , ga.service

        , gt.source
        , gt.medium
        , gt.campaign
        , gt.content
        , (string_to_array(gt.content, '|'))[array_position(string_to_array(gt.content, '|'), 'cid') + 1] as cid
        , (string_to_array(gt.content, '|'))[array_position(string_to_array(gt.content, '|'), 'kwd') + 1] as kwd
        , (string_to_array(gt.content, '|'))[array_position(string_to_array(gt.content, '|'), 'gid') + 1] as gid
        , (string_to_array(gt.content, '|'))[array_position(string_to_array(gt.content, '|'), 'aid') + 1] as aid
        , gt.keyword
        , gt.grouping
        , gt.landing_page

        , gcf.vat_included
        , gcf.impressions
        , gcf.clicks
        , gcf.cost
from marketing_tutorial.general_costs_facts gcf
left join marketing_tutorial.general_dates gd
on gcf.dates_id = gd.id
left join marketing_tutorial.general_sites gs
on gcf.sites_id = gs.id
left join marketing_tutorial.general_accounts ga
on gcf.account_id = ga.account_id
left join marketing_tutorial.general_traffic gt
on gcf.traffic_id = gt.id;

-- Leads by status
select distinct al.status
from marketing_tutorial.amocrm_leads_facts alf
inner join marketing_tutorial.amocrm_leads al
on alf.leads_id = al.id;

-- Leads by pipeline
select distinct al.pipeline
from marketing_tutorial.amocrm_leads_facts alf
inner join marketing_tutorial.amocrm_leads al
on alf.leads_id = al.id;

-- Leads by type
select
        distinct ala_source.value
from marketing_tutorial.amocrm_leads_facts alf
left join marketing_tutorial.amocrm_leads_attributes ala_source
on alf.leads_id = ala_source.leads_id
    and ala_source.name = 'Вид услуги';

-- Get utm tags
select
        ala_source.value as source_value
        , ala_medium.value as medium_value
        , ala_campaign.value as campaign_value
        , ala_content.value as content_value
        , (string_to_array(ala_content.value, '|'))[array_position(string_to_array(ala_content.value, '|'), 'cid') + 1] as cid
        , (string_to_array(ala_content.value, '|'))[array_position(string_to_array(ala_content.value, '|'), 'kwd') + 1] as kwd
        , (string_to_array(ala_content.value, '|'))[array_position(string_to_array(ala_content.value, '|'), 'gid') + 1] as gid
        , (string_to_array(ala_content.value, '|'))[array_position(string_to_array(ala_content.value, '|'), 'aid') + 1] as aid
from marketing_tutorial.amocrm_leads_facts alf
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
    and ala_content.name = 'utm_content';

--Are there any identifiers to link to Costs (utm tags, client IDs)? What is the proportion of NOT NULL / NULL of these tags?
select
        round((count(ala_source.value)::numeric / count(*)) * 100, 1) as source_value_not_null
        , 100 - round((count(ala_source.value)::numeric / count(*)) * 100, 1) as source_value_null
        , round((count(ala_medium.value)::numeric / count(*)) * 100, 1) as medium_value_not_null
        , 100 - round((count(ala_medium.value)::numeric / count(*)) * 100, 1) as medium_value_null
        , round((count(ala_campaign.value)::numeric / count(*)) * 100, 1) as campaign_value_not_null
        , 100 - round((count(ala_campaign.value)::numeric / count(*)) * 100, 1) as campaign_value_null
        , round((count(ala_content.value)::numeric / count(*)) * 100, 1) as content_value_not_null
        , 100 - round((count(ala_content.value)::numeric / count(*)) * 100, 1) as content_value_null
from marketing_tutorial.amocrm_leads_facts alf
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
    and ala_content.name = 'utm_content';

-- Can you guess sales funnel (the sequence of lead statuses)?
select distinct al.status
from marketing_tutorial.amocrm_leads_facts alf
inner join marketing_tutorial.amocrm_leads al
on alf.leads_id = al.id;

-- Первичный контакт -> Новые лиды -> Запись на бесплатное -> Прошел бесплатное
-- -> ВОПРОСЫ -> Переговоры -> Ссылка на оплату -> Ждем оплаты -> Должники | Успешно реализовано | Продажа | Закрыто и не реализовано