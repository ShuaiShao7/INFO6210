
--create database gym_group5
--use gym_group5

CREATE MASTER KEY
 ENCRYPTION BY PASSWORD= 'GYM_PASSWORD' ;

 CREATE CERTIFICATE GYM_CERTIFACATE
 WITH SUBJECT='GYM__CERTIFACATE',
 EXPIRY_DATE='2200-01-01';

 CREATE SYMMETRIC KEY GYMSymmetrickey
 WITH ALGORITHM=AES_128
 ENCRYPTION BY CERTIFICATE GYM_CERTIFACATE;

 OPEN SYMMETRIC KEY GYMSymmetrickey
 DECRYPTION BY CERTIFICATE  GYM_CERTIFACATE;

 
CREATE TABLE Supervisor
(SupervisorID INT IDENTITY NOT NULL,
password varbinary(250),
First_Name VarChar(15),
Last_Name VarChar(15),
Supervisor_State VarChar(2),
Supervisor_Street  VarChar(25),
Supervisor_Phone VarChar(10),
Supervisor_City VarChar(20),
Supervisor_Zip VarChar(5),
CONSTRAINT Supervisor_PK PRIMARY KEY (SupervisorID)
);


alter table supervisor 
add constraint CHK_Supervisor check (Supervisor_city='Boston' and Supervisor_State='MA');

CREATE TABLE Staff
(StaffID INT IDENTITY NOT NULL,
First_Name VarChar(15),
Last_Name VarChar(15),
SupervisorID INT,
CONSTRAINT STAFF_PK PRIMARY KEY (StaffID),
CONSTRAINT STAFF_FK FOREIGN KEY (SupervisorID) REFERENCES Supervisor (SupervisorID)
);


CREATE TABLE Physician
(PhysicianID INT IDENTITY NOT NULL,
First_Name VarChar(15),
Last_Name VarChar(15),
Degree VarChar(2),
SupervisorID INT,
CONSTRAINT PHYSICIAN_PK PRIMARY KEY (PhysicianID),
CONSTRAINT PHYSICIAN_FK FOREIGN KEY (SupervisorID) REFERENCES Supervisor (SupervisorID)
);


CREATE TABLE Coach
(CoachID INT IDENTITY NOT NULL,
First_Name VarChar(15),
Last_Name VarChar(15),
Specialization VarChar(15),
Certification VarChar(10),
SupervisorID INT,
CONSTRAINT COACH_PK PRIMARY KEY (CoachID),
CONSTRAINT COACH_FK FOREIGN KEY (SupervisorID) REFERENCES Supervisor (SupervisorID)
);


alter table coach
add constraint CHK_Coach
check (Certification='Passed');


CREATE TABLE Lesson
(LessonID INT IDENTITY NOT NULL,
Lesson_Name VarChar(30),
Price INT,
SupervisorID INT,
CONSTRAINT LESSON_PK PRIMARY KEY (LessonID),
CONSTRAINT LESSON_FK FOREIGN KEY (SupervisorID) REFERENCES Supervisor (SupervisorID)
);


CREATE TABLE Supplier
(SupplierID INT IDENTITY NOT NULL,
Company_Name VarChar(20),
Contact_No VarChar(15),
CONSTRAINT Supplier_PK PRIMARY KEY (SupplierID)
);


CREATE TABLE Equipment
(EquipmentID INT IDENTITY NOT NULL,
Equipment_Name VarChar(20),
Ship_Date Date,
Order_Date Date,
Warranty_Period INT,
SupplierID INT,
CONSTRAINT EQUIPMENT_PK PRIMARY KEY (EquipmentID),
CONSTRAINT EQUIPMENT_FK FOREIGN KEY (SupplierID) REFERENCES Supplier (SupplierID)
);
--warranty is counted as years.


CREATE TABLE Repairment
(RepairmentID INT IDENTITY NOT NULL,
Date Date,
StaffID INT,
EquipmentID INT,
CONSTRAINT REPAIRMENT_PK PRIMARY KEY (RepairmentID),
CONSTRAINT REPAIRMENT_FK FOREIGN KEY (StaffID) REFERENCES Staff (StaffID),
CONSTRAINT REPAIRMENT_FK2 FOREIGN KEY (EquipmentID) REFERENCES Equipment (EquipmentID)
);


