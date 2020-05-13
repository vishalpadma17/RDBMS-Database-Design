drop database IF EXISTS sql_project_19200174;

create database sql_project_19200174;

use sql_project_19200174;


#-------------- Tables of the database design--------------------------------------------#


CREATE TABLE Stream_Details(
Stream_ID int AUTO_INCREMENT,
Stream_Title varchar(50),
Stream_Code varchar(10) not null,
Stream_Description longtext,
primary key (Stream_ID)
);

CREATE TABLE Individual_Details (
Individual_ID varchar(10),
Individual_Fname varchar(50) not null,
Individual_Lname varchar(50) not null,
Individual_Stream_ID int,
Gender varchar(7),
Individual_Role varchar(10) check (Individual_Role IN ('Student','Supervisor')),
DOB date,
primary key (Individual_ID),
foreign key (Individual_Stream_ID) references Stream_Details(Stream_ID)
);

CREATE TABLE Contact_And_Address_Details (
Contact_ID int AUTO_INCREMENT,
Individual_ID varchar(10),
Mail_ID varchar(50) check (Mail_ID like '_%@_%'),
Phone_Number Varchar(15),
Address longtext,
Primary key (Contact_ID),
foreign key (Individual_ID) references Individual_Details(Individual_ID)
);

CREATE TABLE Student_Details(
Student_ID varchar(10), # Unique Student ID
Semester_Code int check (Semester_Code BETWEEN 1 AND 6), # Semester Code of the student
Year_Enrolled int, # Year he/she started at the University
Stream varchar(10) check (Stream IN ('CS','DS','CS/DS')), # Stream of the student
GPA double check (GPA  BETWEEN 0 AND 4.2), # GPA of the student up till the current Semester
primary key (Student_ID),
foreign key (Student_ID) references Individual_Details(Individual_ID)
);

CREATE TABLE Project_Details(
Project_ID int AUTO_INCREMENT, # Unique for each Project
Project_Topic varchar(50), # Topic of the Project
Project_Descrption longtext, # Description about the Project
Project_Supervisior_ID varchar(10) not null, # Respective Supervisor for the Project
Project_Stream_ID int not null, # Stream under which the Project comes
Project_Owner_ID varchar(10), 
primary key (Project_ID),
foreign key (Project_Owner_ID) references Individual_Details(Individual_ID),
foreign key (Project_Supervisior_ID) references Individual_Details(Individual_ID),
foreign key (Project_Stream_ID) references Stream_Details(Stream_ID)
);

CREATE TABLE Project_Preferences(
Student_ID varchar(10),
Preference_1 int not null,
Preference_2 int,
Preference_3 int,
Preference_4 int,
Preference_5 int,
Preference_6 int,
Preference_7 int,
Preference_8 int,
Preference_9 int,
Preference_10 int,
Preference_11 int,
Preference_12 int,
Preference_13 int,
Preference_14 int,
Preference_15 int, 
Preference_16 int, 
Preference_17 int, 
Preference_18 int, 
Preference_19 int, 
Preference_20 int, 
primary key (Student_ID),
foreign key (Student_ID) references Student_Details(Student_ID),
foreign key (Preference_1) references Project_Details(Project_ID),
foreign key (Preference_2) references Project_Details(Project_ID),
foreign key (Preference_3) references Project_Details(Project_ID),
foreign key (Preference_4) references Project_Details(Project_ID),
foreign key (Preference_5) references Project_Details(Project_ID),
foreign key (Preference_6) references Project_Details(Project_ID),
foreign key (Preference_7) references Project_Details(Project_ID),
foreign key (Preference_8) references Project_Details(Project_ID),
foreign key (Preference_9) references Project_Details(Project_ID),
foreign key (Preference_10) references Project_Details(Project_ID),
foreign key (Preference_11) references Project_Details(Project_ID),
foreign key (Preference_12) references Project_Details(Project_ID),
foreign key (Preference_13) references Project_Details(Project_ID),
foreign key (Preference_14) references Project_Details(Project_ID),
foreign key (Preference_15) references Project_Details(Project_ID),
foreign key (Preference_16) references Project_Details(Project_ID),
foreign key (Preference_17) references Project_Details(Project_ID),
foreign key (Preference_18) references Project_Details(Project_ID),
foreign key (Preference_19) references Project_Details(Project_ID),
foreign key (Preference_20) references Project_Details(Project_ID)
);

CREATE TABLE Projects_Allocated(
Student_ID varchar(10),
Project_ID int not null,
Satisfaction_Score int,
Selected_Preference int,
primary key (Student_ID),
foreign key (Student_ID) references Student_Details(Student_ID),
foreign key (Project_ID) references Project_Details(Project_ID)
);

#-------------- Procedures --------------------------------------------#

USE `sql_project_19200174`;
DROP procedure IF EXISTS `Insert_into_Individual_details`;

