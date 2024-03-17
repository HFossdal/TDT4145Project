-- Brukstilfelle 6

/*
	Vi ønsker å lage et query i SQL som finner hvilke forestillinger som har solgt 
	best. Skriv ut navn på forestilling og dato og antall solgte plasser sortert på 
	antall plasser i synkende rekkefølge.
*/

SELECT Skuespill.Tittel AS 'Teaterstykke', Forestilling.Dato, COUNT(Billett.BillettID) AS AntallBilletterSolgt
FROM Forestilling
LEFT OUTER JOIN ForestillingBillett USING (ForestillingID)
LEFT OUTER JOIN Billett USING (BillettID)
INNER JOIN Skuespill USING (Skuespill_ID)
GROUP BY Forestilling.ForestillingID
ORDER BY AntallBilletterSolgt DESC;