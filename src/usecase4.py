import sqlite3


def print_shows_on_date(date):
    """
    Print shows for a given date and also lists how many tickets that are sold.
    """
    try:
        con = sqlite3.connect("src/DB2.db")
        cursor = con.cursor()
    except:
        print("Error: Could not connect to the database.")
        return
    
    
    cursor.execute("""
                   SELECT Skuespill.Tittel, Forestilling.Dato, Forestilling.ForestillingID 
                   FROM Skuespill INNER JOIN Forestilling ON Skuespill.Skuespill_ID = Forestilling.Skuespill_ID 
                   WHERE Dato = ?""", (date,))
    shows = cursor.fetchall()

    if len(shows) == 0:
        print("No shows found for the given date.")
        return
    

    for show in shows:
        title, date, forestilling_id = show
        
        cursor.execute("""
                       SELECT COUNT(*) 
                       FROM Billett 
                       INNER JOIN ForestillingBillett on Billett.BillettID = ForestillingBillett.BillettID 
                       WHERE ForestillingBillett.ForestillingID = ?""", (forestilling_id,))
        tickets_sold = cursor.fetchone()[0]
        
        print(f"Show: {title}, Date: {date}, Tickets sold: {tickets_sold}")
        
       

    

    con.close()




def main():
    date = input("Enter date (YYYY-MM-DD): ")
    print_shows_on_date(date)

main()




