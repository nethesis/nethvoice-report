SELECT DISTINCT
   COALESCE(name, ''),
   COALESCE(company, ''),
   COALESCE(homephone, ''),
   COALESCE(workphone, ''),
   COALESCE(cellphone, '')
FROM
   phonebook
WHERE
   (
      name IS NOT NULL
      OR name != ""
      OR company IS NOT NULL
      OR company != ""
   )
   AND
   (
      homephone IS NOT NULL
      OR workphone IS NOT NULL
      OR cellphone IS NOT NULL
   )
ORDER BY
   name;