DELIMITER $$
USE `sql_project_19200174`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Insert_into_Individual_details`(
IN Individual_ID VARCHAR(10),
IN Individual_Fname VARCHAR(50),
IN Individual_Lname VARCHAR(50),
IN Individual_Stream_ID INT,
IN Gender VARCHAR(10),
IN Individual_Role VARCHAR(10),
IN DOB DATE,
IN Mail_ID VARCHAR(50),
IN Phone_Number VARCHAR(20),
IN Address LONGTEXT
)
BEGIN
Insert Into Individual_Details Values (Individual_ID,Individual_Fname,Individual_Lname,Individual_Stream_ID,Gender,Individual_Role,DOB);
Insert Into Contact_And_Address_Details (Individual_ID,Mail_ID,Phone_Number,Address) 
Values(Individual_ID,Mail_ID,Phone_Number,Address);
END$$

DELIMITER ;

USE `sql_project_19200174`;
DROP procedure IF EXISTS `Insert_into_Projects_Allocated`;

DELIMITER $$
USE `sql_project_19200174`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Insert_into_Projects_Allocated`(
IN Student_ID varchar(10),
IN Project_ID int,
IN Satisfaction_Score int,
IN Selected_Preference int
)
BEGIN
Insert Into Projects_Allocated Values (Student_ID , Project_ID , Satisfaction_Score, Selected_Preference);
END$$

DELIMITER ;



USE `sql_project_19200174`;
DROP procedure IF EXISTS `Projects_Related_to_Student_ID`;

