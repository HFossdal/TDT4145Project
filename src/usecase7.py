import sqlite3

"""
Use case 7:

Du skal lage et Pythonprogram (og SQL) som tar et skuespillernavn og finner 
hvilke skuespilllere de har spilt med i samme akt. Skriv ut navn på begge og 
hvilket skuespill det skjedde.
"""

def findCoActors(actorName):
    try:
        con = sqlite3.connect("src/DB2.db")
        cursor = con.cursor()
    except Exception as e:
        print(f"Error: {str(e)}")
        return
    
    cursor.execute("""
                    SELECT DISTINCT Actor.Navn AS 'Skuespiller', CoActorInfo.Navn AS 'Medskuespiller', Skuespill.Tittel AS 'Teaterstykke'
                    FROM Person AS Actor
                    NATURAL INNER JOIN Skuespiller
                    INNER JOIN OppsetningAvSkuespill AS OAS1 ON (Actor.PersonID = OAS1.SkuespillerID)
                    INNER JOIN Rolle USING (RolleID)
                    INNER JOIN DelAv AS DA1 USING (RolleID)
                    INNER JOIN (SELECT *
                                FROM Person AS CoActor
                                NATURAL INNER JOIN Skuespiller
                                INNER JOIN OppsetningAvSkuespill AS OAS2 ON (CoActor.PersonID = OAS2.SkuespillerID)
                                INNER JOIN Rolle USING (RolleID)
                                INNER JOIN DelAv AS DA2 USING (RolleID)
                                ) AS CoActorInfo USING (AktNr, Skuespill_ID)
                    INNER JOIN Skuespill USING (Skuespill_ID)
                    WHERE Actor.PersonID != CoActorInfo.PersonID AND Actor.Navn = ?
                   """, (actorName,))
    coActorsList = cursor.fetchall()

    if len(coActorsList) == 0:
        isActor = cursor.execute("""
                                SELECT COUNT(PersonID)
                                FROM Person
                                NATURAL INNER JOIN Skuespiller
                                WHERE Navn = ?
                                """, (actorName,)).fetchone()[0]
        if (isActor == 0):
            print(f"{actorName} er ikke en registrert skuespiller")
            return
        else:
           print(f"{actorName} har ikke spilt med noen medskuespillere for noe skuespill")
           return

    print(f'{"Skuespiller".center(35)} | {"Medskuespiller".center(35)} | {"Teaterstykke".center(35)}')
    print("   " + "-" * 35 * 3)

    for coActorPair in coActorsList:
           actor, coActor, playTitle = coActorPair
           print(f'{actor.center(35)} | {coActor.center(35)} | {playTitle.center(35)}')

    con.close()

def main():
    while(1):
        actorName = input("Angi skuespillers navn eller skriv Q for å avslutte: ")
        print()
        if (actorName.upper() == 'Q'):
            return
        findCoActors(actorName)
        print()

main()