CREATE TABLE Member
(MemberID INT IDENTITY NOT NULL,
First_Name VarChar(15),
Last_Name VarChar(15),
Phone VarChar(10),
Age  INT,
City VarChar(20),
State VarChar(2),
Street VarChar(25),
Zip VarChar(5),
CONSTRAINT Member_PK PRIMARY KEY (MemberID)
);


CREATE TABLE Treatment
(TreatmentID INT IDENTITY NOT NULL,
Treatment_Date Date,
PhysicianID INT,
MemberID INT,
CONSTRAINT TREATMENT_PK PRIMARY KEY (TreatmentID),
CONSTRAINT TREATMENT_FK FOREIGN KEY (PhysicianID) REFERENCES Physician (PhysicianID),
CONSTRAINT TREATMENT_FK2 FOREIGN KEY (MemberID) REFERENCES Member (MemberID)
);


CREATE TABLE Locker
(LockerID INT IDENTITY NOT NULL,
Code VarChar(3),
StaffID INT,
CONSTRAINT LOCKER_PK PRIMARY KEY (LockerID),
CONSTRAINT LOCKER_FK FOREIGN KEY (StaffID) REFERENCES Staff (StaffID),
);


CREATE TABLE LockerAssignment
(LockerAssignmentID INT IDENTITY NOT NULL,
Time_Period VarChar(15),
LockerID INT,
MemberID INT,
CONSTRAINT LOCKERASSIGNMENT_PK PRIMARY KEY (LockerAssignmentID),
CONSTRAINT LOCKERASSIGNMENT_FK FOREIGN KEY (LockerID) REFERENCES Locker (LockerID),
CONSTRAINT LOCKERASSIGNMENT_FK2 FOREIGN KEY (MemberID) REFERENCES Member (MemberID)
);



CREATE TABLE Balance
(BalanceID INT IDENTITY NOT NULL,
Fund INT,
MemberID INT,
CONSTRAINT BALANCE_PK PRIMARY KEY (BalanceID),
CONSTRAINT BALANCE_FK FOREIGN KEY (MemberID) REFERENCES Member (MemberID)
);


CREATE TABLE Room
(RoomID INT IDENTITY NOT NULL,
Location VarChar(20),
Room_Num VarChar(3),
CONSTRAINT ROOM_PK PRIMARY KEY (RoomID)
);


CREATE TABLE LessonRegister
(LessonRegisterID INT IDENTITY NOT NULL,
CoachID INT,
MemberID INT,
LessonID INT,
RoomID INT,
Section VarChar(20)
CONSTRAINT LESSONREGISTER_PK PRIMARY KEY (LessonRegisterID),
CONSTRAINT LESSONREGISTER_FK FOREIGN KEY (CoachID) REFERENCES Coach (CoachID),
CONSTRAINT LESSONREGISTER_FK2 FOREIGN KEY (MemberID) REFERENCES Member (MemberID),
CONSTRAINT LESSONREGISTER_FK3 FOREIGN KEY (LessonID) REFERENCES Lesson (LessonID),
CONSTRAINT LESSONREGISTER_FK4 FOREIGN KEY (RoomID) REFERENCES Room (RoomID)
);


--dbcc checkident('Supervisor',reseed,0)

------supervisor role is only assigned to three people
insert into supervisor values(EncryptByKey(KEY_GUID(N'GYMSymmetrickey'),convert(varbinary,'thisispassword')),'Oliver','Queen','MA','94 Topliff St.','6174567891','Boston','02115');
insert into supervisor values(EncryptByKey(KEY_GUID(N'GYMSymmetrickey'),convert(varbinary,'thisispassword')),'Felipe','Massey','MA','9 Regina Rd.','6178250214','Boston','02124');
insert into supervisor values(EncryptByKey(KEY_GUID(N'GYMSymmetrickey'),convert(varbinary,'thisispassword')),'Brandon','Rivera','MA','80 Blue Hill Ave','6174424627','Boston','02119');

--password encrypted
select * from Supervisor;


