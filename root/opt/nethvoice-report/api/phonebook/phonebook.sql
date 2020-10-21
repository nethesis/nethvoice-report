SELECT
    DISTINCT name,
    homephone,
    workphone,
    cellphone
FROM
    phonebook
WHERE
    (
        name IS NOT NULL
        OR name != ""
    )
    AND (
        homephone IS NOT NULL
        OR homephone != ""
    )
    AND (
        workphone IS NOT NULL
        OR workphone != ""
    )
    AND (
        cellphone IS NOT NULL
        OR cellphone != ""
    )
ORDER BY
    name;