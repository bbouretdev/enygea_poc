{{ config(alias='points') }}

with source_data as (
  select *
  from {{ source('notion', 'notion_points') }}
),

exploded as (

  select
    ID as point_id,
    CREATED_TIME as created_time,
    LAST_EDITED_TIME as last_edited_time,

    PROPERTIES:"Nom":title[0]:plain_text::string as name,
    PROPERTIES:"Points":number::int as points,

    URL as url,
    ARCHIVED as archived,
    IN_TRASH as in_trash

  from source_data

)

select * from exploded