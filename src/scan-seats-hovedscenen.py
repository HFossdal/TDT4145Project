import sys
import sqlite3

def main():

    # Check if a filename was provided
    if len(sys.argv) < 2:
        print("Usage: python src/scriptname.py data/filename.txt")
        sys.exit(1)

    # The second command line argument is expected to be the filename
    filename = sys.argv[1]

    # ANTALL INNSETTINGER AV SETER MÅ MATCHE ANTALL SETER I SAL !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

    # Open the file
    try:
        con = sqlite3.connect('src/DB2.db')
        cursor = con.cursor()
        
        # Read the input file
        with open(filename, "r") as f:
            seatNr = 524           # Number of seats in the hall.
            rowNr = 22             #  Number of rows in the hall. We assume each line, that is, each "row" in the Gallery gets its own row number. 
            areas = ["Galleri", "Parkett"]
            ticketType = "Ordinær"
            typeID = cursor.execute("SELECT TypeID FROM Billettype WHERE Typenavn = ?", (ticketType,)).fetchone()[0]
            hallNr = cursor.execute("SELECT SalNr FROM Sal WHERE Navn = 'Hovedscenen'").fetchone()[0]
            playID = cursor.execute("SELECT Skuespill_ID FROM Skuespill WHERE Tittel = 'Kongsemnene'").fetchone()[0]
            startTime = cursor.execute("SELECT Starttid FROM Skuespill WHERE Skuespill_ID = ?", (playID,)).fetchone()[0]
            showID = cursor.execute("SELECT MAX(ForestillingID) FROM Forestilling").fetchone()[0]+1
            customerID = 1
            orderDate = '2024-02-02'
            
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
            
            if (cursor.execute("SELECT * FROM Forestilling").fetchone() == None):
                playID = 1
            else:
                playID = cursor.execute("SELECT MAX(ForestillingID) FROM Forestilling").fetchone()[0]+1
            
            if (cursor.execute("SELECT * FROM Billettkjop").fetchone() == None):
                orderNr = 1
            else:
                orderNr = cursor.execute("SELECT MAX(KjopNr) FROM Billettkjop").fetchone()[0]+1 # problem! if run multiple times, we'll get multiple orders of same seats to same show

            cursor.execute("INSERT INTO Billettkjop (KjopNr, Dato, Tid, KundeID, ForestillingID) VALUES (?, ?, ?, ?, ?)", (orderNr, orderDate, startTime, customerID, playID))
            con.commit()
            
            lines = f.readlines()
            for line in lines:
                line = line[:-1]
                if "Dato" in line:
                    words = line.split()
                    for word in words:
                        if len(word) == 10 and word[4] == "-" and word[7] == "-":
                            date = word
                            cursor.execute("INSERT INTO Forestilling (ForestillingID, Dato, Skuespill_ID) VALUES (?, ?, ?)", (showID, date, playID))
                            con.commit()
                            #print(date)
                        
                elif line in areas:
                    area = line
                    #print(area)
                    
                else:
                    cursor.execute("INSERT INTO Rad (RowID, RadNr, SalNr, Omradenavn) VALUES (?, ?, ?, ?)", (rowID, rowNr, hallNr, area))
                    con.commit()
                    
                    for c in line[::-1]:
                        if c == "0":
                            #print(f"Seat: free, number: {seatNr}, area: {area}, date: {date}")
                            cursor.execute("INSERT INTO Sete (SeteNr, RadID) VALUES (?, ?)", (seatNr, rowID))
                            con.commit()
                            seatID += 1
                            seatNr -= 1
                            
                        elif c == "1":
                            print(f"Seat: occupied, seatNr: {seatNr}, rowNr: {rowNr}, area: {area}, date: {date}")
                            cursor.execute("INSERT INTO Sete (SeteID, SeteNr, RadID) VALUES (?, ?, ?)", (seatID, seatNr, rowID))
                            con.commit()
                            cursor.execute("INSERT INTO Billett (TypeID, KjopNr) VALUES (?, ?)", (typeID, orderNr))
                            con.commit()
                            cursor.execute("INSERT INTO ForestillingBillett (ForestillingID, BillettID, SeteID) VALUES (?, ?, ?)", (playID, ticketID, seatID))
                            con.commit()
                            ticketID += 1
                            seatID += 1
                            seatNr -= 1
                            
                        elif c == "x":
                            seatID += 1
                            seatNr -= 1
                            #print(f"Seat: not a seat, number: {seatNr}, area: {area}, date: {date}")
                    
                    rowID += 1
                    rowNr -= 1
                            
        con.close()
                   
    except FileNotFoundError:
        print(f"File not found: {filename}")
        sys.exit(1)

if __name__ == "__main__":
    main()
