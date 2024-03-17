import sqlite3

def main():
    filename = 'data/gamle-scene.txt'
    date = '2024-02-03'
    ticketType = 'Ordinær'
    ticketAmount = 9
    seatCounter = 0
    orderDate = '2024-02-02'
    orderTime = '17:15:00'
    areas = ['Galleri', 'Balkong', 'Parkett']
    customerID = 3
    orderSum = 0;
    

    try:
        con = sqlite3.connect('src/DB2.db')
        cursor = con.cursor()

        # Read the input file
        with open(filename, "r") as f:
            
            typeID = cursor.execute("SELECT TypeID FROM Billettype WHERE Typenavn = ?", (ticketType,)).fetchone()[0]
            playID = cursor.execute("SELECT Skuespill_ID FROM Skuespill WHERE Tittel = 'Størst av alt er kjærligheten'").fetchone()[0]
            showID = cursor.execute("SELECT ForestillingID FROM Forestilling WHERE Dato = ? AND Skuespill_ID = ?", (date, playID)).fetchone()[0]
            
            seatID = cursor.execute ("""SELECT MIN(seteID)
                                    FROM Sete INNER JOIN Rad Using (RadID)
                                    INNER JOIN Omrade ON (Rad.Omradenavn = Omrade.Navn AND Rad.SalNr = Omrade.SalNr)
                                    WHERE Omrade.SalNr = (SELECT SalNr 
                                                          FROM Sal 
                                                          WHERE Sal.Navn = 'Gamle scene')
                                     """).fetchone()[0]

            if (cursor.execute("SELECT * FROM Billett").fetchone() == None):
                ticketID = 1
            else:
                ticketID = cursor.execute("SELECT MAX(BillettID) FROM Billett").fetchone()[0]+1
            
            if (cursor.execute("SELECT * FROM Billettkjop").fetchone() == None):
                orderNr = 1
            else:
                orderNr = cursor.execute("SELECT MAX(KjopNr) FROM Billettkjop").fetchone()[0]+1

            cursor.execute("INSERT INTO Kunde VALUES (?)", (customerID,))
            con.commit()
            cursor.execute("INSERT INTO Billettkjop (KjopNr, Dato, Tid, KundeID, ForestillingID) VALUES (?, ?, ?, ?, ?)", (orderNr, orderDate, orderTime, customerID, showID))
            con.commit()

            lines = f.readlines()
            for line in lines:
                line = line[:-1]

                # Ignore date info
                if "Dato" in line:
                    continue
                
                # Ignore area info
                elif line in areas:
                    continue
                        
                elif line.count("0") < 9:
                    seatID += len(line)
                    continue
                
                # Goes through every seat in a row
                for c in line:
                    if (seatCounter == ticketAmount):
                        break
                    
                    # Seat is free
                    if c == "0":
                        cursor.execute("INSERT INTO Billett (TypeID, KjopNr) VALUES (?, ?)", (typeID, orderNr))
                        con.commit()
                        cursor.execute("INSERT INTO ForestillingBillett (ForestillingID, BillettID, SeteID) VALUES (?, ?, ?)", (showID, ticketID, seatID))
                        con.commit()
                        orderSum += cursor.execute("""SELECT Pris 
                                                   FROM HarBillettType 
                                                   WHERE TypeID = ? AND Skuespill_ID = ?""", (typeID, playID)
                                                   ).fetchone()[0]
                        seatCounter += 1
                        seatID += 1
                        ticketID += 1
                    
                    # Seat is occupied    
                    elif c == "1":
                        ticketID += 1
                        seatID += 1
                    
                    # Not a seat    
                    elif c == "x":
                        seatID += 1
            print(f"Sum 9 voksenbiletter til Størst av alt er kjærligheten: {orderSum}")
        con.close()
                    
    except FileNotFoundError:
        print(f"Fil ikke funnet: {filename}")
    except Exception as e:
        print(f"Error: {str(e)}")
        return
        
if __name__ == "__main__":
    main()