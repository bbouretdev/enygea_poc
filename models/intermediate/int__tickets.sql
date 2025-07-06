{{ config(alias='tickets') }}

with source_data as (
  select *
  from {{ source('notion', 'notion_tickets') }}
),

exploded as (

  select
    ID as ticket_id,
    CREATED_TIME as created_time,
    LAST_EDITED_TIME as last_edited_time,

    PROPERTIES:"Nom":title[0]:plain_text::string as name,

    -- Simple fields
    PROPERTIES:"État":status:name::string as status,
    PROPERTIES:"Chemin":relation[0]:id::string as path_id,
    PROPERTIES:"Sprint":relation[0]:id::string as sprint_id,
    PROPERTIES:"Projet":relation[0]:id::string as project_id,

    -- Calculated / rollup fields
    PROPERTIES:"Sprint actuel":rollup:array[0]:formula:boolean::boolean as current_sprint,
    PROPERTIES:"Agrégation":rollup:array[0]:number::int as aggregation,
    PROPERTIES:"Nb Tickets Done":formula:number::int as nb_tickets_done,
    PROPERTIES:"Nb Tickets Total":formula:number::int as nb_tickets_total,

    -- ID and Points
    PROPERTIES:"ID":unique_id:prefix::string as ticket_prefix,
    PROPERTIES:"ID":unique_id:number::int as ticket_number,
    PROPERTIES:"Points":relation[0]:id::string as point_id,

    -- Assignment, tags, criticality
    PROPERTIES:"Attribué à":people[0]:name::string as assignee,
    PROPERTIES:"Tags":select:name::string as tag,
    PROPERTIES:"Criticité":select:name::string as criticality,

    -- Last modifications
    LAST_EDITED_TIME as last_modified_at,
    CREATED_TIME as created_at,
    LAST_EDITED_BY:name::string as last_modified_by,

    -- Misc fields
    URL as url,
    ARCHIVED as archived,
    IN_TRASH as in_trash

  from source_data

)

select * from exploded