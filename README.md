# otus_marketing
Файл **pg_scripts.sql** содержит запросы, которые отвечают на вопросы из пункта **Costs: Yandex.Direct, Facebook, Google Ads**

Директория marketing - dbt проект. Используемая СУБД - ClickHouse, сделаны 3 кор объекта, которые позволяют получить всю необходимую информацию (пришлось по лидам делать 2 объекта, т.к. в рамках одного при формировании набора postgres выдаёт ошибку, решил материализовать часть и потом обогатить)
