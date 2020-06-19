#!/usr/bin/python
from pymongo import MongoClient
import random
import time

client1 = MongoClient('10.100.100.2:27017')
baza1 = client1['LAB_KAMIL']
kolekcja1 = baza1['KOLEKCJA_KAMIL']

client2 = MongoClient('10.100.100.3:27017')
baza2 = client2['LAB_KAMIL']
kolekcja2 = baza2['KOLEKCJA_KAMIL']

start_time = time.time()

while kolekcja1.count_documents({}) != kolekcja2.count_documents({}):
	val = 0

	while val == 0:
		val = random.randint(1, kolekcja1.count_documents({}))

		if kolekcja2.count_documents({"_id": val}) > 0:
			val = 0

	kolekcja2.insert_one(kolekcja1.find_one({'_id': val}))
	
end_time = time.time() - start_time

print(end_time)