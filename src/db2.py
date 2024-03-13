import sqlite3
con = sqlite3.connect('src/DB2.db')
cursor = con.cursor()
cursor.execute('SELECT * FROM Person')
rows = cursor.fetchall()
print("All rows from table person: ")
print(rows)
# con.commit() // for insert, update, delete
con.close()