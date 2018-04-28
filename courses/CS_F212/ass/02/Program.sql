CREATE DATABASE DBS_Assignment;
USE DBS_Assignment;

CREATE TABLE CustomerDetails(
    custID INT PRIMARY KEY,
    fName VARCHAR(50) NOT NULL,
    lName VARCHAR(50) NOT NULL,
    bDate DATE NOT NULL,
    mobNo CHAR(10) NOT NULL,        #10 digit phone number 0501234567
    email VARCHAR(320) NOT NULL     #64 characters for local host, 1 for @ and 255 for domain
);

CREATE TABLE EmployeeDetails(
    eID INT PRIMARY KEY,
    fName VARCHAR(50) NOT NULL,
    lName VARCHAR(50) NOT NULL,
    mobNo CHAR(10) NOT NULL,        #10 digit phone number 0501234567
    bDate DATE NOT NULL
);

CREATE TABLE RoomDetails(
    roomNo CHAR(4) PRIMARY KEY,
    type ENUM('Single','Double'),
    occupied TINYINT(1) DEFAULT 0   # 0->Not Occupied   1 or other->Occupied
);

CREATE TABLE Department(
    dID VARCHAR(10) PRIMARY KEY,
    dName VARCHAR(50) NOT NULL,     #ENUM('Catering','Accounts','Event','Security','IT','General') NOT NULL DEFAULT 'General',
    mgrID INT,
    numOfEmployees INT NOT NULL DEFAULT 0,
    totalSalary INT NOT NULL DEFAULT 0,
    FOREIGN KEY (mgrID) REFERENCES EmployeeDetails(eID)
);

CREATE TABLE DepartmentDetails(
    dID VARCHAR(10),
    eID INT PRIMARY KEY,
    post VARCHAR(50) NOT NULL,      #ENUM('Manager','Engineer'
    joinDate DATE NOT NULL,
    salary INT NOT NULL,
    FOREIGN KEY (dID) REFERENCES Department(dID),
    FOREIGN KEY (eID) REFERENCES EmployeeDetails(eID)
);

CREATE TABLE CheckIn(
    custID INT PRIMARY KEY,
    roomNo CHAR(4),
    inDate DATETIME,
    FOREIGN KEY (custID) REFERENCES CustomerDetails(custID),
    FOREIGN KEY (roomNo) REFERENCES RoomDetails(roomNo)
);

CREATE TABLE CheckOut(
    custID INT PRIMARY KEY,
    roomNo CHAR(4),
    outDate DATETIME,
    FOREIGN KEY (custID) REFERENCES CustomerDetails(custID),
    FOREIGN KEY (roomNo) REFERENCES RoomDetails(roomNo)
);



#Functions

#Create a function to calculate the total cost of the customer based on his CheckIn and CheckOut details.
DELIMITER $
CREATE FUNCTION totalCost(inDate DATETIME,outDate DATETIME)
RETURNS DOUBLE
DETERMINISTIC
BEGIN
    IF inDate IS NOT NULL AND outDate IS NOT NULL THEN
    BEGIN
        #Cost is calculated by 
        #Day = 200$
        #Month = 5000$
        #Year = 50000$
        DECLARE cost DOUBLE;
        DECLARE years INT;
        DECLARE months INT;
        DECLARE days INT;
        SET years = ( SELECT EXTRACT(YEAR FROM outDate) ) - ( SELECT EXTRACT(YEAR FROM inDate) );
        SET months = (SELECT EXTRACT(MONTH FROM outDate) ) - ( SELECT EXTRACT(MONTH FROM inDate) );
        SET days = ( SELECT EXTRACT(DAY FROM outDate) ) - (SELECT EXTRACT(DAY FROM inDate) ) ;
        IF years != 0 THEN
            SET cost = years*50000;
        ELSEIF months != 0 THEN
            SET cost = months*5000;
        ELSEIF days != 0 THEN
            SET cost = days*200;
        END IF;
        return cost;
    END ;
    END IF ;
END $
DELIMITER ;

