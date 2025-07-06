{{ config(alias='tickets') }}

SELECT *
FROM {{ source('notion', 'notion_tickets') }}