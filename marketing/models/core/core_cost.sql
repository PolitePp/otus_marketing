select
        gcf.id as id
        , gd.dt as dt

        , gs.domain as domain
        , gs.description as description

        , ga.status as status
        , ga.caption as caption
        , ga.enabled as enabled
        , ga.service as service

        , gt.source as source
        , gt.medium as medium
        , gt.campaign as campaign
        , gt.content as content
        , splitByChar('|', coalesce(content, ''))[indexOf(splitByChar('|', coalesce(content, '')), 'cid') + 1] as cid
        , splitByChar('|', coalesce(content, ''))[indexOf(splitByChar('|', coalesce(content, '')), 'kwd') + 1] as kwd
        , splitByChar('|', coalesce(content, ''))[indexOf(splitByChar('|', coalesce(content, '')), 'gid') + 1] as gid
        , splitByChar('|', coalesce(content, ''))[indexOf(splitByChar('|', coalesce(content, '')), 'aid') + 1] as aid
        , gt.keyword as keyword
        , gt.grouping as grouping
        , gt.landing_page as landing_page

        , gcf.vat_included as vat_included
        , gcf.impressions as impressions
        , gcf.clicks as clicks
        , case when gcf.account_id = 33203 then gcf.cost * 75.52 else gcf.cost end as cost --Use exchange rate from google on 07.01.2022
from marketing_tutorial.general_costs_facts gcf
left join marketing_tutorial.general_dates gd
on gcf.dates_id = gd.id
left join marketing_tutorial.general_sites gs
on gcf.sites_id = gs.id
left join marketing_tutorial.general_accounts ga
on gcf.account_id = ga.account_id
left join marketing_tutorial.general_traffic gt
on gcf.traffic_id = gt.id