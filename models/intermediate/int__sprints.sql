{{ config(alias='sprints') }}

with source_data as (
  select *
  from {{ source('notion', 'notion_sprints') }}
),

exploded as (

  select
    ID as sprint_id,
    CREATED_TIME as created_time,
    LAST_EDITED_TIME as last_edited_time,

    PROPERTIES:"Nom":title[0]:plain_text::string as name,

    PROPERTIES:"Période du sprint":date:start::date as period_start,
    PROPERTIES:"Période du sprint":date:end::date as period_end,

    PROPERTIES:"Sprint actuel":formula:boolean::boolean as current_sprint,

    -- On laisse le rollup array brut en variant (json) pour l'instant
    PROPERTIES:"Agrégation":rollup:array as aggregation_json,

    URL as url,
    ARCHIVED as archived,
    IN_TRASH as in_trash

  from source_data

)

select * from exploded