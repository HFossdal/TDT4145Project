-- Brukstilfelle 3

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
												