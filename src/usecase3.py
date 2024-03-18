import sqlite3

def main():

    # Define variables
    date = '2024-02-03'
    ticketType = 'Ordinær'
    orderDate = '2024-02-02'
    orderTime = '17:15:00'
    playTitle = 'Størst av alt er kjærligheten'
    customerID = 3
    orderSum = 0

    try:
        # Connect to the database
        con = sqlite3.connect('src/DB2.db')
        cursor = con.cursor()
        
        # Retrieve necessary IDs from the database
        typeID = cursor.execute("SELECT TypeID FROM Billettype WHERE Typenavn = ?", (ticketType,)).fetchone()[0]
        playID = cursor.execute("SELECT Skuespill_ID FROM Skuespill WHERE Tittel = ?", (playTitle,)).fetchone()[0]
        showID = cursor.execute("SELECT ForestillingID FROM Forestilling WHERE Dato = ? AND Skuespill_ID = ?", (date, playID)).fetchone()[0]
        hallNr = cursor.execute(""" 
                                SELECT SalNr
                                FROM Sal 
                                NATURAL INNER JOIN Skuespill
                                WHERE Tittel = ?
                                """, (playTitle,)).fetchone()[0]

        # Generate ticket ID and order number
        if (cursor.execute("SELECT * FROM Billett").fetchone() == None):
            ticketID = 1
        else:
            ticketID = cursor.execute("SELECT MAX(BillettID) FROM Billett").fetchone()[0]+1
        
        if (cursor.execute("SELECT * FROM Billettkjop").fetchone() == None):
            orderNr = 1
        else:
            orderNr = cursor.execute("SELECT MAX(KjopNr) FROM Billettkjop").fetchone()[0]+1

        # Insert customer record into the database
        cursor.execute("INSERT INTO Kunde VALUES (?)", (customerID,))
        con.commit()

        # Insert order record into the database
        cursor.execute("INSERT INTO Billettkjop (KjopNr, Dato, Tid, KundeID, ForestillingID) VALUES (?, ?, ?, ?, ?)", (orderNr, orderDate, orderTime, customerID, showID))
        con.commit()

        # Retrieve the number of seats in each row of the hall
        numberOfSeatsInRows = cursor.execute("""
                                                SELECT RadID, COUNT(RadID) AS AntallPlasser
                                                FROM Sete
                                                NATURAL INNER JOIN Rad
                                                INNER JOIN Omrade ON (Omrade.SalNr = Rad.SalNr AND Omrade.Navn = Rad.Omradenavn)
                                                WHERE Rad.SalNr = ?
                                                GROUP BY RadID
                                                ORDER BY RadID DESC
                                            """, (hallNr,)).fetchall()
        
        # Iterate over each row and check seat availability
        for row in numberOfSeatsInRows:
            rowID, numberOfSeatsInRow = row

            # check the number of occupied seats in the row
            if (cursor.execute(""" 
                                SELECT COUNT(SeteID) AS OpptatteRadSeter
                                FROM Sete
                                NATURAL INNER JOIN Rad
                                NATURAL INNER JOIN ForestillingBillett
                                WHERE ForestillingID = ? AND RadID = ?
                                GROUP BY RadID
                                ORDER BY OpptatteRadSeter ASC
                                """, (showID, rowID)).fetchone() == None):
                occupiedSeatsInRow = 0
            else:
                occupiedSeatsInRow = cursor.execute(""" 
                                                    SELECT COUNT(SeteID) AS OpptatteRadSeter
                                                    FROM Sete
                                                    NATURAL INNER JOIN Rad
                                                    NATURAL INNER JOIN ForestillingBillett
                                                    WHERE ForestillingID = ? AND RadID = ?
                                                    GROUP BY RadID
                                                    ORDER BY OpptatteRadSeter ASC
                                                    """, (showID, rowID)).fetchone()[0]
            
            #calculate the number of available seats in the row
            availableSeatsInRow = numberOfSeatsInRow - occupiedSeatsInRow
            
            # if there are at least nine available seats, the tickets are purchased
            if availableSeatsInRow >= 9:
                seatsForPurcharse = cursor.execute("""
                                                    SELECT SeteID
                                                    FROM Sete
                                                    NATURAL INNER JOIN Rad
                                                    WHERE SeteID NOT IN (SELECT SeteID
                                                                         FROM Sete
                                                                         NATURAL INNER JOIN Rad
                                                                         NATURAL INNER JOIN ForestillingBillett
                                                                         WHERE ForestillingID = ?)
                                                    AND Rad.SalNr = ?
                                                    ORDER BY RadID DESC
                                                   """, (showID, hallNr)).fetchmany(9)
                
                # Insert ticket records into the database
                for seatID in seatsForPurcharse:
                    cursor.execute("INSERT INTO Billett (TypeID, KjopNr) VALUES (?, ?)", (typeID, orderNr))
                    con.commit()
                    cursor.execute("INSERT INTO ForestillingBillett (ForestillingID, BillettID, SeteID) VALUES (?, ?, ?)", (showID, ticketID, seatID[0]))
                    con.commit()

                    # calculate the order sum
                    orderSum += cursor.execute("""
                                                SELECT Pris 
                                                FROM HarBillettType 
                                                WHERE TypeID = ? AND Skuespill_ID = ?""", (typeID, playID)
                                                ).fetchone()[0]
                    ticketID += 1
            break
        
        # print the tot order sum
        print(f"Sum 9 voksenbiletter til Størst av alt er kjærligheten: {orderSum}")
        con.close()
                    
    except Exception as e:
        print(f"Error: {str(e)}")
        return
        
if __name__ == "__main__":
    main()