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
    customerID = 1
    

    try:
        con = sqlite3.connect('src/DB2.db')
        cursor = con.cursor()

        # Read the input file
        with open(filename, "r") as f:
            
            typeID = cursor.execute("SELECT TypeID FROM Billettype WHERE Typenavn = ?", (ticketType,)).fetchone()[0]
            
            playID = cursor.execute("SELECT Skuespill_ID FROM Skuespill WHERE Tittel = 'Størst av alt er kjærligheten'").fetchone()[0]
            
            showID = cursor.execute("SELECT ForestillingID FROM Forestilling WHERE Dato = ? AND Skuespill_ID = ?", (date, playID)).fetchone()[0]

            rowID = cursor.execute("""SELECT MIN(RadID)
                                    FROM Rad INNER JOIN Omrade ON (Rad.Omradenavn = Omrade.Navn AND Rad.SalNr = Omrade.SalNr)
                                    WHERE Omrade.SalNr = (SELECT SalNr 
                                                          FROM Sal 
                                                          WHERE Sal.Navn = 'Gamle scene')
                                   """).fetchone()[0]
            
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
                orderNr = cursor.execute("SELECT MAX(KjopNr) FROM Billettkjop").fetchone()[0]+1 # problem! if run multiple times, we'll get multiple orders of same seats to same show

            cursor.execute("INSERT INTO Billettkjop (KjopNr, Dato, Tid, KundeID, ForestillingID) VALUES (?, ?, ?, ?, ?)", (orderNr, orderDate, orderTime, customerID, showID))
            con.commit()

            lines = f.readlines()
            for line in lines:
                line = line[:-1]
                
                # Sets the area
                if line in areas:
                    area = line
                    if area == "Galleri":
                        rowNr = 3
                    elif area == "Balkong":
                        rowNr = 4
                    elif area == "Parkett":
                        rowNr = 10
                        
                elif line.count("0") < 9:
                    rowID += 1
                    rowNr -= 1
                    seatID += len(line)
                    seatNr = 1

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
                        seatCounter += 1
                        seatID += 1
                        seatNr += 1
                        ticketID += 1
                    
                    # Seat is occupied    
                    elif c == "1":
                        ticketID += 1
                        seatID += 1
                        seatNr += 1
                    
                    # Not a seat    
                    elif c == "x":
                        seatID += 1
                        seatNr += 1  
                    
    except FileNotFoundError:
        print(f"File not found: {filename}")
        
if __name__ == "__main__":
    main()