insert into staff values('Bradford','Sparks',1)
insert into staff values('Emmett','Cortez',1)
insert into staff values('Wade','Black',1)
insert into staff values('Tommie','Hayes',1)
insert into staff values('Kristopher','Newton',1)
insert into staff values('Aubrey','Ramos',1)
insert into staff values('Leigh','Rhodes',1)
insert into staff values('Josefina','Alvarado',1)
insert into staff values('Ernestine','Ellis',1)
insert into staff values('Olive','Robertson',1)


insert into physician values('Ralph','Moody','BA','2');
insert into physician values('Jamie','Flowers','MS','2');
insert into physician values('Pablo','Wise','BA','2');
insert into physician values('Jean','Soto','BA','2');
insert into physician values('Joe','Foster','MS','2');
insert into physician values('Raymond','Price','BA','2');
insert into physician values('Chris','Hill','MS','2');
insert into physician values('Jeremy','Murphy','BA','2');
insert into physician values('William','Stewart','MS','2');
insert into physician values('Debra','Lee','BA','2');



insert into coach values('Phyllis','Morris','Running','Passed',3);
insert into coach values('Carol','Hughes','Muscle','Passed',3);
insert into coach values('Patrick','Lewis','Yoga','Passed',3);
insert into coach values('Gregory','Martinez','Boxing','Passed',3);
insert into coach values('Diane','Diaz','Swimming','Passed',3);
insert into coach values('Mark','Smith','Muscle','Passed',3);
insert into coach values('Justin','Wood','Yoga','Passed',3);
insert into coach values('Oliver','Queen','Boxing','Passed',1);
insert into coach values('Angela','Adams','Swimming','Passed',3);
insert into coach values('Ronald','Simmons','Yoga','Passed',3);
insert into coach values('Bree','Dowling','Swimming','Passed',2);
insert into coach values('Neave','Aguirre','Muscle','Passed',2);
insert into coach values('Elaina','Whitley','Yoga','Passed',1);
insert into coach values('Nicole','Kaufman','Trampoline','Passed',2);
insert into coach values('Thiago','Workman','Trampoline','Passed',1);
insert into coach values('Rosanna','Kaufman','Trampoline','Passed',2);
insert into coach values('Caitlyn','Sutherland','Fencing','Passed',2);
insert into coach values('Jonny','Beck','Fencing','Passed',1);
insert into coach values('Guy','Shelton','Fencing','Passed',2);
insert into coach values('Juliette','Gould','Fencing','Passed',2);




insert into Member values('Hermione','Granger','3453349087',18,'Boston','MA','Fenway St.','02215');
insert into Member values('Emma','Watson','5649038796',19,'Boston','MA','Fullerton St.','02715');
insert into Member values('Tommy','Black','6739028765',28,'Boston','MA','Miner St.','02219');
insert into Member values('Tony','Stark','902867018',33,'Boston','MA','Burlinton Ave.','02318');
insert into Member values('Jenny','King','9803750187',23,'Boston','MA','Beacon St.','02320');
insert into Member values('Lisa','Chen','3790827659',20,'Boston','MA','Buswell St.','02129');
insert into Member values('Jack','White','7802875910',34,'Boston','MA','Ivy St.','02310');
insert into Member values('Vicky','Green','8730982789',40,'Boston','MA','Euston St.','02330');
insert into Member values('Steve','Rowling','8940398216',17,'Boston','MA','Hawes St.','02311');
insert into Member values('Belle','Stwart','9286018366',20,'Boston','MA','Fenway St.','02215');



insert into Member values('Timi','Park','927609178','44','Malden','MA','Irving St.','02309');
insert into Member values('Oliver','Bree','3453349087','60','Malden','MA','Ferry St.','02310');
insert into Member values('Cindy','Smith','670419803','55','Malden','MA','Fenway St.','02308');
insert into Member values('Helen','Johnson','895607367','50','Cambridge','MA','Dana St.','02411');
insert into Member values('Davis','Miller','784091278','39','Cambridge','MA','Ware St.','02412');
insert into Member values('KK','Jones','860866309','65','Cambridge','MA','Vassar St.','02413');
insert into Member values('Daisy','Brown','490812960','48','Brookline','MA','High St.','02511');
insert into Member values('Godfrey','Garcia','674091296','33','Brookline','MA','Milton Rd.','02513');
insert into Member values('James','Jones','9860884012','17','Brookline','MA','Walnut St.','02514');
insert into Member values('Mary','Williams','9503371286','59','Chelsea','MA','Central Ave.','02612');
insert into Member values('Adam','Wilson','674091208','27','Chelsea','MA','Chester St.','02611');
insert into Member values('Ethan','Smith','870503268','25','Chelsea','MA','Watts St.','02615');

