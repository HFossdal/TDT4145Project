-- Use case 3

/*
	Vi ønsker å få 
	summert hva det koster å kjøpe disse billettene, men du trenger ikke ta 
	hensyn til selve betalingen, den antar vi skjer på et annet system som dere 
	ikke trenger å lage.
*/

SELECT SUM(Pris) AS 'Sum'
FROM HarBillettType
INNER JOIN (SELECT Skuespill_ID
			FROM Skuespill
			WHERE Tittel = 'Størst av alt er kjærligheten'
) AS RelevantSkuespill ON (HarBillettType.Skuespill_ID = RelevantSkuespill.Skuespill_ID)
INNER JOIN Billettype ON (HarBillettType.TypeID = Billettype.TypeID)
INNER JOIN Billett USING (TypeID)
WHERE Billettype.Typenavn = 'Ordinær'
AND KjopNr = (SELECT KjopNr
			  FROM Billettkjop
			  INNER JOIN Kunde ON (Billettkjop.KundeID = Kunde.PersonID)
			  WHERE Kunde.PersonID = 3 AND Billettkjop.ForestillingID = (SELECT ForestillingID
																		 FROM Forestilling
																		 NATURAL INNER JOIN Skuespill
																		 Where Skuespill.Tittel = 'Størst av alt er kjærligheten' AND Forestilling.Dato = '2024-02-03'));		
																	
-- Use case 5

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


-- Use case 6

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