#Calculates the commission for a given join date for an employee
DELIMITER $
CREATE FUNCTION calculateCommission(joinDate DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    IF joinDate IS NOT NULL THEN
    BEGIN
        #Commission is calculated by
        #3 years = 5%
        #5 years = 10%
        #10 years = 15%
        #15 or more = 20%
        DECLARE commission INT;
        DECLARE joinYear INT;
        DECLARE currentYear INT;
        DECLARE diff INT;
        SET joinYear = YEAR(joinDate);          #Extracts the year from the given date
        SET currentYear = YEAR( CURDATE() );    #Returns the current date
        SET diff = currentYear - joinYear;
        IF diff >= 15 THEN
            SET commission = 20;
        ELSEIF diff >= 10 THEN
            SET commission = 15;
        ELSEIF diff >= 5 THEN
            SET commission = 10;
        ELSEIF diff >= 3 THEN
            SET commission = 5;
        ELSE
            SET commission  = 0;
        END IF;
        RETURN commission;
    END ;
    END IF;
END $
DELIMITER ;



#Views

#Just shows a table with the customer details and his cost
CREATE VIEW CustomerBill AS
SELECT CI.custID,CI.roomNo,inDate,outDate,totalCost(inDate,outDate) AS cost 
FROM CheckIn CI
INNER JOIN CheckOut CO
ON CI.custID = CO.custID;

#Just shows the customers which have checked in but haven't checked out
CREATE VIEW OccupiedRooms AS
SELECT * FROM CheckIn CI
WHERE CI.custID 
NOT IN (SELECT CO.custID FROM CheckOut CO);



#Stored Procedures

#Create a stored procedure to find the details of the customer occupying a given room.
DELIMITER $
CREATE PROCEDURE getRoomDetails(IN roomNo INT)
BEGIN
    SELECT * FROM CustomerDetails
    WHERE custID IN 
    (SELECT custID FROM CheckIn WHERE CheckIn.roomNo = roomNo);
END $
DELIMITER ;

#CALL getRoomDetails(roomNo);

#Procedure to just display the bill for a given customer.
DELIMITER $
CREATE PROCEDURE getCustomerBill(IN custID INT)
BEGIN
    IF custID IS NOT NULL THEN
        #Using the view customerBill
        SELECT * FROM CustomerBill CB WHERE CB.custID = custID;
    END IF ;
END $
DELIMITER ;

#Create a procedure to check-out a customer.
DELIMITER $
CREATE PROCEDURE checkOutCustomer(IN custID INT)
BEGIN
    IF (SELECT CI.custID FROM CheckIn CI WHERE CI.custID = custID) IS NOT NULL THEN
    BEGIN
        #First make an Insert in the CheckOut Table
        DECLARE roomNo CHAR(4);
        DECLARE outDate DATETIME;
        SET roomNo = (SELECT CI.roomNo FROM CheckIn CI WHERE CI.custID = custID) ;
        SET outDate = ( SELECT NOW() ) ;
        INSERT INTO CheckOut VALUES(custID,roomNo,outDate);
        #Showing the user his bill
        CALL getCustomerBill(custID);
    END ;
    END IF ;
END $
DELIMITER ;



#Triggers

#Create a trigger on the Department table to increase the total salary and the number of employees of the Department table when a new employee starts working.
DELIMITER $
CREATE TRIGGER IncreaseTotalSalary
AFTER INSERT 
ON DepartmentDetails
FOR EACH ROW
BEGIN
    IF NEW.eID IS NOT NULL THEN
        UPDATE Department
        SET 
        numOfEmployees = numOfEmployees + 1, 
        totalSalary = totalSalary + NEW.salary
        WHERE NEW.dID = dID;
    END IF;
END $
DELIMITER ;

#Create a trigger on the Department table to decrease the total salary and the number of employees of the Department table when an employee leaves.
DELIMITER $
CREATE TRIGGER DecreaseTotalSalary
BEFORE DELETE
ON DepartmentDetails
FOR EACH ROW
BEGIN
    IF OLD.eID IS NOT NULL THEN
        UPDATE Department
        SET 
        numOfEmployees = numOfEmployees - 1,
        totalSalary = totalSalary - OLD.salary
        WHERE OLD.dID = dID;
    END IF;
END $
DELIMITER ;

#Create a trigger on the Department table to update the total salary and the number of employees in case an employee gets promoted or decides to change his department.
DELIMITER $
CREATE TRIGGER UpdateTotalSalary
AFTER UPDATE
ON DepartmentDetails
FOR EACH ROW
BEGIN
    IF OLD.eID IS NOT NULL THEN
        UPDATE Department
        SET totalSalary = totalSalary - OLD.salary
        WHERE OLD.dID = dID;
    END IF;
    
    IF NEW.eID IS NOT NULL THEN
        UPDATE Department
        SET totalSalary = totalSalary + NEW.salary
        WHERE NEW.dID = dID;
    END IF;
END $
DELIMITER ;

#Create a trigger on the RoomDetails table to occupy the room with which the customer checks in.
DELIMITER $
CREATE TRIGGER CustomerCheckedIn
AFTER INSERT
ON CheckIn
FOR EACH ROW
BEGIN
    IF NEW.custID IS NOT NULL THEN
        UPDATE RoomDetails
        SET occupied = 1
        WHERE NEW.roomNo = roomNo ;
    END IF;
END $
DELIMITER ;

#Create a trigger on the RoomDetails table to vacate the room when the customer checks out.
DELIMITER $
CREATE TRIGGER CustomerCheckedOut
AFTER INSERT
ON CheckOut
FOR EACH ROW
BEGIN
    IF NEW.custID IS NOT NULL THEN
        UPDATE RoomDetails
        SET occupied = 0
        WHERE NEW.roomNo = roomNo;
    END IF;
END $
DELIMITER ;

#Create a trigger on DepartmentDetails to add commission to an employee based on his join date.
DELIMITER $
CREATE TRIGGER addCommission
BEFORE INSERT
ON DepartmentDetails
FOR EACH ROW
BEGIN
    IF NEW.eID IS NOT NULL THEN
        SET NEW.salary = NEW.salary + NEW.salary*calculateCommission(NEW.joinDate);   
    END IF;
END $
DELIMITER ;





#Queries
#Q.1 Create a trigger on the Department table to update the total salary and the number of employees when employee details are updated,inserted or deleted.
#Q.2 Create a trigger on the RoomDetails table to occupy or vacate the room with which the customer checks-in or checks-out.
#Q.3 Create a function to calculate the total cost of the customer based on his check-in and check-out details.
#Q.4 Create a stored procedure to find the details of the customer occupying a given room.
#Q.5 Create a stored procedure to check-out a customer.



#Insert Commands

INSERT INTO CustomerDetails(custID,fName,lName,bDate,mobNo,email) VALUES(1,"Dalene","Arruda",'1999-12-11','0502240811',"DaleneQF8BArruda@yahoo.com");
INSERT INTO CustomerDetails(custID,fName,lName,bDate,mobNo,email) VALUES(2,"Genevie","Swope",'2010-12-6','0554934883',"GeneviehHAtSwope@outlook.com");
INSERT INTO CustomerDetails(custID,fName,lName,bDate,mobNo,email) VALUES(3,"Cedano","Guy",'1947-4-25','0552091397',"Cedano9tieGuy@gmail.com");
INSERT INTO CustomerDetails(custID,fName,lName,bDate,mobNo,email) VALUES(4,"Pearsall","Ardelia",'1933-8-15','0587549871',"PearsalltIfNArdelia@outlook.com");
INSERT INTO CustomerDetails(custID,fName,lName,bDate,mobNo,email) VALUES(5,"Aletha","Kimrey",'1956-12-18','0502084351',"Alethap__VKimrey@yahoo.com");
INSERT INTO CustomerDetails(custID,fName,lName,bDate,mobNo,email) VALUES(6,"Qualey","Artie",'2009-5-13','0501318659',"QualeyifviArtie@hotmail.com");
INSERT INTO CustomerDetails(custID,fName,lName,bDate,mobNo,email) VALUES(7,"Loiacono","Romana",'1918-12-30','0586153321',"LoiaconozRUaRomana@yahoo.com");
INSERT INTO CustomerDetails(custID,fName,lName,bDate,mobNo,email) VALUES(8,"Sibyl","Lease",'1988-12-31','0585702407',"SibylyOObLease@hotmail.com");
INSERT INTO CustomerDetails(custID,fName,lName,bDate,mobNo,email) VALUES(9,"Alejandrina","Theola",'1994-6-25','0553550378',"AlejandrinaLDvbTheola@outlook.com");
INSERT INTO CustomerDetails(custID,fName,lName,bDate,mobNo,email) VALUES(10,"Redfern","Efren",'1978-3-15','0586334326',"RedfernPXoaEfren@outlook.com");
INSERT INTO CustomerDetails(custID,fName,lName,bDate,mobNo,email) VALUES(11,"Damon","Aileen",'2012-5-20','0584646950',"DamonU57QAileen@yahoo.com");
INSERT INTO CustomerDetails(custID,fName,lName,bDate,mobNo,email) VALUES(12,"Bo","Genevie",'2014-2-8','0500095428',"Bo1GVnGenevie@hotmail.com");
INSERT INTO CustomerDetails(custID,fName,lName,bDate,mobNo,email) VALUES(13,"Cordie","Bobbie",'1943-6-29','0583422194',"CordiexyWyBobbie@hotmail.com");
INSERT INTO CustomerDetails(custID,fName,lName,bDate,mobNo,email) VALUES(14,"Oma","Genevie",'1918-5-28','0505834043',"Oma46AgGenevie@hotmail.com");
INSERT INTO CustomerDetails(custID,fName,lName,bDate,mobNo,email) VALUES(15,"Tiara","Ryann",'1995-9-30','0553753272',"TiaraZiWHRyann@gmail.com");
INSERT INTO CustomerDetails(custID,fName,lName,bDate,mobNo,email) VALUES(16,"Temblador","Ardelia",'1988-11-29','0553813034',"TembladorIQ8bArdelia@outlook.com");
INSERT INTO CustomerDetails(custID,fName,lName,bDate,mobNo,email) VALUES(17,"Ariane","Shanika",'1912-11-3','0507733008',"ArianeT34rShanika@hotmail.com");
INSERT INTO CustomerDetails(custID,fName,lName,bDate,mobNo,email) VALUES(18,"Emanuel","Dreama",'1932-8-18','0501819778',"EmanuelX23VDreama@outlook.com");
INSERT INTO CustomerDetails(custID,fName,lName,bDate,mobNo,email) VALUES(19,"Domenica","Bickerstaff",'2007-2-8','0552707485',"DomenicaUZAtBickerstaff@gmail.com");
INSERT INTO CustomerDetails(custID,fName,lName,bDate,mobNo,email) VALUES(20,"Abbot","Elvia",'1950-2-7','0507860367',"Abbotkc7SElvia@yahoo.com");
INSERT INTO CustomerDetails(custID,fName,lName,bDate,mobNo,email) VALUES(21,"Latina","Rosella",'1988-1-29','0508894407',"LatinapKXfRosella@hotmail.com");
INSERT INTO CustomerDetails(custID,fName,lName,bDate,mobNo,email) VALUES(22,"Orpha","Lucky",'1982-10-14','0583555999',"OrphauMNvLucky@gmail.com");
INSERT INTO CustomerDetails(custID,fName,lName,bDate,mobNo,email) VALUES(23,"Chan","Brittany",'1909-5-4','0555412812',"ChanHP51Brittany@gmail.com");
INSERT INTO CustomerDetails(custID,fName,lName,bDate,mobNo,email) VALUES(24,"Russel","Camellia",'1910-12-25','0508318906',"Russelj1ZgCamellia@gmail.com");
INSERT INTO CustomerDetails(custID,fName,lName,bDate,mobNo,email) VALUES(25,"Loza","Massi",'1916-8-14','0557194155',"Lozab0FlMassi@yahoo.com");
INSERT INTO CustomerDetails(custID,fName,lName,bDate,mobNo,email) VALUES(26,"Elvira","Jolyn",'1982-1-1','0500064615',"Elvira4q2gJolyn@hotmail.com");
INSERT INTO CustomerDetails(custID,fName,lName,bDate,mobNo,email) VALUES(27,"Von","Hortencia",'1950-3-15','0557237432',"VonAjuKHortencia@yahoo.com");
INSERT INTO CustomerDetails(custID,fName,lName,bDate,mobNo,email) VALUES(28,"Susy","Christene",'1999-7-21','0556200167',"SusyqtgtChristene@outlook.com");
INSERT INTO CustomerDetails(custID,fName,lName,bDate,mobNo,email) VALUES(29,"Berneice","Eladia",'1977-12-13','0580238034',"BerneiceBfVTEladia@gmail.com");
INSERT INTO CustomerDetails(custID,fName,lName,bDate,mobNo,email) VALUES(30,"Malka","Singleterry",'1901-5-12','0551048587',"MalkaWqjXSingleterry@yahoo.com");
INSERT INTO CustomerDetails(custID,fName,lName,bDate,mobNo,email) VALUES(31,"Rachelle","Kathryn",'1948-9-7','0501195477',"RachelleprgQKathryn@gmail.com");
INSERT INTO CustomerDetails(custID,fName,lName,bDate,mobNo,email) VALUES(32,"Miss","Abe",'1973-9-21','0507793352',"MissTDLMAbe@hotmail.com");
INSERT INTO CustomerDetails(custID,fName,lName,bDate,mobNo,email) VALUES(33,"Gene","Melinda",'1994-9-17','0504656113',"Geneq5ltMelinda@yahoo.com");
INSERT INTO CustomerDetails(custID,fName,lName,bDate,mobNo,email) VALUES(34,"Alva","Taren",'1932-12-13','0556145865',"AlvaQozSTaren@outlook.com");
INSERT INTO CustomerDetails(custID,fName,lName,bDate,mobNo,email) VALUES(35,"Paris","Fenstermaker",'1990-10-1','0506613097',"Paris8ENrFenstermaker@hotmail.com");
INSERT INTO CustomerDetails(custID,fName,lName,bDate,mobNo,email) VALUES(36,"Alejandrina","Zito",'2003-3-3','0505627564',"AlejandrinaTQpwZito@hotmail.com");
INSERT INTO CustomerDetails(custID,fName,lName,bDate,mobNo,email) VALUES(37,"Rosena","Lashaun",'1974-12-4','0580467440',"RosenawWQcLashaun@hotmail.com");
INSERT INTO CustomerDetails(custID,fName,lName,bDate,mobNo,email) VALUES(38,"Latesha","Asia",'2012-2-3','0558390026',"LateshaMZPjAsia@gmail.com");
INSERT INTO CustomerDetails(custID,fName,lName,bDate,mobNo,email) VALUES(39,"Kathryn","Casper",'1944-9-8','0558038328',"KathrynImDPCasper@gmail.com");
INSERT INTO CustomerDetails(custID,fName,lName,bDate,mobNo,email) VALUES(40,"Koen","Vada",'1940-9-20','0552303653',"KoeniSnXVada@gmail.com");
INSERT INTO CustomerDetails(custID,fName,lName,bDate,mobNo,email) VALUES(41,"Lorinda","Numbers",'1948-8-14','0587383727',"LorindaXq02Numbers@outlook.com");
INSERT INTO CustomerDetails(custID,fName,lName,bDate,mobNo,email) VALUES(42,"Singleterry","Sonnier",'1944-11-29','0557961197',"Singleterryesl1Sonnier@gmail.com");
INSERT INTO CustomerDetails(custID,fName,lName,bDate,mobNo,email) VALUES(43,"Marya","Florinda",'1922-9-18','0503164460',"Marya7_ApFlorinda@outlook.com");
INSERT INTO CustomerDetails(custID,fName,lName,bDate,mobNo,email) VALUES(44,"Kasie","Ozella",'1981-8-5','0559808075',"KasieGjogOzella@gmail.com");
INSERT INTO CustomerDetails(custID,fName,lName,bDate,mobNo,email) VALUES(45,"Florencio","Ethan",'1957-6-27','0589009608',"FlorencioRme4Ethan@yahoo.com");
INSERT INTO CustomerDetails(custID,fName,lName,bDate,mobNo,email) VALUES(46,"Thelma","Slusher",'1991-3-9','0553692271',"ThelmaRCHySlusher@yahoo.com");
INSERT INTO CustomerDetails(custID,fName,lName,bDate,mobNo,email) VALUES(47,"Malcolm","Lizeth",'1973-8-13','0553511530',"MalcolmzXePLizeth@outlook.com");
INSERT INTO CustomerDetails(custID,fName,lName,bDate,mobNo,email) VALUES(48,"Jackqueline","Theola",'1910-11-17','0589110966',"JackquelineHya4Theola@outlook.com");
INSERT INTO CustomerDetails(custID,fName,lName,bDate,mobNo,email) VALUES(49,"Segovia","Lashaun",'1910-4-28','0586176738',"SegoviaP9WiLashaun@hotmail.com");
INSERT INTO CustomerDetails(custID,fName,lName,bDate,mobNo,email) VALUES(50,"Yu","Perillo",'1960-7-23','0583998701',"YuF69LPerillo@hotmail.com");
INSERT INTO CustomerDetails(custID,fName,lName,bDate,mobNo,email) VALUES(51,"Malcolm","America",'1959-1-28','0580751959',"MalcolmWVYmAmerica@gmail.com");
INSERT INTO CustomerDetails(custID,fName,lName,bDate,mobNo,email) VALUES(52,"Valrie","Garfield",'1947-7-8','0582363378',"ValrieZ4l8Garfield@hotmail.com");
INSERT INTO CustomerDetails(custID,fName,lName,bDate,mobNo,email) VALUES(53,"Theola","Inell",'1950-2-13','0580003101',"TheolaIEH2Inell@hotmail.com");
INSERT INTO CustomerDetails(custID,fName,lName,bDate,mobNo,email) VALUES(54,"Merrigan","Miguel",'1951-4-15','0580885413',"MerriganNPFWMiguel@hotmail.com");
INSERT INTO CustomerDetails(custID,fName,lName,bDate,mobNo,email) VALUES(55,"Mao","Jackqueline",'1994-8-26','0556917559',"MaoLj5aJackqueline@gmail.com");
INSERT INTO CustomerDetails(custID,fName,lName,bDate,mobNo,email) VALUES(56,"Herman","Abbot",'1956-3-26','0589182522',"Hermanx4DvAbbot@yahoo.com");
INSERT INTO CustomerDetails(custID,fName,lName,bDate,mobNo,email) VALUES(57,"Ignacio","Abbot",'1959-8-18','0503641101',"IgnacioNsFhAbbot@outlook.com");
INSERT INTO CustomerDetails(custID,fName,lName,bDate,mobNo,email) VALUES(58,"Genevie","Lizeth",'1945-7-1','0583621167',"GeneviepU0aLizeth@outlook.com");
INSERT INTO CustomerDetails(custID,fName,lName,bDate,mobNo,email) VALUES(59,"Coachman","Chrystal",'1943-12-21','0556664356',"CoachmanXjRMChrystal@yahoo.com");
INSERT INTO CustomerDetails(custID,fName,lName,bDate,mobNo,email) VALUES(60,"Paulina","Turcios",'1941-2-22','0555567648',"PaulinalnIFTurcios@outlook.com");
INSERT INTO CustomerDetails(custID,fName,lName,bDate,mobNo,email) VALUES(61,"Loza","Reinhart",'1984-8-5','0505840242',"Lozaq4soReinhart@gmail.com");
INSERT INTO CustomerDetails(custID,fName,lName,bDate,mobNo,email) VALUES(62,"Anissa","Larita",'1974-5-15','0556352876',"AnissaDJv1Larita@hotmail.com");
INSERT INTO CustomerDetails(custID,fName,lName,bDate,mobNo,email) VALUES(63,"Tashina","Adam",'1919-8-25','0505563011',"Tashinabh2AAdam@yahoo.com");
INSERT INTO CustomerDetails(custID,fName,lName,bDate,mobNo,email) VALUES(64,"Naoma","Pickle",'2015-12-13','0505661626',"Naoma9s9WPickle@gmail.com");
INSERT INTO CustomerDetails(custID,fName,lName,bDate,mobNo,email) VALUES(65,"Selma","Lowther",'1980-8-10','0551201397',"SelmaXRAaLowther@outlook.com");
INSERT INTO CustomerDetails(custID,fName,lName,bDate,mobNo,email) VALUES(66,"Dahlia","Lemmond",'1947-2-19','0554386706',"DahliaUXCkLemmond@yahoo.com");
INSERT INTO CustomerDetails(custID,fName,lName,bDate,mobNo,email) VALUES(67,"Lauralee","Hortencia",'1989-8-5','0506260408',"Lauralees2rPHortencia@outlook.com");
INSERT INTO CustomerDetails(custID,fName,lName,bDate,mobNo,email) VALUES(68,"Bunger","Alkire",'1979-9-20','0556215401',"BungerQ1_AAlkire@hotmail.com");
INSERT INTO CustomerDetails(custID,fName,lName,bDate,mobNo,email) VALUES(69,"Paulina","Morton",'1955-9-27','0586957880',"PaulinaR3GuMorton@outlook.com");
INSERT INTO CustomerDetails(custID,fName,lName,bDate,mobNo,email) VALUES(70,"Griffith","Judson",'2004-7-14','0583956132',"GriffithPfyxJudson@yahoo.com");
INSERT INTO CustomerDetails(custID,fName,lName,bDate,mobNo,email) VALUES(71,"Nikki","Monty",'1933-10-14','0509107586',"Nikki9tDiMonty@gmail.com");
INSERT INTO CustomerDetails(custID,fName,lName,bDate,mobNo,email) VALUES(72,"Abbot","Reaves",'1985-9-11','0558710389',"Abbotu2FLReaves@hotmail.com");
INSERT INTO CustomerDetails(custID,fName,lName,bDate,mobNo,email) VALUES(73,"Griffith","Anja",'1908-12-16','0509174530',"GriffithPb7qAnja@yahoo.com");
INSERT INTO CustomerDetails(custID,fName,lName,bDate,mobNo,email) VALUES(74,"Efren","Rendon",'1931-9-6','0505503155',"EfrenbnHRRendon@outlook.com");
INSERT INTO CustomerDetails(custID,fName,lName,bDate,mobNo,email) VALUES(75,"Brittany","Sal",'2009-1-19','0587051417',"BrittanyIfY0Sal@gmail.com");
INSERT INTO CustomerDetails(custID,fName,lName,bDate,mobNo,email) VALUES(76,"Laurene","Collin",'1932-4-18','0589188008',"LaurenezwttCollin@outlook.com");
INSERT INTO CustomerDetails(custID,fName,lName,bDate,mobNo,email) VALUES(77,"Jacquetta","Jackqueline",'2011-3-13','0553040988',"JacquettaRdjtJackqueline@hotmail.com");
INSERT INTO CustomerDetails(custID,fName,lName,bDate,mobNo,email) VALUES(78,"Ivan","Monty",'1903-4-18','0506787778',"IvanQmnZMonty@outlook.com");
INSERT INTO CustomerDetails(custID,fName,lName,bDate,mobNo,email) VALUES(79,"Anh","Valery",'1946-10-3','0503584316',"AnhwXxXValery@outlook.com");
INSERT INTO CustomerDetails(custID,fName,lName,bDate,mobNo,email) VALUES(80,"Shelman","Jackqueline",'1959-7-21','0585595975',"ShelmaneYxoJackqueline@hotmail.com");
INSERT INTO CustomerDetails(custID,fName,lName,bDate,mobNo,email) VALUES(81,"Reaves","Kummer",'1941-4-25','0500345514',"Reaves2sgSKummer@hotmail.com");
INSERT INTO CustomerDetails(custID,fName,lName,bDate,mobNo,email) VALUES(82,"Selma","Zwick",'1951-8-5','0509914009',"SelmaP7ZhZwick@outlook.com");
INSERT INTO CustomerDetails(custID,fName,lName,bDate,mobNo,email) VALUES(83,"Mao","Garfield",'1949-4-5','0551093618',"Maoum2oGarfield@hotmail.com");
INSERT INTO CustomerDetails(custID,fName,lName,bDate,mobNo,email) VALUES(84,"Fermina","Klee",'1919-7-4','0500047573',"Fermina5GaJKlee@hotmail.com");
INSERT INTO CustomerDetails(custID,fName,lName,bDate,mobNo,email) VALUES(85,"Hartig","Treloar",'1960-9-28','0587448536',"HartigFNMOTreloar@hotmail.com");
INSERT INTO CustomerDetails(custID,fName,lName,bDate,mobNo,email) VALUES(86,"Many","Wynell",'1984-7-11','0551259892',"ManyZ024Wynell@gmail.com");
INSERT INTO CustomerDetails(custID,fName,lName,bDate,mobNo,email) VALUES(87,"Svetlana","Lowther",'2004-5-5','0504152766',"SvetlananfjTLowther@yahoo.com");
INSERT INTO CustomerDetails(custID,fName,lName,bDate,mobNo,email) VALUES(88,"Kline","Dean",'1920-10-28','0558369709',"Kline714TDean@hotmail.com");
INSERT INTO CustomerDetails(custID,fName,lName,bDate,mobNo,email) VALUES(89,"Theola","Meri",'1926-3-27','0557381124',"TheolaMmJJMeri@yahoo.com");
INSERT INTO CustomerDetails(custID,fName,lName,bDate,mobNo,email) VALUES(90,"Rosella","Valery",'1928-6-12','0557827188',"RosellawMQBValery@hotmail.com");
INSERT INTO CustomerDetails(custID,fName,lName,bDate,mobNo,email) VALUES(91,"Giovanna","Nellum",'1940-3-24','0501410379',"Giovanna_2yGNellum@gmail.com");
INSERT INTO CustomerDetails(custID,fName,lName,bDate,mobNo,email) VALUES(92,"Ena","Sherell",'1991-4-1','0582051362',"EnacFBlSherell@hotmail.com");
INSERT INTO CustomerDetails(custID,fName,lName,bDate,mobNo,email) VALUES(93,"Keely","Modesta",'1917-12-14','0559302281',"KeelypqwyModesta@hotmail.com");
INSERT INTO CustomerDetails(custID,fName,lName,bDate,mobNo,email) VALUES(94,"Verdugo","Godlewski",'1911-7-9','0500380196',"VerdugoClKZGodlewski@outlook.com");
INSERT INTO CustomerDetails(custID,fName,lName,bDate,mobNo,email) VALUES(95,"Clayton","Katlyn",'1962-9-21','0504295355',"ClaytonqT9JKatlyn@hotmail.com");
INSERT INTO CustomerDetails(custID,fName,lName,bDate,mobNo,email) VALUES(96,"Toya","Toney",'1927-4-19','0503683848',"ToyaKhVVToney@hotmail.com");
INSERT INTO CustomerDetails(custID,fName,lName,bDate,mobNo,email) VALUES(97,"Lora","Amalia",'1914-6-21','0551551540',"Lorav3jCAmalia@gmail.com");
INSERT INTO CustomerDetails(custID,fName,lName,bDate,mobNo,email) VALUES(98,"Von","Rikki",'1917-2-25','0508608400',"Von3QH7Rikki@yahoo.com");
INSERT INTO CustomerDetails(custID,fName,lName,bDate,mobNo,email) VALUES(99,"Blackwelder","Hyun",'1957-2-10','0555340622',"BlackwelderwjWYHyun@hotmail.com");
INSERT INTO CustomerDetails(custID,fName,lName,bDate,mobNo,email) VALUES(100,"Sandi","Koen",'1920-5-11','0587392599',"Sandi_q4gKoen@gmail.com");

INSERT INTO EmployeeDetails(eID,fName,lName,bDate,mobNo) VALUES(1,"Trang","Derek",'1981-12-31','0509657351');
INSERT INTO EmployeeDetails(eID,fName,lName,bDate,mobNo) VALUES(2,"Quinn","Slaubaugh",'1973-12-6','0581084245');
INSERT INTO EmployeeDetails(eID,fName,lName,bDate,mobNo) VALUES(3,"Beverlee","Tomasello",'1925-10-28','0557754124');
INSERT INTO EmployeeDetails(eID,fName,lName,bDate,mobNo) VALUES(4,"Melinda","Walraven",'1974-8-29','0554667956');
INSERT INTO EmployeeDetails(eID,fName,lName,bDate,mobNo) VALUES(5,"Meri","Many",'1982-5-10','0587957635');
INSERT INTO EmployeeDetails(eID,fName,lName,bDate,mobNo) VALUES(6,"Belle","Pearsall",'1978-11-5','0502105608');
INSERT INTO EmployeeDetails(eID,fName,lName,bDate,mobNo) VALUES(7,"Etta","Hagemann",'1930-5-26','0505789936');
INSERT INTO EmployeeDetails(eID,fName,lName,bDate,mobNo) VALUES(8,"Dorthy","Ena",'1941-8-20','0556394403');
INSERT INTO EmployeeDetails(eID,fName,lName,bDate,mobNo) VALUES(9,"Syring","Ivan",'1965-9-2','0557380236');
INSERT INTO EmployeeDetails(eID,fName,lName,bDate,mobNo) VALUES(10,"Ivan","Dworkin",'2002-12-17','0507157778');
INSERT INTO EmployeeDetails(eID,fName,lName,bDate,mobNo) VALUES(11,"Casper","Dorthy",'1929-5-11','0501318820');
INSERT INTO EmployeeDetails(eID,fName,lName,bDate,mobNo) VALUES(12,"Leanna","Singleterry",'1974-3-22','0551250739');
INSERT INTO EmployeeDetails(eID,fName,lName,bDate,mobNo) VALUES(13,"Jenine","Melida",'1986-5-18','0557758330');
INSERT INTO EmployeeDetails(eID,fName,lName,bDate,mobNo) VALUES(14,"Zuk","Wonda",'1950-5-26','0505241653');
INSERT INTO EmployeeDetails(eID,fName,lName,bDate,mobNo) VALUES(15,"Hartig","Solomon",'1967-8-29','0555774056');
INSERT INTO EmployeeDetails(eID,fName,lName,bDate,mobNo) VALUES(16,"Hilary","Guy",'1932-1-5','0554252704');
INSERT INTO EmployeeDetails(eID,fName,lName,bDate,mobNo) VALUES(17,"Sal","Kym",'1952-11-26','0500411983');
INSERT INTO EmployeeDetails(eID,fName,lName,bDate,mobNo) VALUES(18,"Ivan","Hortencia",'1999-10-21','0558069314');
INSERT INTO EmployeeDetails(eID,fName,lName,bDate,mobNo) VALUES(19,"Kai","Rosella",'1999-10-22','0506796333');
INSERT INTO EmployeeDetails(eID,fName,lName,bDate,mobNo) VALUES(20,"Ramonita","Nikole",'1937-2-23','0552380481');
INSERT INTO EmployeeDetails(eID,fName,lName,bDate,mobNo) VALUES(21,"Silvia","Widner",'2011-1-11','0581226354');
INSERT INTO EmployeeDetails(eID,fName,lName,bDate,mobNo) VALUES(22,"Ezequiel","Walraven",'1978-1-18','0587242136');
INSERT INTO EmployeeDetails(eID,fName,lName,bDate,mobNo) VALUES(23,"Caple","Theola",'1978-7-18','0580302089');
INSERT INTO EmployeeDetails(eID,fName,lName,bDate,mobNo) VALUES(24,"Sherell","Miguel",'1945-6-26','0557394360');
INSERT INTO EmployeeDetails(eID,fName,lName,bDate,mobNo) VALUES(25,"Waldrep","Swoboda",'1942-7-18','0505532840');
INSERT INTO EmployeeDetails(eID,fName,lName,bDate,mobNo) VALUES(26,"Sal","Cheryll",'1929-6-28','0587369894');
INSERT INTO EmployeeDetails(eID,fName,lName,bDate,mobNo) VALUES(27,"Columbus","Perillo",'1955-7-31','0551383146');
INSERT INTO EmployeeDetails(eID,fName,lName,bDate,mobNo) VALUES(28,"Efren","Laurene",'1938-6-6','0557351552');
INSERT INTO EmployeeDetails(eID,fName,lName,bDate,mobNo) VALUES(29,"Carroll","Garoutte",'1996-3-22','0585706248');
INSERT INTO EmployeeDetails(eID,fName,lName,bDate,mobNo) VALUES(30,"Efren","Gesell",'1929-12-10','0504258793');
INSERT INTO EmployeeDetails(eID,fName,lName,bDate,mobNo) VALUES(31,"Jolyn","Darst",'1917-12-23','0509724900');
INSERT INTO EmployeeDetails(eID,fName,lName,bDate,mobNo) VALUES(32,"Paulina","Kristan",'1936-12-21','0587846861');
INSERT INTO EmployeeDetails(eID,fName,lName,bDate,mobNo) VALUES(33,"Jolyn","Angela",'1977-12-9','0502643204');
INSERT INTO EmployeeDetails(eID,fName,lName,bDate,mobNo) VALUES(34,"Loza","Belnap",'1911-11-23','0506015451');
INSERT INTO EmployeeDetails(eID,fName,lName,bDate,mobNo) VALUES(35,"Ramonita","Bowie",'1987-3-9','0583889043');
INSERT INTO EmployeeDetails(eID,fName,lName,bDate,mobNo) VALUES(36,"Marilyn","Marya",'1952-7-7','0503652930');
INSERT INTO EmployeeDetails(eID,fName,lName,bDate,mobNo) VALUES(37,"Abbot","Jeanetta",'2006-5-5','0583720309');
INSERT INTO EmployeeDetails(eID,fName,lName,bDate,mobNo) VALUES(38,"Malena","Bickerstaff",'1921-10-3','0559716731');
INSERT INTO EmployeeDetails(eID,fName,lName,bDate,mobNo) VALUES(39,"Lashay","Tiara",'1929-4-8','0588053783');
INSERT INTO EmployeeDetails(eID,fName,lName,bDate,mobNo) VALUES(40,"Danna","Angela",'1907-11-17','0558756977');
INSERT INTO EmployeeDetails(eID,fName,lName,bDate,mobNo) VALUES(41,"Lashaun","Von",'1945-1-26','0501526658');
INSERT INTO EmployeeDetails(eID,fName,lName,bDate,mobNo) VALUES(42,"Charlena","Garrison",'1927-10-27','0556638564');
INSERT INTO EmployeeDetails(eID,fName,lName,bDate,mobNo) VALUES(43,"Lula","Pierce",'1924-5-7','0585340433');
INSERT INTO EmployeeDetails(eID,fName,lName,bDate,mobNo) VALUES(44,"Asia","Bono",'1919-12-6','0500289413');
INSERT INTO EmployeeDetails(eID,fName,lName,bDate,mobNo) VALUES(45,"Lovella","Linwood",'1976-3-2','0585598192');
INSERT INTO EmployeeDetails(eID,fName,lName,bDate,mobNo) VALUES(46,"Ryann","Temple",'1937-6-29','0506323479');
INSERT INTO EmployeeDetails(eID,fName,lName,bDate,mobNo) VALUES(47,"Malka","Vikki",'1920-4-22','0558858083');
INSERT INTO EmployeeDetails(eID,fName,lName,bDate,mobNo) VALUES(48,"Pierce","Kai",'1981-6-4','0556239551');
INSERT INTO EmployeeDetails(eID,fName,lName,bDate,mobNo) VALUES(49,"Tomasello","Paula",'1946-12-7','0558433040');
INSERT INTO EmployeeDetails(eID,fName,lName,bDate,mobNo) VALUES(50,"Loza","Pullin",'1976-8-10','0507989091');
INSERT INTO EmployeeDetails(eID,fName,lName,bDate,mobNo) VALUES(51,"Towanda","Leeann",'1936-10-2','0585130902');
INSERT INTO EmployeeDetails(eID,fName,lName,bDate,mobNo) VALUES(52,"Reinhart","Stonge",'1930-12-13','0557020014');
INSERT INTO EmployeeDetails(eID,fName,lName,bDate,mobNo) VALUES(53,"Alexander","Terese",'1927-5-24','0508839111');
INSERT INTO EmployeeDetails(eID,fName,lName,bDate,mobNo) VALUES(54,"Conwell","Artie",'1941-8-8','0556463074');
INSERT INTO EmployeeDetails(eID,fName,lName,bDate,mobNo) VALUES(55,"Wynell","Pierce",'1903-11-11','0509282547');
INSERT INTO EmployeeDetails(eID,fName,lName,bDate,mobNo) VALUES(56,"Leitch","Lovella",'1977-3-13','0553285197');
INSERT INTO EmployeeDetails(eID,fName,lName,bDate,mobNo) VALUES(57,"Buck","Roni",'1903-12-8','0584540861');
INSERT INTO EmployeeDetails(eID,fName,lName,bDate,mobNo) VALUES(58,"Herman","Trevizo",'1984-2-19','0589705403');
INSERT INTO EmployeeDetails(eID,fName,lName,bDate,mobNo) VALUES(59,"Juliet","Eliz",'1991-12-15','0552033006');
INSERT INTO EmployeeDetails(eID,fName,lName,bDate,mobNo) VALUES(60,"Leanna","Turcios",'1989-11-29','0558323069');
INSERT INTO EmployeeDetails(eID,fName,lName,bDate,mobNo) VALUES(61,"Bobbie","Eladia",'1944-8-23','0556601962');
INSERT INTO EmployeeDetails(eID,fName,lName,bDate,mobNo) VALUES(62,"Lehrer","Florinda",'1920-6-17','0505949006');
INSERT INTO EmployeeDetails(eID,fName,lName,bDate,mobNo) VALUES(63,"Quinn","Berneice",'2017-4-20','0554330200');
INSERT INTO EmployeeDetails(eID,fName,lName,bDate,mobNo) VALUES(64,"Guy","Nikki",'1989-12-5','0505685580');
INSERT INTO EmployeeDetails(eID,fName,lName,bDate,mobNo) VALUES(65,"Cesar","Lashonda",'1923-8-30','0585699298');
INSERT INTO EmployeeDetails(eID,fName,lName,bDate,mobNo) VALUES(66,"Ingerson","Pearsall",'1944-7-1','0507815500');
INSERT INTO EmployeeDetails(eID,fName,lName,bDate,mobNo) VALUES(67,"Silvia","Makris",'1995-9-9','0558623373');
INSERT INTO EmployeeDetails(eID,fName,lName,bDate,mobNo) VALUES(68,"Seller","Linn",'1963-11-10','0502719794');
INSERT INTO EmployeeDetails(eID,fName,lName,bDate,mobNo) VALUES(69,"Tardugno","Damon",'1928-10-31','0509433953');
INSERT INTO EmployeeDetails(eID,fName,lName,bDate,mobNo) VALUES(70,"Stauffer","Zackary",'2010-10-28','0589276677');
INSERT INTO EmployeeDetails(eID,fName,lName,bDate,mobNo) VALUES(71,"Brittany","Karlyn",'1904-7-7','0557980965');
INSERT INTO EmployeeDetails(eID,fName,lName,bDate,mobNo) VALUES(72,"Carroll","Leitch",'2010-8-19','0583377551');
INSERT INTO EmployeeDetails(eID,fName,lName,bDate,mobNo) VALUES(73,"Ariane","Cleaver",'1964-12-4','0553960757');
INSERT INTO EmployeeDetails(eID,fName,lName,bDate,mobNo) VALUES(74,"Domenica","Rocco",'1924-11-8','0581190314');
INSERT INTO EmployeeDetails(eID,fName,lName,bDate,mobNo) VALUES(75,"Lela","Oma",'1926-5-13','0551075423');
INSERT INTO EmployeeDetails(eID,fName,lName,bDate,mobNo) VALUES(76,"Cordie","Sherman",'1990-12-1','0550966835');
INSERT INTO EmployeeDetails(eID,fName,lName,bDate,mobNo) VALUES(77,"Elvia","Kea",'1912-8-28','0505405178');
INSERT INTO EmployeeDetails(eID,fName,lName,bDate,mobNo) VALUES(78,"Wilkin","Arruda",'1965-4-9','0500727708');
INSERT INTO EmployeeDetails(eID,fName,lName,bDate,mobNo) VALUES(79,"Chinn","Pullin",'1939-8-29','0582095134');
INSERT INTO EmployeeDetails(eID,fName,lName,bDate,mobNo) VALUES(80,"Russel","Crandell",'1921-3-18','0551607831');
INSERT INTO EmployeeDetails(eID,fName,lName,bDate,mobNo) VALUES(81,"Beverlee","Gidget",'1917-2-6','0503165993');
INSERT INTO EmployeeDetails(eID,fName,lName,bDate,mobNo) VALUES(82,"Ramonita","Auston",'1965-11-23','0553441401');
INSERT INTO EmployeeDetails(eID,fName,lName,bDate,mobNo) VALUES(83,"Lula","Gonsalves",'2013-6-27','0581690473');
INSERT INTO EmployeeDetails(eID,fName,lName,bDate,mobNo) VALUES(84,"Alexander","Svetlana",'1949-9-22','0558219073');
INSERT INTO EmployeeDetails(eID,fName,lName,bDate,mobNo) VALUES(85,"Vosburgh","Leticia",'1977-12-3','0588652659');
INSERT INTO EmployeeDetails(eID,fName,lName,bDate,mobNo) VALUES(86,"Bobbie","Loiacono",'1911-12-12','0503907842');
INSERT INTO EmployeeDetails(eID,fName,lName,bDate,mobNo) VALUES(87,"Selma","Velva",'2008-8-16','0505779571');
INSERT INTO EmployeeDetails(eID,fName,lName,bDate,mobNo) VALUES(88,"Isaiah","Buck",'1959-1-14','0585408508');
INSERT INTO EmployeeDetails(eID,fName,lName,bDate,mobNo) VALUES(89,"Kari","Zwick",'1958-4-22','0581844314');
INSERT INTO EmployeeDetails(eID,fName,lName,bDate,mobNo) VALUES(90,"Shyla","Sherman",'1993-1-31','0557515814');
INSERT INTO EmployeeDetails(eID,fName,lName,bDate,mobNo) VALUES(91,"Eusebio","Shante",'1971-7-7','0558520260');
INSERT INTO EmployeeDetails(eID,fName,lName,bDate,mobNo) VALUES(92,"Sherman","Redfern",'1976-10-30','0585389643');
INSERT INTO EmployeeDetails(eID,fName,lName,bDate,mobNo) VALUES(93,"Crandell","Emma",'1907-2-25','0588091448');
INSERT INTO EmployeeDetails(eID,fName,lName,bDate,mobNo) VALUES(94,"Elenor","Raleigh",'1974-8-14','0553678346');
INSERT INTO EmployeeDetails(eID,fName,lName,bDate,mobNo) VALUES(95,"Judith","Tanna",'2001-11-2','0586165085');
INSERT INTO EmployeeDetails(eID,fName,lName,bDate,mobNo) VALUES(96,"Loni","Bak",'1915-1-23','0584971617');
INSERT INTO EmployeeDetails(eID,fName,lName,bDate,mobNo) VALUES(97,"Anh","Maranda",'2010-11-9','0583378996');
INSERT INTO EmployeeDetails(eID,fName,lName,bDate,mobNo) VALUES(98,"Lory","Verdugo",'1943-6-13','0589935246');
INSERT INTO EmployeeDetails(eID,fName,lName,bDate,mobNo) VALUES(99,"Levier","Slusher",'1957-4-25','0588724170');
INSERT INTO EmployeeDetails(eID,fName,lName,bDate,mobNo) VALUES(100,"Emanuel","Adam",'1903-3-16','0582940456');

INSERT INTO RoomDetails(roomNo,type) VALUES('0101','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('0102','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('0103','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('0104','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('0105','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('0106','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('0107','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('0108','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('0109','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('0110','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('0111','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('0112','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('0113','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('0114','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('0115','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('0116','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('0117','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('0118','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('0119','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('0120','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('0201','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('0202','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('0203','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('0204','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('0205','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('0206','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('0207','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('0208','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('0209','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('0210','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('0211','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('0212','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('0213','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('0214','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('0215','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('0216','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('0217','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('0218','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('0219','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('0220','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('0301','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('0302','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('0303','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('0304','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('0305','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('0306','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('0307','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('0308','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('0309','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('0310','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('0311','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('0312','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('0313','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('0314','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('0315','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('0316','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('0317','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('0318','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('0319','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('0320','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('0401','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('0402','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('0403','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('0404','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('0405','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('0406','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('0407','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('0408','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('0409','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('0410','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('0411','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('0412','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('0413','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('0414','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('0415','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('0416','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('0417','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('0418','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('0419','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('0420','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('0501','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('0502','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('0503','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('0504','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('0505','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('0506','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('0507','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('0508','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('0509','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('0510','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('0511','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('0512','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('0513','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('0514','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('0515','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('0516','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('0517','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('0518','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('0519','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('0520','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('0601','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('0602','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('0603','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('0604','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('0605','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('0606','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('0607','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('0608','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('0609','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('0610','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('0611','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('0612','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('0613','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('0614','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('0615','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('0616','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('0617','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('0618','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('0619','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('0620','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('0701','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('0702','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('0703','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('0704','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('0705','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('0706','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('0707','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('0708','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('0709','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('0710','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('0711','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('0712','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('0713','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('0714','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('0715','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('0716','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('0717','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('0718','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('0719','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('0720','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('0801','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('0802','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('0803','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('0804','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('0805','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('0806','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('0807','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('0808','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('0809','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('0810','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('0811','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('0812','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('0813','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('0814','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('0815','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('0816','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('0817','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('0818','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('0819','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('0820','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('0901','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('0902','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('0903','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('0904','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('0905','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('0906','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('0907','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('0908','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('0909','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('0910','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('0911','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('0912','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('0913','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('0914','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('0915','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('0916','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('0917','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('0918','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('0919','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('0920','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('1001','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('1002','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('1003','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('1004','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('1005','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('1006','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('1007','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('1008','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('1009','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('1010','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('1011','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('1012','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('1013','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('1014','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('1015','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('1016','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('1017','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('1018','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('1019','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('1020','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('1101','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('1102','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('1103','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('1104','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('1105','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('1106','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('1107','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('1108','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('1109','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('1110','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('1111','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('1112','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('1113','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('1114','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('1115','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('1116','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('1117','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('1118','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('1119','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('1120','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('1201','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('1202','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('1203','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('1204','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('1205','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('1206','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('1207','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('1208','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('1209','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('1210','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('1211','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('1212','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('1213','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('1214','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('1215','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('1216','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('1217','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('1218','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('1219','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('1220','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('1301','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('1302','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('1303','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('1304','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('1305','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('1306','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('1307','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('1308','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('1309','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('1310','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('1311','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('1312','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('1313','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('1314','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('1315','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('1316','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('1317','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('1318','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('1319','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('1320','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('1401','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('1402','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('1403','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('1404','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('1405','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('1406','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('1407','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('1408','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('1409','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('1410','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('1411','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('1412','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('1413','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('1414','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('1415','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('1416','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('1417','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('1418','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('1419','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('1420','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('1501','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('1502','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('1503','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('1504','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('1505','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('1506','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('1507','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('1508','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('1509','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('1510','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('1511','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('1512','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('1513','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('1514','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('1515','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('1516','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('1517','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('1518','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('1519','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('1520','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('1601','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('1602','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('1603','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('1604','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('1605','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('1606','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('1607','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('1608','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('1609','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('1610','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('1611','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('1612','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('1613','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('1614','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('1615','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('1616','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('1617','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('1618','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('1619','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('1620','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('1701','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('1702','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('1703','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('1704','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('1705','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('1706','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('1707','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('1708','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('1709','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('1710','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('1711','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('1712','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('1713','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('1714','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('1715','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('1716','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('1717','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('1718','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('1719','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('1720','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('1801','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('1802','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('1803','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('1804','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('1805','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('1806','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('1807','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('1808','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('1809','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('1810','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('1811','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('1812','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('1813','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('1814','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('1815','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('1816','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('1817','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('1818','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('1819','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('1820','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('1901','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('1902','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('1903','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('1904','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('1905','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('1906','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('1907','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('1908','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('1909','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('1910','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('1911','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('1912','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('1913','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('1914','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('1915','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('1916','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('1917','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('1918','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('1919','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('1920','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('2001','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('2002','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('2003','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('2004','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('2005','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('2006','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('2007','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('2008','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('2009','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('2010','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('2011','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('2012','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('2013','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('2014','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('2015','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('2016','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('2017','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('2018','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('2019','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('2020','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('2101','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('2102','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('2103','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('2104','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('2105','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('2106','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('2107','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('2108','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('2109','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('2110','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('2111','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('2112','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('2113','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('2114','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('2115','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('2116','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('2117','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('2118','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('2119','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('2120','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('2201','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('2202','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('2203','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('2204','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('2205','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('2206','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('2207','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('2208','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('2209','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('2210','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('2211','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('2212','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('2213','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('2214','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('2215','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('2216','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('2217','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('2218','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('2219','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('2220','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('2301','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('2302','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('2303','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('2304','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('2305','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('2306','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('2307','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('2308','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('2309','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('2310','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('2311','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('2312','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('2313','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('2314','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('2315','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('2316','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('2317','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('2318','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('2319','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('2320','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('2401','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('2402','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('2403','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('2404','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('2405','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('2406','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('2407','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('2408','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('2409','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('2410','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('2411','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('2412','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('2413','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('2414','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('2415','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('2416','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('2417','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('2418','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('2419','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('2420','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('2501','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('2502','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('2503','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('2504','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('2505','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('2506','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('2507','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('2508','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('2509','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('2510','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('2511','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('2512','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('2513','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('2514','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('2515','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('2516','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('2517','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('2518','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('2519','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('2520','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('2601','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('2602','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('2603','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('2604','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('2605','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('2606','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('2607','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('2608','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('2609','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('2610','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('2611','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('2612','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('2613','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('2614','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('2615','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('2616','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('2617','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('2618','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('2619','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('2620','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('2701','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('2702','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('2703','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('2704','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('2705','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('2706','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('2707','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('2708','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('2709','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('2710','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('2711','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('2712','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('2713','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('2714','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('2715','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('2716','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('2717','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('2718','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('2719','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('2720','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('2801','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('2802','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('2803','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('2804','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('2805','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('2806','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('2807','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('2808','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('2809','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('2810','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('2811','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('2812','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('2813','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('2814','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('2815','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('2816','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('2817','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('2818','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('2819','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('2820','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('2901','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('2902','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('2903','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('2904','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('2905','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('2906','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('2907','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('2908','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('2909','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('2910','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('2911','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('2912','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('2913','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('2914','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('2915','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('2916','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('2917','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('2918','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('2919','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('2920','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('3001','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('3002','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('3003','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('3004','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('3005','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('3006','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('3007','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('3008','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('3009','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('3010','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('3011','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('3012','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('3013','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('3014','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('3015','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('3016','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('3017','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('3018','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('3019','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('3020','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('3101','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('3102','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('3103','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('3104','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('3105','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('3106','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('3107','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('3108','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('3109','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('3110','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('3111','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('3112','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('3113','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('3114','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('3115','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('3116','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('3117','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('3118','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('3119','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('3120','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('3201','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('3202','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('3203','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('3204','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('3205','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('3206','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('3207','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('3208','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('3209','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('3210','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('3211','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('3212','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('3213','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('3214','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('3215','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('3216','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('3217','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('3218','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('3219','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('3220','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('3301','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('3302','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('3303','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('3304','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('3305','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('3306','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('3307','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('3308','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('3309','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('3310','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('3311','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('3312','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('3313','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('3314','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('3315','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('3316','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('3317','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('3318','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('3319','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('3320','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('3401','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('3402','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('3403','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('3404','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('3405','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('3406','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('3407','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('3408','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('3409','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('3410','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('3411','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('3412','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('3413','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('3414','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('3415','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('3416','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('3417','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('3418','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('3419','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('3420','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('3501','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('3502','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('3503','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('3504','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('3505','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('3506','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('3507','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('3508','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('3509','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('3510','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('3511','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('3512','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('3513','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('3514','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('3515','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('3516','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('3517','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('3518','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('3519','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('3520','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('3601','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('3602','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('3603','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('3604','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('3605','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('3606','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('3607','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('3608','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('3609','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('3610','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('3611','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('3612','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('3613','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('3614','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('3615','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('3616','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('3617','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('3618','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('3619','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('3620','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('3701','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('3702','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('3703','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('3704','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('3705','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('3706','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('3707','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('3708','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('3709','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('3710','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('3711','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('3712','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('3713','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('3714','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('3715','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('3716','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('3717','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('3718','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('3719','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('3720','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('3801','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('3802','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('3803','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('3804','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('3805','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('3806','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('3807','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('3808','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('3809','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('3810','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('3811','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('3812','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('3813','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('3814','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('3815','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('3816','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('3817','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('3818','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('3819','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('3820','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('3901','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('3902','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('3903','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('3904','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('3905','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('3906','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('3907','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('3908','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('3909','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('3910','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('3911','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('3912','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('3913','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('3914','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('3915','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('3916','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('3917','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('3918','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('3919','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('3920','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('4001','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('4002','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('4003','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('4004','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('4005','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('4006','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('4007','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('4008','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('4009','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('4010','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('4011','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('4012','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('4013','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('4014','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('4015','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('4016','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('4017','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('4018','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('4019','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('4020','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('4101','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('4102','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('4103','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('4104','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('4105','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('4106','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('4107','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('4108','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('4109','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('4110','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('4111','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('4112','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('4113','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('4114','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('4115','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('4116','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('4117','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('4118','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('4119','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('4120','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('4201','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('4202','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('4203','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('4204','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('4205','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('4206','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('4207','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('4208','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('4209','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('4210','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('4211','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('4212','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('4213','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('4214','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('4215','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('4216','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('4217','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('4218','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('4219','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('4220','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('4301','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('4302','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('4303','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('4304','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('4305','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('4306','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('4307','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('4308','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('4309','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('4310','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('4311','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('4312','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('4313','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('4314','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('4315','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('4316','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('4317','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('4318','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('4319','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('4320','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('4401','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('4402','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('4403','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('4404','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('4405','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('4406','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('4407','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('4408','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('4409','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('4410','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('4411','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('4412','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('4413','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('4414','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('4415','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('4416','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('4417','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('4418','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('4419','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('4420','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('4501','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('4502','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('4503','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('4504','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('4505','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('4506','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('4507','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('4508','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('4509','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('4510','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('4511','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('4512','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('4513','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('4514','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('4515','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('4516','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('4517','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('4518','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('4519','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('4520','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('4601','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('4602','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('4603','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('4604','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('4605','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('4606','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('4607','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('4608','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('4609','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('4610','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('4611','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('4612','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('4613','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('4614','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('4615','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('4616','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('4617','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('4618','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('4619','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('4620','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('4701','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('4702','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('4703','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('4704','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('4705','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('4706','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('4707','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('4708','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('4709','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('4710','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('4711','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('4712','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('4713','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('4714','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('4715','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('4716','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('4717','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('4718','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('4719','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('4720','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('4801','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('4802','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('4803','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('4804','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('4805','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('4806','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('4807','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('4808','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('4809','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('4810','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('4811','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('4812','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('4813','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('4814','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('4815','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('4816','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('4817','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('4818','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('4819','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('4820','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('4901','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('4902','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('4903','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('4904','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('4905','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('4906','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('4907','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('4908','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('4909','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('4910','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('4911','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('4912','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('4913','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('4914','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('4915','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('4916','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('4917','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('4918','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('4919','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('4920','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('5001','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('5002','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('5003','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('5004','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('5005','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('5006','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('5007','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('5008','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('5009','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('5010','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('5011','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('5012','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('5013','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('5014','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('5015','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('5016','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('5017','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('5018','Single');
INSERT INTO RoomDetails(roomNo,type) VALUES('5019','Double');
INSERT INTO RoomDetails(roomNo,type) VALUES('5020','Single');

INSERT INTO CheckIn(custID,roomNo,inDate) VALUES(81,'2716','2018-06-14 09:23:42');
INSERT INTO CheckIn(custID,roomNo,inDate) VALUES(83,'2805','2016-07-30 09:03:35');
INSERT INTO CheckIn(custID,roomNo,inDate) VALUES(56,'2205','2017-08-06 11:13:49');
INSERT INTO CheckIn(custID,roomNo,inDate) VALUES(44,'2111','2010-01-09 19:30:19');
INSERT INTO CheckIn(custID,roomNo,inDate) VALUES(88,'4515','2006-08-20 16:14:23');
INSERT INTO CheckIn(custID,roomNo,inDate) VALUES(41,'2220','2013-07-27 00:39:49');
INSERT INTO CheckIn(custID,roomNo,inDate) VALUES(58,'2511','2015-12-29 22:38:55');
INSERT INTO CheckIn(custID,roomNo,inDate) VALUES(79,'0506','2014-01-26 17:33:01');
INSERT INTO CheckIn(custID,roomNo,inDate) VALUES(76,'4603','2011-09-13 18:16:24');
INSERT INTO CheckIn(custID,roomNo,inDate) VALUES(12,'2120','2010-06-11 08:31:12');
INSERT INTO CheckIn(custID,roomNo,inDate) VALUES(94,'2005','2015-07-13 17:25:51');
INSERT INTO CheckIn(custID,roomNo,inDate) VALUES(18,'1611','2007-03-23 21:45:46');
INSERT INTO CheckIn(custID,roomNo,inDate) VALUES(31,'0313','2015-08-12 17:13:03');
INSERT INTO CheckIn(custID,roomNo,inDate) VALUES(50,'3316','2006-07-22 03:39:12');
INSERT INTO CheckIn(custID,roomNo,inDate) VALUES(23,'2412','2014-04-01 10:43:04');
INSERT INTO CheckIn(custID,roomNo,inDate) VALUES(45,'2917','2008-07-03 15:44:34');
INSERT INTO CheckIn(custID,roomNo,inDate) VALUES(71,'4818','2013-06-19 11:16:54');
INSERT INTO CheckIn(custID,roomNo,inDate) VALUES(24,'2004','2012-10-27 10:36:03');
INSERT INTO CheckIn(custID,roomNo,inDate) VALUES(25,'5012','2008-10-14 00:25:13');
INSERT INTO CheckIn(custID,roomNo,inDate) VALUES(17,'0417','2011-03-05 01:30:29');
INSERT INTO CheckIn(custID,roomNo,inDate) VALUES(87,'3809','2015-03-21 01:41:57');
INSERT INTO CheckIn(custID,roomNo,inDate) VALUES(46,'3020','2007-02-11 19:16:39');
INSERT INTO CheckIn(custID,roomNo,inDate) VALUES(43,'1810','2011-12-15 13:08:52');
INSERT INTO CheckIn(custID,roomNo,inDate) VALUES(92,'4703','2011-12-06 02:03:34');
INSERT INTO CheckIn(custID,roomNo,inDate) VALUES(33,'2119','2013-04-15 19:06:15');
INSERT INTO CheckIn(custID,roomNo,inDate) VALUES(66,'3304','2018-06-14 03:04:13');
INSERT INTO CheckIn(custID,roomNo,inDate) VALUES(65,'4213','2006-11-24 16:28:09');
INSERT INTO CheckIn(custID,roomNo,inDate) VALUES(48,'1513','2006-10-19 07:21:39');
INSERT INTO CheckIn(custID,roomNo,inDate) VALUES(2,'3907','2010-08-06 02:08:52');
INSERT INTO CheckIn(custID,roomNo,inDate) VALUES(51,'4514','2017-01-03 13:15:09');
INSERT INTO CheckIn(custID,roomNo,inDate) VALUES(63,'4314','2018-01-01 19:39:42');
INSERT INTO CheckIn(custID,roomNo,inDate) VALUES(11,'2707','2014-04-06 14:29:03');
INSERT INTO CheckIn(custID,roomNo,inDate) VALUES(3,'1408','2012-02-09 01:45:14');
INSERT INTO CheckIn(custID,roomNo,inDate) VALUES(34,'0703','2014-09-14 11:46:52');
INSERT INTO CheckIn(custID,roomNo,inDate) VALUES(52,'3912','2014-03-09 06:53:34');
INSERT INTO CheckIn(custID,roomNo,inDate) VALUES(27,'2211','2005-05-14 13:35:17');
INSERT INTO CheckIn(custID,roomNo,inDate) VALUES(22,'3311','2012-06-06 06:26:18');
INSERT INTO CheckIn(custID,roomNo,inDate) VALUES(98,'2616','2008-09-19 15:04:40');
INSERT INTO CheckIn(custID,roomNo,inDate) VALUES(35,'0720','2017-02-26 05:14:48');
INSERT INTO CheckIn(custID,roomNo,inDate) VALUES(14,'3908','2018-05-19 06:42:19');
INSERT INTO CheckIn(custID,roomNo,inDate) VALUES(85,'4408','2014-12-01 10:01:35');
INSERT INTO CheckIn(custID,roomNo,inDate) VALUES(57,'3107','2007-04-30 15:35:51');
INSERT INTO CheckIn(custID,roomNo,inDate) VALUES(82,'1912','2013-07-04 05:25:42');
INSERT INTO CheckIn(custID,roomNo,inDate) VALUES(6,'2618','2010-06-14 17:40:37');
INSERT INTO CheckIn(custID,roomNo,inDate) VALUES(78,'2006','2009-12-09 20:02:24');
INSERT INTO CheckIn(custID,roomNo,inDate) VALUES(95,'3712','2014-03-05 10:25:27');
INSERT INTO CheckIn(custID,roomNo,inDate) VALUES(9,'3001','2012-01-14 18:18:10');
INSERT INTO CheckIn(custID,roomNo,inDate) VALUES(49,'3910','2009-05-13 16:08:11');
INSERT INTO CheckIn(custID,roomNo,inDate) VALUES(13,'3216','2006-05-11 18:45:38');
INSERT INTO CheckIn(custID,roomNo,inDate) VALUES(47,'4420','2007-02-22 21:23:28');
INSERT INTO CheckIn(custID,roomNo,inDate) VALUES(96,'1711','2012-09-08 02:56:27');
INSERT INTO CheckIn(custID,roomNo,inDate) VALUES(61,'4103','2012-12-06 20:18:55');
INSERT INTO CheckIn(custID,roomNo,inDate) VALUES(70,'4014','2007-12-22 07:09:17');
INSERT INTO CheckIn(custID,roomNo,inDate) VALUES(10,'0820','2010-01-09 09:58:03');
INSERT INTO CheckIn(custID,roomNo,inDate) VALUES(28,'1603','2005-06-07 04:48:02');
INSERT INTO CheckIn(custID,roomNo,inDate) VALUES(89,'4002','2005-08-08 21:44:15');
INSERT INTO CheckIn(custID,roomNo,inDate) VALUES(37,'0110','2005-05-29 04:09:13');
INSERT INTO CheckIn(custID,roomNo,inDate) VALUES(53,'4406','2018-08-08 07:08:46');
INSERT INTO CheckIn(custID,roomNo,inDate) VALUES(93,'1913','2015-07-09 06:35:56');
INSERT INTO CheckIn(custID,roomNo,inDate) VALUES(26,'1019','2006-02-19 17:28:47');
INSERT INTO CheckIn(custID,roomNo,inDate) VALUES(90,'0818','2009-11-23 12:42:41');
INSERT INTO CheckIn(custID,roomNo,inDate) VALUES(38,'2107','2014-06-26 00:05:28');
INSERT INTO CheckIn(custID,roomNo,inDate) VALUES(68,'3714','2013-12-22 08:06:47');
INSERT INTO CheckIn(custID,roomNo,inDate) VALUES(29,'0213','2011-07-21 21:57:21');
INSERT INTO CheckIn(custID,roomNo,inDate) VALUES(97,'1508','2016-03-30 21:46:32');
INSERT INTO CheckIn(custID,roomNo,inDate) VALUES(80,'1207','2010-04-12 19:21:35');
INSERT INTO CheckIn(custID,roomNo,inDate) VALUES(74,'3418','2016-03-28 09:00:14');
INSERT INTO CheckIn(custID,roomNo,inDate) VALUES(60,'2615','2010-12-09 07:51:19');
INSERT INTO CheckIn(custID,roomNo,inDate) VALUES(8,'4405','2018-11-30 11:57:37');
INSERT INTO CheckIn(custID,roomNo,inDate) VALUES(7,'3318','2013-09-07 14:47:09');
INSERT INTO CheckIn(custID,roomNo,inDate) VALUES(59,'1010','2018-04-21 02:49:01');
INSERT INTO CheckIn(custID,roomNo,inDate) VALUES(40,'2011','2013-12-18 12:54:25');
INSERT INTO CheckIn(custID,roomNo,inDate) VALUES(32,'1213','2007-09-22 03:34:12');
INSERT INTO CheckIn(custID,roomNo,inDate) VALUES(72,'0910','2007-07-08 08:27:10');
INSERT INTO CheckIn(custID,roomNo,inDate) VALUES(73,'3706','2006-10-17 02:52:33');
INSERT INTO CheckIn(custID,roomNo,inDate) VALUES(69,'2402','2013-03-14 21:03:43');
INSERT INTO CheckIn(custID,roomNo,inDate) VALUES(54,'4619','2018-01-27 12:44:49');
INSERT INTO CheckIn(custID,roomNo,inDate) VALUES(21,'0211','2016-05-23 05:24:39');
INSERT INTO CheckIn(custID,roomNo,inDate) VALUES(4,'1617','2012-07-26 16:41:20');
INSERT INTO CheckIn(custID,roomNo,inDate) VALUES(67,'2820','2009-09-20 17:56:22');

INSERT INTO CheckOut(custID,roomNo,outDate) VALUES(4,'2413','2016-04-16 20:43:52');
INSERT INTO CheckOut(custID,roomNo,outDate) VALUES(6,'2206','2012-11-14 05:10:52');
INSERT INTO CheckOut(custID,roomNo,outDate) VALUES(7,'1503','2018-12-16 20:25:39');
INSERT INTO CheckOut(custID,roomNo,outDate) VALUES(61,'4312','2016-07-15 05:45:39');
INSERT INTO CheckOut(custID,roomNo,outDate) VALUES(40,'4606','2015-11-23 20:30:01');
INSERT INTO CheckOut(custID,roomNo,outDate) VALUES(47,'3303','2015-03-11 10:31:38');
INSERT INTO CheckOut(custID,roomNo,outDate) VALUES(53,'1113','2018-11-26 06:19:24');
INSERT INTO CheckOut(custID,roomNo,outDate) VALUES(65,'1518','2011-07-14 13:48:37');
INSERT INTO CheckOut(custID,roomNo,outDate) VALUES(98,'1210','2010-07-13 10:11:29');
INSERT INTO CheckOut(custID,roomNo,outDate) VALUES(34,'2017','2018-01-01 17:23:25');
INSERT INTO CheckOut(custID,roomNo,outDate) VALUES(29,'3018','2014-10-25 14:43:46');
INSERT INTO CheckOut(custID,roomNo,outDate) VALUES(14,'1818','2018-07-22 20:27:19');
INSERT INTO CheckOut(custID,roomNo,outDate) VALUES(68,'1909','2014-04-05 02:36:09');
INSERT INTO CheckOut(custID,roomNo,outDate) VALUES(76,'1213','2016-09-08 06:16:50');
INSERT INTO CheckOut(custID,roomNo,outDate) VALUES(85,'1214','2016-10-01 18:19:24');
INSERT INTO CheckOut(custID,roomNo,outDate) VALUES(51,'5005','2017-09-23 15:09:54');
INSERT INTO CheckOut(custID,roomNo,outDate) VALUES(25,'0808','2016-04-29 14:32:41');
INSERT INTO CheckOut(custID,roomNo,outDate) VALUES(63,'2115','2018-04-16 19:52:54');
INSERT INTO CheckOut(custID,roomNo,outDate) VALUES(9,'0517','2012-01-30 09:06:40');
INSERT INTO CheckOut(custID,roomNo,outDate) VALUES(3,'4912','2014-07-17 18:30:24');
INSERT INTO CheckOut(custID,roomNo,outDate) VALUES(18,'0105','2016-02-02 01:17:38');
INSERT INTO CheckOut(custID,roomNo,outDate) VALUES(38,'0918','2014-08-26 13:34:53');
INSERT INTO CheckOut(custID,roomNo,outDate) VALUES(92,'1510','2012-04-12 00:16:10');
INSERT INTO CheckOut(custID,roomNo,outDate) VALUES(13,'4908','2012-04-21 18:39:46');
INSERT INTO CheckOut(custID,roomNo,outDate) VALUES(83,'3317','2018-01-25 18:31:15');
INSERT INTO CheckOut(custID,roomNo,outDate) VALUES(67,'1302','2017-09-28 11:15:09');
INSERT INTO CheckOut(custID,roomNo,outDate) VALUES(73,'0209','2009-01-16 07:25:33');
INSERT INTO CheckOut(custID,roomNo,outDate) VALUES(23,'0815','2016-04-18 22:17:17');
INSERT INTO CheckOut(custID,roomNo,outDate) VALUES(44,'2107','2015-02-14 03:56:08');
INSERT INTO CheckOut(custID,roomNo,outDate) VALUES(78,'2304','2012-05-02 18:10:24');
INSERT INTO CheckOut(custID,roomNo,outDate) VALUES(32,'3008','2008-01-17 20:06:20');
INSERT INTO CheckOut(custID,roomNo,outDate) VALUES(87,'1110','2018-11-12 11:45:50');
INSERT INTO CheckOut(custID,roomNo,outDate) VALUES(80,'1115','2014-03-27 06:52:27');
INSERT INTO CheckOut(custID,roomNo,outDate) VALUES(70,'3219','2017-07-22 00:54:28');
INSERT INTO CheckOut(custID,roomNo,outDate) VALUES(52,'1804','2017-09-03 05:37:28');
INSERT INTO CheckOut(custID,roomNo,outDate) VALUES(57,'0320','2009-05-29 08:16:56');
INSERT INTO CheckOut(custID,roomNo,outDate) VALUES(93,'0706','2017-01-30 10:02:29');
INSERT INTO CheckOut(custID,roomNo,outDate) VALUES(27,'1418','2014-11-06 18:09:51');
INSERT INTO CheckOut(custID,roomNo,outDate) VALUES(81,'3512','2018-11-30 19:16:35');
INSERT INTO CheckOut(custID,roomNo,outDate) VALUES(45,'3602','2013-10-25 08:37:22');
INSERT INTO CheckOut(custID,roomNo,outDate) VALUES(71,'0717','2016-06-27 14:54:44');
INSERT INTO CheckOut(custID,roomNo,outDate) VALUES(8,'1111','2018-12-31 17:56:06');
INSERT INTO CheckOut(custID,roomNo,outDate) VALUES(59,'2008','2018-05-15 08:57:24');
INSERT INTO CheckOut(custID,roomNo,outDate) VALUES(22,'4213','2013-01-12 06:06:23');
INSERT INTO CheckOut(custID,roomNo,outDate) VALUES(54,'1814','2018-04-10 09:31:07');
INSERT INTO CheckOut(custID,roomNo,outDate) VALUES(24,'1911','2018-06-09 09:09:05');
INSERT INTO CheckOut(custID,roomNo,outDate) VALUES(90,'0115','2012-12-22 20:57:04');
INSERT INTO CheckOut(custID,roomNo,outDate) VALUES(33,'3901','2014-06-09 07:02:45');
INSERT INTO CheckOut(custID,roomNo,outDate) VALUES(21,'3005','2018-10-15 18:04:55');
INSERT INTO CheckOut(custID,roomNo,outDate) VALUES(11,'5018','2017-12-05 04:07:00');

INSERT INTO Department(dID,dName) VALUES("CTR","Catering");
INSERT INTO Department(dID,dName) VALUES("ADM","Administration");
INSERT INTO Department(dID,dName) VALUES("CS","Information_Technology");
INSERT INTO Department(dID,dName) VALUES("EVT","Events");

INSERT INTO DepartmentDetails(dID,eID,post,joinDate,salary) VALUES("ADM",4,"Accountant",'2011-4-3',57468);
INSERT INTO DepartmentDetails(dID,eID,post,joinDate,salary) VALUES("CS",75,"Software Engineer",'2016-5-30',49586);
INSERT INTO DepartmentDetails(dID,eID,post,joinDate,salary) VALUES("CS",41,"Data Analyst",'2011-1-1',71264);
INSERT INTO DepartmentDetails(dID,eID,post,joinDate,salary) VALUES("ADM",76,"Receptionist",'2018-4-15',5182);
INSERT INTO DepartmentDetails(dID,eID,post,joinDate,salary) VALUES("EVT",79,"Photographer",'2007-10-29',86081);
INSERT INTO DepartmentDetails(dID,eID,post,joinDate,salary) VALUES("EVT",12,"Photographer",'2015-4-21',70657);
INSERT INTO DepartmentDetails(dID,eID,post,joinDate,salary) VALUES("EVT",98,"Photographer",'2013-3-20',74091);
INSERT INTO DepartmentDetails(dID,eID,post,joinDate,salary) VALUES("CS",1,"Software Engineer",'2012-3-19',40384);
INSERT INTO DepartmentDetails(dID,eID,post,joinDate,salary) VALUES("ADM",97,"Accountant",'2018-8-17',33671);
INSERT INTO DepartmentDetails(dID,eID,post,joinDate,salary) VALUES("EVT",52,"Photographer",'2010-7-13',17970);
INSERT INTO DepartmentDetails(dID,eID,post,joinDate,salary) VALUES("CS",100,"Data Analyst",'2008-6-4',65000);
INSERT INTO DepartmentDetails(dID,eID,post,joinDate,salary) VALUES("EVT",74,"Photographer",'2011-3-30',79951);
INSERT INTO DepartmentDetails(dID,eID,post,joinDate,salary) VALUES("CS",64,"Data Analyst",'2007-3-21',49251);
INSERT INTO DepartmentDetails(dID,eID,post,joinDate,salary) VALUES("ADM",18,"Receptionist",'2001-6-8',29949);
INSERT INTO DepartmentDetails(dID,eID,post,joinDate,salary) VALUES("CS",53,"Software Engineer",'2016-1-22',67442);
INSERT INTO DepartmentDetails(dID,eID,post,joinDate,salary) VALUES("CS",62,"Data Analyst",'2013-5-22',72882);
INSERT INTO DepartmentDetails(dID,eID,post,joinDate,salary) VALUES("CS",17,"Data Analyst",'2003-2-7',94729);
INSERT INTO DepartmentDetails(dID,eID,post,joinDate,salary) VALUES("EVT",47,"Photographer",'2015-4-8',88656);
INSERT INTO DepartmentDetails(dID,eID,post,joinDate,salary) VALUES("EVT",77,"Photographer",'2003-10-6',7166);
INSERT INTO DepartmentDetails(dID,eID,post,joinDate,salary) VALUES("ADM",24,"Accountant",'2018-1-8',18477);
INSERT INTO DepartmentDetails(dID,eID,post,joinDate,salary) VALUES("EVT",38,"Videographer",'2016-10-26',51097);
INSERT INTO DepartmentDetails(dID,eID,post,joinDate,salary) VALUES("EVT",22,"Videographer",'2006-10-5',80506);
INSERT INTO DepartmentDetails(dID,eID,post,joinDate,salary) VALUES("CS",51,"Software Engineer",'2012-7-3',13096);
INSERT INTO DepartmentDetails(dID,eID,post,joinDate,salary) VALUES("CTR",13,"Waiter",'2003-6-6',58510);
INSERT INTO DepartmentDetails(dID,eID,post,joinDate,salary) VALUES("CTR",95,"Cook",'2007-2-12',33013);
INSERT INTO DepartmentDetails(dID,eID,post,joinDate,salary) VALUES("CTR",43,"Waiter",'2014-3-23',38672);
INSERT INTO DepartmentDetails(dID,eID,post,joinDate,salary) VALUES("ADM",14,"Accountant",'2004-6-3',82834);
INSERT INTO DepartmentDetails(dID,eID,post,joinDate,salary) VALUES("EVT",15,"Photographer",'2002-9-7',58890);
INSERT INTO DepartmentDetails(dID,eID,post,joinDate,salary) VALUES("ADM",33,"Receptionist",'2017-10-11',47851);
INSERT INTO DepartmentDetails(dID,eID,post,joinDate,salary) VALUES("ADM",90,"Accountant",'2014-6-30',80220);
INSERT INTO DepartmentDetails(dID,eID,post,joinDate,salary) VALUES("EVT",59,"Photographer",'2008-5-16',34713);
INSERT INTO DepartmentDetails(dID,eID,post,joinDate,salary) VALUES("ADM",54,"Receptionist",'2001-8-20',34920);
INSERT INTO DepartmentDetails(dID,eID,post,joinDate,salary) VALUES("EVT",65,"Photographer",'2017-11-8',40618);
INSERT INTO DepartmentDetails(dID,eID,post,joinDate,salary) VALUES("EVT",93,"Videographer",'2006-7-8',16157);
INSERT INTO DepartmentDetails(dID,eID,post,joinDate,salary) VALUES("EVT",27,"Photographer",'2009-2-28',74155);
INSERT INTO DepartmentDetails(dID,eID,post,joinDate,salary) VALUES("CS",30,"Data Analyst",'2011-5-1',64750);
INSERT INTO DepartmentDetails(dID,eID,post,joinDate,salary) VALUES("EVT",16,"Photographer",'2009-6-23',79144);
INSERT INTO DepartmentDetails(dID,eID,post,joinDate,salary) VALUES("CTR",83,"Cook",'2011-1-13',55418);
INSERT INTO DepartmentDetails(dID,eID,post,joinDate,salary) VALUES("CTR",69,"Waiter",'2004-7-28',23344);
INSERT INTO DepartmentDetails(dID,eID,post,joinDate,salary) VALUES("CTR",45,"Cook",'2005-1-24',75230);
INSERT INTO DepartmentDetails(dID,eID,post,joinDate,salary) VALUES("EVT",46,"Photographer",'2005-3-21',80214);
INSERT INTO DepartmentDetails(dID,eID,post,joinDate,salary) VALUES("CS",86,"Data Analyst",'2010-5-18',22207);
INSERT INTO DepartmentDetails(dID,eID,post,joinDate,salary) VALUES("CS",68,"Data Analyst",'2016-8-8',68191);
INSERT INTO DepartmentDetails(dID,eID,post,joinDate,salary) VALUES("ADM",67,"Accountant",'2003-12-15',74775);
INSERT INTO DepartmentDetails(dID,eID,post,joinDate,salary) VALUES("CS",99,"Software Engineer",'2009-1-30',53897);
INSERT INTO DepartmentDetails(dID,eID,post,joinDate,salary) VALUES("EVT",78,"Videographer",'2016-9-15',45356);
INSERT INTO DepartmentDetails(dID,eID,post,joinDate,salary) VALUES("ADM",72,"Accountant",'2004-6-28',98496);
INSERT INTO DepartmentDetails(dID,eID,post,joinDate,salary) VALUES("CTR",70,"Cook",'2001-7-20',51542);
INSERT INTO DepartmentDetails(dID,eID,post,joinDate,salary) VALUES("EVT",61,"Photographer",'2006-8-17',65762);
INSERT INTO DepartmentDetails(dID,eID,post,joinDate,salary) VALUES("CS",19,"Data Analyst",'2010-10-22',82845);