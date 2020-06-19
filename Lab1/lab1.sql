USE LAB_KAMIL;

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