DELIMITER $$
USE `sql_project_19200174`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Projects_Related_to_Student_ID`(
IN ID varchar(10)
)
BEGIN
Declare Str varchar(10);
select Stream into Str from Student_Details where Student_ID = ID;
if Str = "CS" then
SELECT 
        P.Project_ID AS Project_ID,
        P.Project_Topic AS Project_Topic,
		P.Project_Supervisior_ID AS Project_Supervisior_ID,
        P.Project_Owner_ID AS Project_Owner_ID,
        P.Project_Stream_ID AS Project_Stream_ID,
		I.Individual_Fname AS Supervisor_Fname,
		I.Individual_Lname AS Supervisor_Lname
    FROM
        Project_Details P
            JOIN
        Individual_Details I ON (I.Individual_ID = P.Project_Supervisior_ID)
        Where 
        P.Project_Stream_ID ='1';
    elseif Str = "DS" then
    SELECT 
        P.Project_ID AS Project_ID,
        P.Project_Topic AS Project_Topic,
		P.Project_Supervisior_ID AS Project_Supervisior_ID,
        P.Project_Owner_ID AS Project_Owner_ID,
        P.Project_Stream_ID AS Project_Stream_ID,
		I.Individual_Fname AS Supervisor_Fname,
		I.Individual_Lname AS Supervisor_Lname
    FROM
        Project_Details P
            JOIN
        Individual_Details I ON (I.Individual_ID = P.Project_Supervisior_ID)
        Where 
        P.Project_Stream_ID ='2';
    elseif Str = "CS/DS" then
    SELECT 
        P.Project_ID AS Project_ID,
        P.Project_Topic AS Project_Topic,
		P.Project_Supervisior_ID AS Project_Supervisior_ID,
        P.Project_Owner_ID AS Project_Owner_ID,
        P.Project_Stream_ID AS Project_Stream_ID,
		I.Individual_Fname AS Supervisor_Fname,
		I.Individual_Lname AS Supervisor_Lname
    FROM
        Project_Details P
            JOIN
        Individual_Details I ON (I.Individual_ID = P.Project_Supervisior_ID);
	END IF;
END$$

DELIMITER ;

#-------------- Insert statments --------------------------------------------#

#----------------------------------------Inserting Stream details-----------------------------------------------------------
INSERT INTO Stream_Details 
VALUES (null,"Cthulhu Studies","CS","Stream deals with all the different cultures of different parts around the world"),
(null,"Dagon Studies","DS","Stream deals with all the different dance cultures of different parts around the world"),
(null,"Cthulhu Studies and/or Dagon Studies","CS/DS","Stream deals with all the different dance cultures and cultures of different parts around the world");

#---Inserting Student details and contact and address details in individual and Contact&address table respectively-----------
#Using Procedure to enter details into two tables 

Call Insert_into_Individual_details("Stu001","Tony","Haden",1,"Male","Student","1994-01-04","Mail2@mail.com","0819564287","Address 2 City 1");
Call Insert_into_Individual_details("Stu002","Mike","June",1,"Male","Student","1993-02-07","Mail3@mail.com","0812564287","Address 3 City 1");
Call Insert_into_Individual_details("Stu003","Jane","Chris",1,"Female","Student","1992-05-05","Mail4@mail.com","0812364287","Address 4 City 1");
Call Insert_into_Individual_details("Stu004","June","Christ",1,"Female","Student","1996-07-07","Mail5@mail.com","0812344287","Address 5 City 1");
Call Insert_into_Individual_details("Stu005","Ted","Stone",1,"Male","Student","2000-08-07","Mail6@mail.com","0812345287","Address 6 City 1");
Call Insert_into_Individual_details("Stu006","Henry","Mike",2,"Male","Student","1997-02-07","Mail7@mail.com","0812345687","Address 7 City 1");
Call Insert_into_Individual_details("Stu007","Terry","Crew",2,"Male","Student","1998-09-09","Mail8@mail.com","0812345677","Address 8 City 1");
Call Insert_into_Individual_details("Stu008","Karen","Jones",2,"Female","Student","1991-10-09","Mail9@mail.com","0812345678","Address 9 City 1");
Call Insert_into_Individual_details("Stu009","Judie","Will",2,"Female","Student","1998-01-06","Mail10@mail.com","0912345678","Address 10 City 1");
Call Insert_into_Individual_details("Stu0010","Julie","Will",2,"Female","Student","1995-02-06","Mail11@mail.com","0982345678","Address 11 City 1");
Call Insert_into_Individual_details("Stu0011","Ravi","Sharma",3,"Male","Student","1994-03-06","Mail12@mail.com","0987345678","Address 12 City 1");
Call Insert_into_Individual_details("Stu0012","Sunny","Sharma",3,"Male","Student","1993-04-07","Mail13@mail.com","0987645678","Address 13 City 1");
Call Insert_into_Individual_details("Stu0013","Nithin","Thimi",3,"Male","Student","1994-04-08","Mail14@mail.com","0987655678","Address 14 City 1");
Call Insert_into_Individual_details("Stu0014","Nitya","Omkar",3,"Female","Student","1992-02-01","Mail15@mail.com","0987654678","Address 15 City 1");
Call Insert_into_Individual_details("Stu0015","Ruhi","Pandit",3,"Female","Student","1996-08-01","Mail16@mail.com","0987654378","Address 1 City 2");
Call Insert_into_Individual_details("Stu0016","Harry","Will",1,"Male","Student","1995-01-04","Mail17@mail.com","0987654328","Address 2 City 2");
Call Insert_into_Individual_details("Stu0017","Ron","Smith",1,"Male","Student","1997-01-09","Mail18@mail.com","0987654321","Address 3 City 2");
Call Insert_into_Individual_details("Stu0018","Bob","Chris",1,"Male","Student","2000-05-05","Mail19@mail.com","0687654321","Address 4 City 2");
Call Insert_into_Individual_details("Stu0019","Lilly","Chris",1,"Female","Student","1992-02-07","Mail20@mail.com","0687654301","Address 5 City 2");
Call Insert_into_Individual_details("Stu0020","Justin","Stu",1,"Male","Student","1996-01-07","Mail21@mail.com","0687654308","Address 6 City 2");
Call Insert_into_Individual_details("Stu0021","Hen","Mike",2,"Male","Student","1993-08-01","Mail22@mail.com","0687694308","Address 7 City 2");
Call Insert_into_Individual_details("Stu0022","Yen","Kenny",2,"Male","Student","1995-02-09","Mail23@mail.com","0697694308","Address 8 City 2");
Call Insert_into_Individual_details("Stu0023","Kenny","Smith",2,"Male","Student","1994-8-01","Mail24@mail.com","0697694338","Address 9 City 2");
Call Insert_into_Individual_details("Stu0024","Eli","Will",2,"Female","Student","1991-06-06","Mail25@mail.com","0797694338","Address 10 City 2");
Call Insert_into_Individual_details("Stu0025","Sindy","James",2,"Female","Student","1996-01-06","Mail26@mail.com","0197694338","Address 11 City 2");
Call Insert_into_Individual_details("Stu0026","Will","Smith",3,"Male","Student","2000-01-06","Mail27@mail.com","0807694338","Address 11 City 2");
Call Insert_into_Individual_details("Stu0027","Jaden","Smith",3,"Male","Student","1997-01-07","Mail28@mail.com","0807604338","Address 12 City 2");
Call Insert_into_Individual_details("Stu0028","Lana","Smith",3,"Female","Student","1997-02-08","Mail29@mail.com","0807304338","Address 13 City 2");
Call Insert_into_Individual_details("Stu0029","Bella","Kane",3,"Female","Student","1992-01-01","Mail30@mail.com","0807304339","Address 14 City 2");
Call Insert_into_Individual_details("Stu0030","Lauren","Jane",3,"Female","Student","1995-08-01","Mail31@mail.com","0807334339","Address 15 City 2");

#---Inserting Supervisor details and contact and address details in individual and Contact&address table respectively-----------

Call Insert_into_Individual_details("Super001","Jaden","Jones",1,"Male","Supervisor","1984-01-04","Prof1@mail.com","0707334339","Address 1 City 3");
Call Insert_into_Individual_details("Super002","Mathew","Smith",1,"Male","Supervisor","1983-01-07","Prof2@mail.com","0607134339","Address 2 City 3");
Call Insert_into_Individual_details("Super003","Katie","Chris",1,"Female","Supervisor","1984-05-05","Prof3@mail.com","0607134389","Address 3 City 3");
Call Insert_into_Individual_details("Super004","Hen","James",2,"Male","Supervisor","1979-02-07","Prof4@mail.com","0607135389","Address 4 City 3");
Call Insert_into_Individual_details("Super005","Ted","Math",2,"Male","Supervisor","1980-02-09","Prof5@mail.com","0707135389","Address 5 City 3");
Call Insert_into_Individual_details("Super006","Karen","Smith",2,"Female","Supervisor","1985-10-01","Prof6@mail.com","0707131389","Address 6 City 3");
Call Insert_into_Individual_details("Super007","Ashok","Sharma",3,"Male","Supervisor","1977-03-06","Prof8@mail.com","0807131389","Address 7 City 3");
Call Insert_into_Individual_details("Super008","Rohit","Rathod",3,"Male","Supervisor","1983-02-07","Prof8@mail.com","0807131380","Address 8 City 3");
Call Insert_into_Individual_details("Super009","Nithin","Goud",3,"Male","Supervisor","1982-04-01","Prof9@mail.com","0507131380","Address 9 City 3");

#----------------------------------------Inserting Student details in Student table -----------------------------------------------------------

INSERT INTO Student_Details 
VALUES ("Stu001",1,"2017","CS",null),
("Stu002",5,"2019","CS","3.5"),
("Stu003",5,"2019","CS","2.9"),
("Stu004",5,"2019","CS","4.0"),
("Stu005",4,"2019","CS","3.9"),
("Stu006",2,"2017","CS","3.1"),
("Stu007",3,"2018","CS","3.8"),
("Stu008",3,"2018","CS","3.5"),
("Stu009",5,"2019","CS","4.0"),
("Stu0010",5,"2019","CS","3.0"),
("Stu0011",4,"2018","DS","3.3"),
("Stu0012",5,"2019","DS","3.1"),
("Stu0013",4,"2018","DS","2.5"),
("Stu0014",1,"2017","DS",null),
("Stu0015",5,"2019","DS","3.9"),
("Stu0016",2,"2017","DS","3.4"),
("Stu0017",5,"2019","DS","3.2"),
("Stu0018",5,"2019","DS","4.0"),
("Stu0019",5,"2019","DS","3.0"),
("Stu0020",5,"2019","DS","3.7"),
("Stu0021",5,"2019","CS/DS","3.7"),
("Stu0022",4,"2018","CS/DS","2.7"),
("Stu0023",2,"2017","CS/DS","3.3"),
("Stu0024",3,"2018","CS/DS","4.1"),
("Stu0025",1,"2017","CS/DS",null),
("Stu0026",5,"2019","CS/DS","3.8"),
("Stu0027",5,"2019","CS/DS","3.3"),
("Stu0028",5,"2019","CS/DS","3.1"),
("Stu0029",5,"2019","CS/DS","3.0"),
("Stu0030",5,"2019","CS/DS","3.9");

#----------------------------------------Inserting Project details -----------------------------------------------------------

INSERT INTO project_details values(null,"CS Culture1","Stream deals with all the different cultures of different parts around the world","Super001",1,"Super001"),
(null,"CS Culture2","Stream deals with all the different cultures of different parts around the world","Super002",1,"Super002"),
(null,"CS Culture3","Stream deals with all the different cultures of different parts around the world","Super003",1,"Super003"),
(null,"CS Culture4","Stream deals with all the different cultures of different parts around the world","Super005",1,"Stu005"),
(null,"CS Culture5","Stream deals with all the different cultures of different parts around the world","Super001",1,"Super001"),
(null,"CS Culture6","Stream deals with all the different cultures of different parts around the world","Super002",1,"Super002"),
(null,"CS Culture7","Stream deals with all the different cultures of different parts around the world","Super003",1,"Super003"),
(null,"CS Culture8","Stream deals with all the different cultures of different parts around the world","Super005",1,"Super005"),
(null,"CS Culture9","Stream deals with all the different cultures of different parts around the world","Super006",1,"Super006"),
(null,"CS Culture10","Stream deals with all the different cultures of different parts around the world","Super007",1,"Super007"),
(null,"CS Culture11","Stream deals with all the different cultures of different parts around the world","Super007",1,"Stu002"),
(null,"DS Dagon Culture1","Stream deals with all the different dance cultures of different parts around the world","Super004",2,"Super004"),
(null,"DS Dagon Culture2","Stream deals with all the different dance cultures of different parts around the world","Super005",2,"Super005"),
(null,"DS Dagon Culture3","Stream deals with all the different dance cultures of different parts around the world","Super006",2,"Super006"),
(null,"DS Dagon Culture4","Stream deals with all the different dance cultures of different parts around the world","Super002",2,"Stu0012"),
(null,"DS Dagon Culture5","Stream deals with all the different dance cultures of different parts around the world","Super004",2,"Super004"),
(null,"DS Dagon Culture6","Stream deals with all the different dance cultures of different parts around the world","Super005",2,"Super005"),
(null,"DS Dagon Culture7","Stream deals with all the different dance cultures of different parts around the world","Super006",2,"Super006"),
(null,"DS Dagon Culture8","Stream deals with all the different dance cultures of different parts around the world","Super007",2,"Super007"),
(null,"DS Dagon Culture9","Stream deals with all the different dance cultures of different parts around the world","Super008",2,"Super008"),
(null,"DS Dagon Culture10","Stream deals with all the different dance cultures of different parts around the world","Super009",2,"Super009"),
(null,"DS Dagon Culture11","Stream deals with all the different dance cultures of different parts around the world","Super003",2,"Stu0012"),
(null,"CS/DS Culture1","Stream deals with all the different dance cultures and cultures of different parts around the world","Super007",3,"Super007"),
(null,"CS/DS Culture2","Stream deals with all the different dance cultures and cultures of different parts around the world","Super008",3,"Super008"),
(null,"CS/DS Culture3","Stream deals with all the different dance cultures and cultures of different parts around the world","Super009",3,"Super009"),
(null,"CS/DS Culture4","Stream deals with all the different dance cultures and cultures of different parts around the world","Super001",3,"Stu0027"),
(null,"CS/DS Culture5","Stream deals with all the different dance cultures and cultures of different parts around the world","Super007",3,"Super007"),
(null,"CS/DS Culture6","Stream deals with all the different dance cultures and cultures of different parts around the world","Super008",3,"Super008"),
(null,"CS/DS Culture7","Stream deals with all the different dance cultures and cultures of different parts around the world","Super009",3,"Super009"),
(null,"CS/DS Culture8","Stream deals with all the different dance cultures and cultures of different parts around the world","Super002",3,"Super002"),
(null,"CS/DS Culture9","Stream deals with all the different dance cultures and cultures of different parts around the world","Super003",3,"Super003"),
(null,"CS/DS Culture10","Stream deals with all the different dance cultures and cultures of different parts around the world","Super001",3,"Super001"),
(null,"CS/DS Culture11","Stream deals with all the different dance cultures and cultures of different parts around the world","Super006",3,"Stu0030");

#----------------------------------------Inserting Project Preferrences by Student -----------------------------------------------------------

INSERT INTO Project_Preferences (Student_ID,Preference_1,Preference_2,Preference_3,Preference_4,Preference_5,Preference_6,Preference_7,Preference_8) 
Values ("Stu002",11,1,2,3,4,5,6,7);

INSERT INTO Project_Preferences (Student_ID,Preference_1,Preference_2,Preference_3,Preference_4,Preference_5,Preference_6,Preference_7,Preference_8,Preference_9) 
Values ("Stu003",11,10,9,8,7,6,5,4,3);

INSERT INTO Project_Preferences (Student_ID,Preference_1,Preference_2,Preference_3,Preference_4,Preference_5,Preference_6,Preference_7,Preference_8,Preference_9,Preference_10,Preference_11) 
Values ("Stu004",5,1,8,3,9,10,11,4,2,6,7);

INSERT INTO Project_Preferences (Student_ID,Preference_1,Preference_2,Preference_3,Preference_4,Preference_5,Preference_6,Preference_7,Preference_8)
Values ("Stu005",4,8,1,7,2,9,6,11);

INSERT INTO Project_Preferences (Student_ID,Preference_1,Preference_2,Preference_3,Preference_4,Preference_5,Preference_6,Preference_7,Preference_8,Preference_9,Preference_10,Preference_11) 
Values ("Stu009",11,4,2,6,7,5,1,8,3,9,10);

INSERT INTO Project_Preferences (Student_ID,Preference_1,Preference_2,Preference_3,Preference_4)
Values ("Stu0010",7,5,1,8);

INSERT INTO Project_Preferences
(Student_ID,Preference_1,Preference_2,Preference_3,Preference_4,Preference_5,Preference_6,Preference_7,Preference_8,Preference_9,Preference_10,Preference_11) 
Values ("Stu0012",15,22,12,13,14,16,17,18,19,20,21);

INSERT INTO Project_Preferences (Student_ID,Preference_1,Preference_2,Preference_3,Preference_4,Preference_5,Preference_6)
Values ("Stu0015",15,12,14,22,21,18);

INSERT INTO Project_Preferences (Student_ID,Preference_1,Preference_2,Preference_3,Preference_4,Preference_5,Preference_6,Preference_7)
Values ("Stu0017",19,20,21,22,12,15,14);

INSERT INTO Project_Preferences (Student_ID,Preference_1,Preference_2,Preference_3,Preference_4,Preference_5,Preference_6,Preference_7)
Values ("Stu0018",15,12,19,18,16,21,17);

INSERT INTO Project_Preferences (Student_ID,Preference_1,Preference_2,Preference_3,Preference_4,Preference_5,Preference_6)
Values ("Stu0019",15,16,17,22,19,20);

INSERT INTO Project_Preferences (Student_ID,Preference_1,Preference_2)
Values ("Stu0020",12,19);

INSERT INTO Project_Preferences (Student_ID,Preference_1,Preference_2,Preference_3,Preference_4,Preference_5,Preference_6,Preference_7,Preference_8,Preference_9,Preference_10,Preference_11,Preference_12)
Values ("Stu0021",5,18,33,32,28,26,24,29,30,8,9,10);

INSERT INTO Project_Preferences
(Student_ID,Preference_1,Preference_2,Preference_3,Preference_4,Preference_5,Preference_6,Preference_7,Preference_8,Preference_9,Preference_10,Preference_11,Preference_12,Preference_13,Preference_14) 
Values ("Stu0026",9,28,25,14,16,20,31,17,12,11,8,3,2,7);

INSERT INTO Project_Preferences (Student_ID,Preference_1,Preference_2,Preference_3,Preference_4,Preference_5,Preference_6,Preference_7,Preference_8,Preference_9,Preference_10,Preference_11,Preference_12)
Values ("Stu0027",21,33,26,5,7,19,17,22,24,25,28,20);

INSERT INTO Project_Preferences (Student_ID,Preference_1,Preference_2,Preference_3,Preference_4,Preference_5,Preference_6,Preference_7,Preference_8,Preference_9,Preference_10)
Values ("Stu0028",8,9,6,2,4,30,29,28,27,23);

INSERT INTO Project_Preferences
(Student_ID,Preference_1,Preference_2,Preference_3,Preference_4,Preference_5,Preference_6,Preference_7,Preference_8,Preference_9,Preference_10,Preference_11,Preference_12,Preference_13,Preference_14) 
Values ("Stu0029",30,29,28,27,26,25,24,23,22,21,20,5,2,3);

INSERT INTO Project_Preferences (Student_ID,Preference_1,Preference_2,Preference_3,Preference_4,Preference_5,Preference_6,Preference_7,Preference_8,Preference_9,Preference_10,Preference_11,Preference_12)
Values ("Stu0030",33,20,18,14,16,17,2,3,8,9,10,11);

#----------------------------------------Inserting Project Allocations -----------------------------------------------------------

Call Insert_into_Projects_Allocated ("Stu002",5,8,6);
Call Insert_into_Projects_Allocated ("Stu003",11,1,1);
Call Insert_into_Projects_Allocated ("Stu004",4,7,8);
Call Insert_into_Projects_Allocated ("Stu005",8,2,2);
Call Insert_into_Projects_Allocated ("Stu009",10,10,11);
Call Insert_into_Projects_Allocated ("Stu0010",1,6,3);
Call Insert_into_Projects_Allocated ("Stu0012",18,7,8);
Call Insert_into_Projects_Allocated ("Stu0015",21,7,5);
Call Insert_into_Projects_Allocated ("Stu0017",19,1,1);
Call Insert_into_Projects_Allocated ("Stu0018",12,3,2);
Call Insert_into_Projects_Allocated ("Stu0019",20,9,6);
Call Insert_into_Projects_Allocated ("Stu0020",15,10,null);
Call Insert_into_Projects_Allocated ("Stu0021",30,7,9);
Call Insert_into_Projects_Allocated ("Stu0026",16,5,5);
Call Insert_into_Projects_Allocated ("Stu0027",28,7,11);
Call Insert_into_Projects_Allocated ("Stu0028",2,3,4);
Call Insert_into_Projects_Allocated ("Stu0029",27,3,4);
Call Insert_into_Projects_Allocated ("Stu0030",33,1,1);

#-------------- Views --------------------------------------------#

USE `sql_project_19200174`;
CREATE  OR REPLACE VIEW `Student_view` AS
SELECT 
        S.Student_ID AS Student_ID,
        S.GPA AS GPA,
        S.Semester_Code AS Semester_Code,
        S.Stream AS Stream,
        I.Individual_Fname AS Student_Fname,
		I.Individual_Lname AS Student_Lname,
        I.Gender AS Gender,
		I.DOB AS DOB,
        C.Mail_ID,
        C.Phone_Number
    FROM
        Student_Details S
            JOIN
        Individual_Details I ON (S.Student_ID = I.Individual_ID)
			JOIN
		Contact_And_Address_Details C ON (C.Individual_ID = I.Individual_ID)
        Where
        S.Semester_Code = 5;


USE `sql_project_19200174`;
CREATE  OR REPLACE VIEW `Supervisor_view` AS
SELECT 
        I.Individual_ID AS Supervisor_ID,
        I.Individual_Fname AS Supervisor_Fname,
		I.Individual_Lname AS Supervisor_Lname,
        I.Gender AS Gender,
        I.DOB AS DOB,
        I.Individual_Stream_ID AS Stream,
        C.Mail_ID,
        C.Phone_Number
    FROM
        Individual_Details I
        JOIN
		Contact_And_Address_Details C ON (C.Individual_ID = I.Individual_ID)
        Where
        I.Individual_Role = "Supervisor";

		
USE `sql_project_19200174`;
CREATE  OR REPLACE VIEW `Remaining_Projects_View` AS
SELECT 
        P.Project_ID AS Project_ID,
        P.Project_Topic AS Project_Topic,
		P.Project_Supervisior_ID AS Project_Supervisior_ID,
        P.Project_Owner_ID AS Project_Owner_ID,
        P.Project_Stream_ID AS Project_Stream_ID,
		I.Individual_Fname AS Supervisor_Fname,
		I.Individual_Lname AS Supervisor_Lname
    FROM
        Project_Details P
            JOIN
        Individual_Details I ON (I.Individual_ID = P.Project_Supervisior_ID)
        Where
        P.Project_ID in 
        (SELECT P.Project_ID AS Project_ID
		FROM project_details P 
		Where P.Project_ID not in (Select Project_ID from projects_allocated));
        
#-------------- Triggers --------------------------------------------#

DROP TRIGGER IF EXISTS `sql_project_19200174`.`student_details_BEFORE_INSERT`;

DELIMITER $$
USE `sql_project_19200174`$$
CREATE DEFINER = CURRENT_USER TRIGGER `sql_project_19200174`.`student_details_BEFORE_INSERT` BEFORE INSERT ON `student_details` FOR EACH ROW
BEGIN
IF new.GPA<0 or new.GPA>4.2
    then
		Signal SQLState '45000'
		Set Message_text = 'Enter a Valid GPA for the student';
		
	END IF;
END$$
DELIMITER ;

DROP TRIGGER IF EXISTS `sql_project_19200174`.`student_details_BEFORE_UPDATE`;

DELIMITER $$
USE `sql_project_19200174`$$
CREATE DEFINER = CURRENT_USER TRIGGER `sql_project_19200174`.`student_details_BEFORE_UPDATE` BEFORE UPDATE ON `student_details` FOR EACH ROW
BEGIN
IF new.GPA<=0 or new.GPA>4.2
    then
		Signal SQLState '45000'
		Set Message_text = 'Enter a Valid GPA for the student';
		
	END IF;
END$$
DELIMITER ;

DROP TRIGGER IF EXISTS `sql_project_19200174`.`individual_details_BEFORE_INSERT`;

DELIMITER $$
USE `sql_project_19200174`$$
CREATE DEFINER=`root`@`localhost` TRIGGER `individual_details_BEFORE_INSERT` BEFORE INSERT ON `individual_details` FOR EACH ROW BEGIN
DECLARE Age int;
  select ROUND(((TO_DAYS(CURDATE()) - TO_DAYS(new.DOB)) / 365.25),0) into Age;
  if Age < 0 and new.Individual_Role ="Student"
  then
  Signal SQLState '45000'
  Set Message_text = 'Future Date is not allowed in DOB';
  END IF;
  if Age<17 and new.Individual_Role ="Student"
  then
  Signal SQLState '45000'
  Set Message_text = 'Age Should be greater than 17';
  END IF;
  if Age < 0 and new.Individual_Role ="Supervisor"
  then
  Signal SQLState '45000'
  Set Message_text = 'Future Date is not allowed in DOB';
  END IF;
  if Age<18 and new.Individual_Role ="Supervisor"
  then
  Signal SQLState '45000'
  Set Message_text = 'Age Should be greater than 18';
  END IF;
  if new.Individual_ID not like 'Stu%' and new.Individual_Role ="Student"
  then
   Signal SQLState '45000'
  Set Message_text = 'Student ID should start with Stu';
  END IF;
  if new.Individual_ID not like 'Super%' and new.Individual_Role ="Supervisor"
  then
   Signal SQLState '45000'
  Set Message_text = 'Supervisor ID should start with Super';
  END IF;
END$$
DELIMITER ;



DROP TRIGGER IF EXISTS `sql_project_19200174`.`individual_details_BEFORE_UPDATE`;

DELIMITER $$
USE `sql_project_19200174`$$
CREATE DEFINER=`root`@`localhost` TRIGGER `individual_details_BEFORE_UPDATE` BEFORE UPDATE ON `individual_details` FOR EACH ROW BEGIN
DECLARE Age int;
  select ROUND(((TO_DAYS(CURDATE()) - TO_DAYS(new.DOB)) / 365.25),0) into Age;
  if Age < 0 and new.Individual_Role ="Student"
  then
  Signal SQLState '45000'
  Set Message_text = 'Future Date is not allowed in DOB';
  END IF;
  if Age<17 and new.Individual_Role ="Student"
  then
  Signal SQLState '45000'
  Set Message_text = 'Age Should be greater than 17';
  END IF;
  if Age < 0 and new.Individual_Role ="Supervisor"
  then
  Signal SQLState '45000'
  Set Message_text = 'Future Date is not allowed in DOB';
  END IF;
  if Age<18 and new.Individual_Role ="Supervisor"
  then
  Signal SQLState '45000'
  Set Message_text = 'Age Should be greater than 18';
  END IF;
  if new.Individual_ID not like 'Stu%' and new.Individual_Role ="Student"
  then
   Signal SQLState '45000'
  Set Message_text = 'Student ID should start with Stu';
  END IF;
  if new.Individual_ID not like 'Super%' and new.Individual_Role ="Supervisor"
  then
   Signal SQLState '45000'
  Set Message_text = 'Supervisor ID should start with Super';
  END IF;
  END$$
DELIMITER ;



DROP TRIGGER IF EXISTS `sql_project_19200174`.`project_preferences_BEFORE_INSERT`;

DELIMITER $$
USE `sql_project_19200174`$$
CREATE DEFINER = CURRENT_USER TRIGGER `sql_project_19200174`.`project_preferences_BEFORE_INSERT` BEFORE INSERT ON `project_preferences` FOR EACH ROW
BEGIN
if new.Preference_1 is NULL  
    Then
		Signal SQLState '45000'
		Set Message_text = 'Preference_1 should be entered';
	END IF;
END$$
DELIMITER ;

DROP TRIGGER IF EXISTS `sql_project_19200174`.`project_preferences_BEFORE_UPDATE`;

DELIMITER $$
USE `sql_project_19200174`$$
CREATE DEFINER = CURRENT_USER TRIGGER `sql_project_19200174`.`project_preferences_BEFORE_UPDATE` BEFORE UPDATE ON `project_preferences` FOR EACH ROW
BEGIN
if new.Preference_1 is NULL  
    Then
		Signal SQLState '45000'
		Set Message_text = 'Preference_1 should be entered';
	END IF;
END$$
DELIMITER ;


DROP TRIGGER IF EXISTS `sql_project_19200174`.`projects_allocated_BEFORE_INSERT`;

DELIMITER $$
USE `sql_project_19200174`$$
CREATE DEFINER=`root`@`localhost` TRIGGER `projects_allocated_BEFORE_INSERT` BEFORE INSERT ON `projects_allocated` FOR EACH ROW BEGIN
DECLARE STR VARCHAR(10);
DECLARE PSTR VARCHAR(10);
SELECT SV.STREAM INTO STR FROM STUDENT_VIEW SV WHERE SV.STUDENT_ID = new.STUDENT_ID;
SELECT SD.STREAM_CODE INTO PSTR FROM STREAM_DETAILS SD WHERE SD.STREAM_ID IN (SELECT PD.PROJECT_STREAM_ID FROM PROJECT_DETAILS PD WHERE PD.PROJECT_ID = new.PROJECT_ID);
if Not(STR = PSTR) and STR <>'CS/DS'
then
Signal SQLState '45000'
Set Message_text = 'Student ID stream doesnt match with project stream.';
END IF;
if new.Project_ID in (select P.Project_ID from projects_allocated P where (new.Project_ID = P.Project_ID))
then
Signal SQLState '45000'
Set Message_text = 'Project is already allocated';
  END IF;
if new.Student_ID in (select P.Student_ID from projects_allocated P where (new.Student_ID = P.Student_ID))
then
Signal SQLState '45000'
Set Message_text = 'Student has a project already allocated';
END IF;
if new.Student_ID not in (select P.Student_ID from Student_view P where (new.Student_ID = P.Student_ID))
then
Signal SQLState '45000'
Set Message_text = 'Student ID doesnt exist in Student View';
END IF;
END$$
DELIMITER ;

DROP TRIGGER IF EXISTS `sql_project_19200174`.`projects_allocated_BEFORE_UPDATE`;

DELIMITER $$
USE `sql_project_19200174`$$
CREATE DEFINER=`root`@`localhost` TRIGGER `projects_allocated_BEFORE_UPDATE` BEFORE UPDATE ON `projects_allocated` FOR EACH ROW BEGIN
DECLARE STR VARCHAR(10);
DECLARE PSTR VARCHAR(10);
SELECT SV.STREAM INTO STR FROM STUDENT_VIEW SV WHERE SV.STUDENT_ID = new.STUDENT_ID;
SELECT SD.STREAM_CODE INTO PSTR FROM STREAM_DETAILS SD WHERE SD.STREAM_ID IN (SELECT PD.PROJECT_STREAM_ID FROM PROJECT_DETAILS PD WHERE PD.PROJECT_ID = new.PROJECT_ID);
if Not(STR = PSTR) and STR <>'CS/DS'
then
Signal SQLState '45000'
Set Message_text = 'Student ID stream doesnt match with project stream.';
END IF;
if new.Project_ID in (select P.Project_ID from projects_allocated P where (new.Project_ID = P.Project_ID))
then
Signal SQLState '45000'
Set Message_text = 'Project is already allocated';
  END IF;
if new.Student_ID in (select P.Student_ID from projects_allocated P where (new.Student_ID = P.Student_ID))
then
Signal SQLState '45000'
Set Message_text = 'Student has a project already allocated';
END IF;
if new.Student_ID not in (select P.Student_ID from Student_view P where (new.Student_ID = P.Student_ID))
then
Signal SQLState '45000'
Set Message_text = 'Student ID doesnt exist in Student View';
END IF;
END$$
DELIMITER ;

#-------------- Sample test queries --------------------------------------------#
Call Insert_into_Individual_details("Stu0035","Jhonny","Smiths",1,"Male","Student","1994-01-04","MailJS@mail.com","0999564287","Address 20 City 1");

SELECT  I.Individual_ID, I.Individual_Fname, I.Individual_Lname, I.Individual_Stream_ID, I.Gender, I.Individual_Role,
        I.DOB, C.Mail_ID, C.Phone_Number, C.Address
    FROM
        INDIVIDUAL_DETAILS I
            JOIN
        CONTACT_AND_ADDRESS_DETAILS C ON (I.Individual_ID = C.Individual_ID)
        Where 
        I.Individual_ID = 'Stu0035';
        
CALL Insert_into_Projects_Allocated ("Stu0035",3,1,1);

SELECT * FROM PROJECTS_ALLOCATED WHERE STUDENT_ID = 'Stu0035';

CALL Projects_Related_to_Student_ID ('Stu0035');

CALL Projects_Related_to_Student_ID ('Stu0012');

CALL Projects_Related_to_Student_ID ('Stu0027');

SELECT * FROM STUDENT_VIEW;

SELECT * FROM SUPERVISOR_VIEW;

SELECT * FROM REMAINING_PROJECTS_VIEW;

Call Insert_into_Individual_details("Super0015","Jade","Grey",2,"Male","Supervisor","1980-02-04","MailJG@mail.com","0896564087","Address 22 City 1");

INSERT INTO Student_Details 
VALUES ("Stu0036",5,"2017","DS",4.0);

INSERT INTO Project_Preferences (Student_ID)
Values ("Stu0036");

Call Insert_into_Projects_Allocated ("Stu002",33,1,1);
