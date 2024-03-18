import sqlite3


def printShowsOnDate(date):
    """
    Print shows for a given date and also lists how many tickets that are sold.
    """
    try:

        # connect to the database
        con = sqlite3.connect("src/DB2.db")
        cursor = con.cursor()
    except Exception as e:
        print(f"Error: {str(e)}")
        return
    
    # retrieving shows for the given date from the database
    cursor.execute("""
                   SELECT Skuespill.Tittel, Forestilling.Dato, Forestilling.ForestillingID 
                   FROM Skuespill INNER JOIN Forestilling ON Skuespill.Skuespill_ID = Forestilling.Skuespill_ID 
                   WHERE Dato = ?""", (date,))
    shows = cursor.fetchall()

    # if no shows are found for the given date
    if len(shows) == 0:
        print("Ingen forestillinger funnet for den angitte datoen\n")
        return
    
    # Print the header of the table
    print(f'{"Teaterstykke".center(35)} | {"Dato".center(35)} | {"Billetter solgt".center(35)}')
    print("   " + "-" * 35 * 3)

    # Print the details of each show
    for show in shows:
        title, date, showID = show
        
        # Count the number of tickets sold for each show
        cursor.execute("""
                       SELECT COUNT(*) 
                       FROM Billett 
                       INNER JOIN ForestillingBillett on Billett.BillettID = ForestillingBillett.BillettID 
                       WHERE ForestillingBillett.ForestillingID = ?""", (showID,))
        ticketsSold = cursor.fetchone()[0]
        
        print(f'{title.center(35)} | {date.center(35)} | {str(ticketsSold).center(35)}')
    
    con.close()
    print()


def main():
    while(1):
        date = input("Angi dato (YYYY-MM-DD) eller skriv Q for å avslutte: ")
        if (date.upper() == 'Q'):
            return
        elif len(date) == 10 and date[4] == "-" and date[7] == "-" and date[0:4].isdigit() and date[5:7].isdigit() and date[8:10].isdigit():
            printShowsOnDate(date)
            continue
        print("Ugyldig dato. Dato må angis på formen YYYY-MM-DD")
        print()
        continue

main()




