#!/usr/bin/python
import time
import mysql.connector
from pymongo import MongoClient

conn = mysql.connector.connect(user='root', password='root', host='10.100.100.3', database='LAB_KAMIL')
cur = conn.cursor()
cur.execute('SELECT id, val0, val1, val2, val3, val4, val5, val6, val7, val8, val9 FROM TABLE_KAMIL')

client = MongoClient('10.100.100.2:27017')
baza = client['LAB_KAMIL']
kolekcja = baza['KOLEKCJA_KAMIL']

start_time = time.time()

for (id, val0, val1, val2, val3, val4, val5, val6, val7, val8, val9) in cur:
	kolekcja.insert_one({'_id': id, 'val0': val0, 'val1': val1, 'val2': val2, 'val3': val3, 'val4': val4, 'val5': val5, 'val6': val6, 'val7': val7, 'val8': val8, 'val9': val9})
	
end_time = time.time() - start_time

print(end_time)