insert into Member values('Dotty','Ball','6175550182',23,'Melrose','MA','2467 Hillcrest Ave.','02176');
insert into Member values('Stefano','Burnett','6175550159',35,'Cambridge','MA','454 Broadway','02138');
insert into Member values('Teddie','Carver','6175550125',28,'Boston','MA','Gerald Rd','02135');
insert into Member values('Anabia','Sanderson','6175550106',29,'Brookline','MA','55 Brington Rd','02445');
insert into Member values('Clarence','Higgins','6175550150',18,'Watertown','MA','1325 Hummingbird Path','02472');
insert into Member values('Melinda','Henson','6175550124',38,'Medford','MA','59 Golden Ave','02155');
insert into Member values('Yuvraj','Milner','6175550170',54,'Chelsea','MA','121 Webster Ave','02150');
insert into Member values('Aiesha','Vinson','6175550117',44,'Boston','MA','21 Dartmouth St','02116');





insert into locker values ('123',1);
insert into locker values ('456',2);
insert into locker values ('789',3);
insert into locker values ('111',4);
insert into locker values ('777',5);
insert into locker values ('816',6);
insert into locker values ('707',7);
insert into locker values ('315',8);
insert into locker values ('978',9);
insert into locker values ('555',10);


insert into lockerassignment values ('14:00-16:00',1,1);
insert into lockerassignment values ('13:00-15:00',2,2);
insert into lockerassignment values ('8:00-11:00',3,3);
insert into lockerassignment values ('12:00-13:00',4,4);
insert into lockerassignment values ('11:00-14:00',5,5);
insert into lockerassignment values ('10:00-12:00',6,6);
insert into lockerassignment values ('9:00-11:00',7,7);
insert into lockerassignment values ('18:00-20:00',8,8);
insert into lockerassignment values ('20:00-23:00',9,9);
insert into lockerassignment values ('15:00-17:00',10,10);


insert into Room values('Richard Hall','101');
insert into Room values('Richard Hall','102');
insert into Room values('Richard Hall','103');
insert into Room values('Marino Center','100');
insert into Room values('Marino Center','301');
insert into Room values('Marino Center','302');
insert into Room values('Marino Center','303');
insert into Room values('Physical Center','109');
insert into Room values('Physical Center','201');
insert into Room values('Physical Center','203');
insert into Room values('Physical Center','206');


insert into Lesson values('Basic_Yoga',200, 1);
insert into Lesson values('AdvancedYoga',200, 1);
insert into Lesson values('Advanced_Yoga',300, 1);
insert into Lesson values('Beginner_Boxing',650, 1);
insert into Lesson values('Intermediate_Boxing',800, 1);
insert into Lesson values('Advanced_Boxing',1000, 1);
insert into Lesson values('Sprint',100, 1);
insert into Lesson values('Marathon',500,1);
insert into Lesson values('Swimming_1vs1',760, 1);
insert into Lesson values('Swimming_Big class',200,1);
insert into Lesson values('Strength_training',460,1);

insert into Lesson values('Trampoline',900,1);
insert into Lesson values('Fencing',1800,1);



