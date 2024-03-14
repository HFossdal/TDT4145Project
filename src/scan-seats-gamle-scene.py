import sys
import sqlite3

def main():

    # Check if a filename was provided
    if len(sys.argv) < 2:
        print("Usage: python3 src/scriptname.py data/filename.txt")
        sys.exit(1)

    # The second command line argument is expected to be the filename
    filename = sys.argv[1]

    # Open the file
    try:
        con = sqlite3.connect('src/DB2.db')
        cursor = con.cursor()
        
        # Read the input file
        with open(filename, "r") as f:
            areas = ['Galleri', 'Balkong', 'Parkett']
            ticketType = 'Ordinær'
            typeID = cursor.execute("SELECT TypeID FROM Billettype WHERE Typenavn = ?", (ticketType,)).fetchone()[0]
            hallNr = cursor.execute("SELECT SalNr FROM Sal WHERE Navn = 'Gamle scene'").fetchone()[0]
            playID = cursor.execute("SELECT Skuespill_ID FROM Skuespill WHERE Tittel = 'Størst av alt er kjærligheten'").fetchone()[0]
            customerID = 1
            orderDate = '2024-02-02'
            orderTime = '15:44:00'
            
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
            
            lines = f.readlines()
            for line in lines:
                # Removes newline(\n)
                line = line[:-1]

                # Sets the date
                if "Dato" in line:
                    words = line.split()
                    for word in words:
                        if len(word) == 10 and word[4] == "-" and word[7] == "-":
                            date = word
                            showID = cursor.execute("SELECT ForestillingID FROM Forestilling WHERE Dato = ? AND Skuespill_ID = ?", (date, playID)).fetchone()[0]
                            cursor.execute("INSERT INTO Billettkjop (KjopNr, Dato, Tid, KundeID, ForestillingID) VALUES (?, ?, ?, ?, ?)", (orderNr, orderDate, orderTime, customerID, showID))
                            con.commit()
                            #print(date)
                
                # Sets the area        
                elif line in areas:
                    area = line
                    if area == "Galleri":
                        rowNr = 3
                    elif area == "Balkong":
                        rowNr = 4
                    elif area == "Parkett":
                        rowNr = 10
                    #print(area)
                    
                else:
                    cursor.execute("INSERT INTO Rad (RowID, RadNr, SalNr, Omradenavn) VALUES (?, ?, ?, ?)", (rowID, rowNr, hallNr, area))
                    con.commit()
                    seatNr = 1
                    
                    # Goes through every seat in a row
                    for c in line:
                        # Seat is free
                        if c == "0":
                            #print(f"Seat: free, number: {seatNr}, area: {area}, date: {date}")
                            cursor.execute("INSERT INTO Sete (SeteNr, RadID) VALUES (?, ?)", (seatNr, rowID))
                            con.commit()
                            seatID += 1
                            seatNr += 1
                        
                        # Seat is occupied    
                        elif c == "1":
                            print(f"Seat: occupied, seatNr: {seatNr}, rowNr: {rowNr}, area: {area}, date: {date}")
                            cursor.execute("INSERT INTO Sete (SeteID, SeteNr, RadID) VALUES (?, ?, ?)", (seatID, seatNr, rowID))
                            con.commit()
                            cursor.execute("INSERT INTO Billett (TypeID, KjopNr) VALUES (?, ?)", (typeID, orderNr))
                            con.commit()
                            cursor.execute("INSERT INTO ForestillingBillett (ForestillingID, BillettID, SeteID) VALUES (?, ?, ?)", (showID, ticketID, seatID))
                            con.commit()
                            ticketID += 1
                            seatID += 1
                            seatNr += 1
                        
                        # Not a seat    
                        elif c == "x":
                            seatID += 1
                            seatNr += 1
                            #print(f"Seat: not a seat, number: {seatNr}, area: {area}, date: {date}")
                    
                    rowID += 1
                    rowNr -= 1
                            
        con.close()
                   
    except FileNotFoundError:
        print(f"File not found: {filename}")
        sys.exit(1)

if __name__ == "__main__":
    main()
