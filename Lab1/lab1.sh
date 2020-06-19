#!/bin/sh

cd /root/
mkdir ZADANIE
cd ./ZADANIE

echo "version: '3'
networks:
    cluster:
        external:
            name: cluster
services:
    mongo:
        container_name: \"mongo\"
        networks:
          cluster:
            ipv4_address: 10.100.100.2
            aliases:
              - mongo
        image: mongo
    mariadb:
        container_name: \"mariadb\"
        networks:
          cluster:
            ipv4_address: 10.100.100.3
            aliases:
              - mariadb
        image: mariadb
        ports:
          - \"3306:3306\"
        volumes:
            - /root/ZADANIE:/DATA
        restart: always
        environment:
            MYSQL_ROOT_PASSWORD: root
            MYSQL_USER: root
            MYSQL_PASSWORD: root
            MYSQL_DATABASE: LAB_KAMIL
        healthcheck:
          test: [\"CMD\", \"mysql\", \"--user=root\", \"-proot\", \"-e show databases\"]
          interval: 2s
          timeout: 1s
          retries: 20
    python:
        container_name: \"python\"
        networks:
          cluster:
            ipv4_address: 10.100.100.4
            aliases:
              - python
        image: deb_py
        volumes:
            - /root/ZADANIE:/PY3
        command: tail -f /etc/passwd > /dev/null
" > lab1.yml

echo "USE LAB_KAMIL;

CREATE TABLE TABLE_KAMIL(  
	id INT NOT NULL AUTO_INCREMENT,  
	val0 INT NOT NULL, 
	val1 INT NOT NULL,
	val2 INT NOT NULL, 
	val3 INT NOT NULL,
	val4 INT NOT NULL, 
	val5 INT NOT NULL,
	val6 INT NOT NULL, 
	val7 INT NOT NULL,
	val8 INT NOT NULL, 
	val9 INT NOT NULL,
	PRIMARY KEY (id)
);  

drop procedure if exists myLoop;
DELIMITER //  
CREATE PROCEDURE myLoop()   
BEGIN
DECLARE i INT DEFAULT 1; 
DECLARE j INT DEFAULT 1;
WHILE (i <= 10000) DO
    INSERT INTO TABLE_KAMIL
	(val0, val1, val2, val3, val4, val5, val6, val7, val8, val9)
	VALUES  
	(10*j, 10*j+1, 10*j+2, 10*j+3, 10*j+4, 10*j+5, 10*j+6, 10*j+7, 10*j+8, 10*j+9);	
	SET i = i+1;
	SET j = j+1;
END WHILE;
END;
//  

CALL myLoop(); 
" > lab1.sql

echo "#!/usr/bin/python
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
" > lab1.py

docker network create --subnet=10.100.100.0/24 cluster
wait $!
docker-compose -f lab1.yml up -d
wait $!

value=$(docker inspect --format='{{.State.Health.Status}}' mariadb)
while [ "$value" != "healthy" ]
do
  value=$(docker inspect --format='{{.State.Health.Status}}' mariadb)
done

docker exec -it mariadb bash -c "mysql -u root -proot -e 'source /DATA/lab1.sql'"
wait $!

docker exec -it python bash -c "virtualenv --no-site-packages --python=python3 PY3"
wait $!

docker exec -it python bash -c "cd PY3/; source bin/activate; pip install pymongo; pip install mysql-connector; python lab1.py > result.txt"
wait $!

docker-compose -f lab1.yml down
wait $!
docker network rm cluster
wait $!

result=$(cat result.txt) 
echo ""
echo ""
echo "KONIEC PROGRAMU"
echo ""
echo "CZAS KOPIOWANIA [10000 REKORDÓW] MARIADB->MONGO WYNIÓSŁ: $result s"
echo ""