insert into  LessonRegister values (1,1,4,1,'1');
insert into  LessonRegister values (1,2,4,1,'1');
insert into  LessonRegister values (1,3,4,1,'1');
insert into  LessonRegister values (1,4,4,1,'1');
insert into  LessonRegister values (1,5,4,1,'1');
insert into  LessonRegister values (1,6,4,1,'1');
insert into  LessonRegister values (1,7,4,1,'1');
insert into  LessonRegister values (1,8,4,1,'1');
insert into  LessonRegister values (1,9,4,1,'1');
insert into  LessonRegister values (1,10,4,1,'1');
insert into  LessonRegister values (2,7,3,4,'5');
insert into  LessonRegister values (3,8,5,6,'7');
insert into  LessonRegister values (19,11,13,3,'7');
insert into  LessonRegister values (19,12,13,3,'7');
insert into  LessonRegister values (19,13,13,3,'1');
insert into  LessonRegister values (15,14,12,3,'1');
insert into  LessonRegister values (15,15,12,3,'1');
insert into  LessonRegister values (14,16,13,3,'2');
insert into  LessonRegister values (15,17,12,3,'1');
insert into  LessonRegister values (15,18,12,3,'1');
insert into  LessonRegister values (15,19,13,3,'2');
insert into  LessonRegister values (15,20,13,3,'2');
insert into  LessonRegister values (19,21,13,3,'7');
insert into  LessonRegister values (19,22,13,3,'7');
insert into  LessonRegister values (19,23,13,3,'1');
insert into  LessonRegister values (15,24,12,3,'1');
insert into  LessonRegister values (15,25,12,3,'1');
insert into  LessonRegister values (14,26,13,3,'2');
insert into  LessonRegister values (15,27,12,3,'1');
insert into  LessonRegister values (15,28,12,3,'1');
insert into  LessonRegister values (15,29,13,3,'2');
insert into  LessonRegister values (15,30,13,3,'2');

insert into Balance values(1000,'3');
insert into Balance values(800,'10');
insert into Balance values(800,'7');
insert into Balance values(850,'2');
insert into Balance values(750,'4');
insert into Balance values(1000,'5');
insert into Balance values(900,'8');
insert into Balance values(200,'6');
insert into Balance values(350,'9');
insert into Balance values(500,'1');



insert into Treatment values('2019-01-01','10','7')
insert into Treatment values('2019-01-15','7','8')
insert into Treatment values('2019-02-22','7','7')
insert into Treatment values('2019-02-24','1','3')
insert into Treatment values('2019-03-03','2','9')
insert into Treatment values('2019-03-09','2','8')
insert into Treatment values('2019-04-16','3','10')
insert into Treatment values('2019-04-20','5','9')
insert into Treatment values('2019-05-21','6','2')
insert into Treatment values('2019-06-07','8','5')


insert into Supplier values('Cybex','8573471717');
insert into Supplier values('StairMaster','8573471716');
insert into Supplier values('Star-Trac','8573471715');
insert into Supplier values('Hammer-Strength','8573471714');
insert into Supplier values('Verdict','8573471713');
insert into Supplier values('Life-Fitness','8573471712');
insert into Supplier values('Precor','8573471711');
insert into Supplier values('Bowflex','8573471710');
insert into Supplier values('KFC','3129736526');
insert into Supplier values('Popeyes','8573471719');


insert into Equipment values('Inner-thigh-adductor','2018-10-18','2018-10-10',2,1);
insert into Equipment values('Outer-thigh-abductor','2018-1-18','2018-1-10',3,2);
insert into Equipment values('Multi-hip machine','2018-2-18','2018-2-10',2,3);
insert into Equipment values('Rotary torso machine','2018-3-18','2018-3-10',3,4);
insert into Equipment values('Seated row machine','2018-4-18','2018-4-10',3,5);
insert into Equipment values('Military press','2018-5-18','2018-5-10',2,6);
insert into Equipment values('Sover machine','2018-6-18','2018-6-10',3,7);
insert into Equipment values('Chest press machine','2018-7-18','2018-7-10',3,8);
insert into Equipment values('Family bucket','2018-8-18','2018-8-10',2,9);
insert into Equipment values('Family bucket Plus','2018-12-18','2018-12-10',1,10);


insert into Repairment values('2019-11-18',1,1);
insert into Repairment values('2019-10-18',2,2);
insert into Repairment values('2019-8-18',3,3);
insert into Repairment values('2019-7-18',4,4);
insert into Repairment values('2019-6-18',5,5);
insert into Repairment values('2019-5-18',6,6);
insert into Repairment values('2019-4-18',7,7);
insert into Repairment values('2019-3-18',8,8);
insert into Repairment values('2019-2-18',9,9);
insert into Repairment values('2019-1-18',10,10);





