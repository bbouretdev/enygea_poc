SELECT *
FROM {{ source('notion', 'notion_tickets') }}