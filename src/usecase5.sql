-- Brukstilfelle 5

/*
	Vi ønsker å lage et query i SQL som finner hvilke (navn på) skuespillere som 
	opptrer i de forskjellige teaterstykkene. Skriv ut navn på teaterstykke, navn på 
	skuespiller og rolle.
*/

SELECT Skuespill.Tittel AS 'Teaterstykke', Person.Navn AS 'Skuespiller', Rolle.Navn AS 'Rolle'
FROM OppsetningAvSkuespill
NATURAL INNER JOIN Skuespill
NATURAL INNER JOIN Rolle
INNER JOIN Skuespiller ON (OppsetningAvSkuespill.SkuespillerID = Skuespiller.PersonID)
INNER JOIN Person USING (PersonID);