Update Balance set fund = 2000 where MemberID = 3
Update Balance set fund = 2500 where MemberID = 10
Update Balance set fund = 3000 where MemberID = 7
Update Balance set fund = 2200 where MemberID = 2
Update Balance set fund = 3100 where MemberID = 4
Update Balance set fund = 2600 where MemberID = 5
Update Balance set fund = 3000 where MemberID = 8
Update Balance set fund = 2700 where MemberID = 6
Update Balance set fund = 3200 where MemberID = 9
Update Balance set fund = 2000 where MemberID = 1


insert into Balance values(2200,'20');
insert into Balance values(3000,'11');
insert into Balance values(2400,'19');
insert into Balance values(2100,'12');
insert into Balance values(2300,'22');
insert into Balance values(3500,'23');
insert into Balance values(3200,'24');
insert into Balance values(2700,'13');
insert into Balance values(2400,'15');
insert into Balance values(2900,'17');
insert into Balance values(2800,'14');
insert into Balance values(3100,'18');
insert into Balance values(2000,'30');
insert into Balance values(3000,'29');
insert into Balance values(2500,'28');
insert into Balance values(2300,'26');
insert into Balance values(2600,'27');
insert into Balance values(3300,'16');
insert into Balance values(3000,'21');
insert into Balance values(2300,'25');






--------Views:

--View the Members whose funds are larger than the average fund
create view [MemberFund Above Average Fund] as
select m.MemberID,b.Fund from member m inner join balance b on
m.memberid=b.memberid
where b.Fund>(select avg(fund)from balance)

go

select * from [MemberFund Above Average Fund]


--View the Coach ranks
create view [Coach Rank] as
select rank()over(order by count(coachid)desc)as [rank],count( coachid)as Coach_Num, CoachID
from LessonRegister
group by coachid

go

select * from [coach rank]




------------Table-level CHECK Constraints based on a function

--check if members are injured, they can not register lessons.
create function checkphysicalhealth(@regid int)
  returns int
  as
  begin
      declare @count int =0;
   select @count=count(MemberID) from Treatment
   where MemberID=@regid ;
   return @count;
  end;



  
  alter table LessonRegister with nocheck
  add constraint avoidhurtagain 
  check(dbo.checkphysicalhealth(MemberID)=0);


  --cannot insert memberID 7 since he had a treatment
  --insert into  LessonRegister values (1,7,4,1,'1');



--check function for equipment date 
  Create function EquipDate
(@id int)
returns date
as
begin
return
(select Ship_Date from Equipment
where EquipmentID=@id);
end;

go

alter table Equipment 
add constraint ChkDate
check (getdate()> dbo.EquipDate(EquipmentID));

--shipdate is larger than current date,insert failed
--insert into Equipment values('Family bucket Plus','2019-12-18','2018-12-10',1,10);



alter table Equipment with nocheck
add constraint ChkWarranty
check(getdate()<dateadd(year,Warranty_Period,dbo.EquipDate(EquipmentID)));

--equipment warranty is over due,insert failed
--insert into Equipment values('Family bucket Plus','2017-12-18','2017-12-10',1,10);



alter table Equipment
add constraint ChkOrderDate
check (dbo.EquipDate(EquipmentID)>Order_Date);

--shipdate cannot be perior to orderdate,insert failed
--insert into Equipment values('Family bucket Plus','2017-12-18','2018-12-10',2,10);




--------------Computed Columns based on a function (Add Member Balance)
Create function MemberBalance
(@memberid int)
returns int
as 
begin
declare @fund int;
declare @price int;
declare @balance int;
select @fund=b.Fund,@price=sum(l.Price) from Member m 
inner join LessonRegister lr on m.MemberID=lr.MemberID
inner join Lesson l on l.LessonID=lr.LessonID
inner join Balance b on m.MemberID=b.MemberID
where m.MemberID=@memberid
group by m.MemberID,b.Fund; 
set @balance=@fund-@price;
return @balance;
end;

go

alter table Balance add TotalBalance as 
(dbo.MemberBalance(MemberID));


select * from balance;


