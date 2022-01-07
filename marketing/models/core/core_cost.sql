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
        , splitByChar('|', coalesce(content, ''))[indexOf(splitByChar('|', coalesce(content, '')), 'cid') + 1] as cid
        , splitByChar('|', coalesce(content, ''))[indexOf(splitByChar('|', coalesce(content, '')), 'kwd') + 1] as kwd
        , splitByChar('|', coalesce(content, ''))[indexOf(splitByChar('|', coalesce(content, '')), 'gid') + 1] as gid
        , splitByChar('|', coalesce(content, ''))[indexOf(splitByChar('|', coalesce(content, '')), 'aid') + 1] as aid
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
on gcf.traffic_id = gt.id