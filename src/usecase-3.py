import sqlite3

def main():
    filename = "data/gamle-scene.txt"
    date = "2024-02-03"
    ticketType = "Ordinær"
    ticketAmount = 9
    seatCounter = 0
    orderDate = "2024-02-02"
    areas = ["Galleri", "Balkong", "Parkett"]
    showID = cursor.execute("SELECT ForestillingID FROM Forestilling WHERE Dato = ?", (date,)).fetchone()[0]

    try:
        con = sqlite3.connect('src/DB2.db')
        cursor = con.cursor()

        # Read the input file
        with open(filename, "r") as f:

            if (cursor.execute("SELECT * FROM Rad").fetchone() == None):
                rowID = 1
            else:
                rowID = cursor.execute("SELECT MAX(RadID) FROM Rad").fetchone()[0]+1

            if (cursor.execute("SELECT * FROM Sete").fetchone() == None):
                seatID = 1
            else:
                seatID = cursor.execute("SELECT MAX(SeteID) FROM Sete").fetchone()[0]+1

            if (cursor.execute("SELECT * FROM Billett").fetchone() == None):
                ticketID = 1
            else:
                ticketID = cursor.execute("SELECT MAX(BillettID) FROM Billett").fetchone()[0]+1
            
            if (cursor.execute("SELECT * FROM Billettkjop").fetchone() == None):
                orderNr = 1
            else:
                orderNr = cursor.execute("SELECT MAX(KjopNr) FROM Billettkjop").fetchone()[0]+1 # problem! if run multiple times, we'll get multiple orders of same seats to same show

            cursor.execute("INSERT INTO Billettkjop (KjopNr, Dato, Tid, KundeID, ForestillingID) VALUES (?, ?, ?, ?, ?)", (orderNr, orderDate, startTime, customerID, playID))
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
                
                seatNr = 1
                # Goes through every seat in a row
                for c in line:
                    # Seat is free
                    if c == "0":
                        seatID += 1
                        seatNr += 1
                        seatCounter += 1
                    
                    # Seat is occupied    
                    elif c == "1":
                        ticketID += 1
                        seatID += 1
                        seatNr += 1
                    
                    # Not a seat    
                    elif c == "x":
                        seatID += 1
                        seatNr += 1
                
                rowID += 1
                rowNr -= 1   
                
                # When the required amount is reached, we buy
                if seatCounter == ticketAmount:
                    for i in line:
                        if c == "0":
                            cursor.execute("INSERT INTO Sete (SeteID, SeteNr, RadID) VALUES (?, ?, ?)", (seatID, seatNr, rowID))
                            con.commit()
                            cursor.execute("INSERT INTO Billett (TypeID, KjopNr) VALUES (?, ?)", (typeID, orderNr))
                            con.commit()
                            cursor.execute("INSERT INTO ForestillingBillett (ForestillingID, BillettID, SeteID) VALUES (?, ?, ?)", (playID, ticketID, seatID))
                            con.commit()
                            ticketID += 1
                            seatID += 1
                            seatNr += 1
                    break
                
                else:
                    seatCounter = 0
                    ticketID += 1
                    seatID += 1
                    seatNr += 1
                    
    except FileNotFoundError:
        print(f"File not found: {filename}")
        
if __name__ == "__main__":
    main()