SELECT
    Concat(Group_concat(DISTINCT prefisso SEPARATOR '-'), ",", comune, ",", provincia, ",", regione)
FROM
    zone
GROUP BY comune;
