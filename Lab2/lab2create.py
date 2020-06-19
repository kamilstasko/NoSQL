#!/usr/bin/python
from pymongo import MongoClient

client = MongoClient('10.100.100.2:27017')
baza = client['LAB_KAMIL']
kolekcja = baza['KOLEKCJA_KAMIL']

i = 1
j = 1

while i <= 1000:
	kolekcja.insert_one({'_id': i, 'val0': 10*j, 'val1': 10*j+1, 'val2': 10*j+2, 'val3': 10*j+3, 'val4': 10*j+4, 'val5': 10*j+5, 'val6': 10*j+6, 'val7': 10*j+7, 'val8': 10*j+8, 'val9': 10*j+9})
	i += 1
	j += 1