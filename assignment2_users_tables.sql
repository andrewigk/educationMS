-- ORACLE application database and associated users creation script for CST2355 Assignment 2
--
-- Authored by: Andrew Kim
--
-- should be run while connected as 'sys as sysdba'
--
DROP TABLESPACE assignment2 INCLUDING CONTENTS AND DATAFILES;

-- Create STORAGE
CREATE TABLESPACE assignment2
  DATAFILE 'assignment2.dat' SIZE 40M 
  ONLINE; 

-- Create Users
CREATE USER assignmentAppAdmin IDENTIFIED BY password123 ACCOUNT UNLOCK
	DEFAULT TABLESPACE assignment2
	QUOTA 20M ON assignment2;

CREATE USER dummyUser IDENTIFIED BY dummyPassword ACCOUNT UNLOCK
	DEFAULT TABLESPACE assignment2
	QUOTA 5M ON assignment2;

-- Create ROLES
CREATE ROLE assignmentAdmin;
CREATE ROLE assignmentUser;

-- Grant PRIVILEGES
GRANT CONNECT, RESOURCE, CREATE VIEW, CREATE TRIGGER, CREATE PROCEDURE TO assignmentAppAdmin;
GRANT CONNECT, RESOURCE TO assignmentUser;

GRANT assignmentAdmin TO assignmentAppAdmin;
GRANT assignmentUser TO dummyUser;

-- NOW we can connect as the applicationAdmin and create the stored procedures, tables, and triggers

CONNECT assignmentAppAdmin/password123;

-- Creating sequences for use with associative tables and historical tables
CREATE SEQUENCE hrate_seq
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE SEQUENCE emp_hr_seq
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE SEQUENCE steacher_id_seq
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE SEQUENCE student_teacher_seq
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE SEQUENCE t_ov_seq
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE SEQUENCE ov_seq
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

create sequence emp_id_seq
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

create sequence student_id_seq
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

create sequence teacher_id_seq
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

--Table creation script

CREATE TABLE Locations (
	LocationID NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,
    StreetAddress VARCHAR(50) NOT NULL,
    PostalCode NCHAR(6) NULL,
    PhoneNumber NCHAR(10) NULL
);

CREATE TABLE AdminRoles (
	RoleID NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,
	Name VARCHAR(50)
	);

CREATE TABLE Genres (
	GenreID NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,
	Name VARCHAR(20) NOT NULL
	);

CREATE TABLE Employees (
	EmployeeID NUMBER DEFAULT emp_id_seq.NEXTVAL PRIMARY KEY,
	LocationID NUMBER NOT NULL,
	FirstName VARCHAR(50) NOT NULL,
	LastName VARCHAR(50) NOT NULL,
	CONSTRAINT fk_emp_loc_id FOREIGN KEY (LocationID) REFERENCES Locations (LocationID)
	);

-- Create historical field of hourly rate 
CREATE TABLE HRates (
	HRateID NUMBER DEFAULT hrate_seq.NEXTVAL PRIMARY KEY,
	HourlyRate NUMBER NOT NULL
	);

--Create associative table between employees and their hourly rate
CREATE TABLE Employee_HourlyRate (
    IDEmployee_HourlyRate NUMBER DEFAULT emp_hr_seq.NEXTVAL PRIMARY KEY,
	EmployeeID NUMBER NOT NULL,
	HRateID NUMBER NOT NULL,
	StartTime TIMESTAMP,
	EndTime TIMESTAMP DEFAULT NULL,
	CONSTRAINT fk_ehr_emp_id FOREIGN KEY (EmployeeID) REFERENCES Employees (EmployeeID),
	CONSTRAINT fk_ehr_hr_id FOREIGN KEY (HRateID) REFERENCES HRates (HRateID)
	);

CREATE TABLE Teachers (
	TeacherID NUMBER DEFAULT teacher_id_seq.NEXTVAL PRIMARY KEY,
	EmployeeID NUMBER NOT NULL,
	GenreID NUMBER NOT NULL,
	CONSTRAINT fk_t_emp_id FOREIGN KEY (EmployeeID) REFERENCES Employees (EmployeeID),
	CONSTRAINT fk_t_genre_id FOREIGN KEY (GenreID) REFERENCES Genres (GenreID)
	);

--Create historical field table for OffersVirtual
CREATE TABLE OffVirtuals (
	OffVirtualID NUMBER DEFAULT ov_seq.NEXTVAL PRIMARY KEY,
	OffersVirtual INT NOT NULL
	);

--Create associative table for Teachers and OffVirtuals
CREATE TABLE Teachers_Virtual (
    IDTeachers_Virtual NUMBER DEFAULT t_ov_seq.NEXTVAL PRIMARY KEY,
	TeacherID NUMBER NOT NULL,
	OffVirtualID NUMBER NOT NULL,
	StartTime TIMESTAMP,
	EndTime TIMESTAMP DEFAULT NULL,
	CONSTRAINT fk_tv_t_id FOREIGN KEY (TeacherID) REFERENCES Teachers (TeacherID),
	CONSTRAINT fk_tv_ov_id FOREIGN KEY (OffVirtualID) REFERENCES OffVirtuals (OffVirtualID)
	);


CREATE TABLE Administrators (
	AdminID NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,
	EmployeeID NUMBER NOT NULL,
	RoleID NUMBER NOT NULL,
	CONSTRAINT fk_adminrole_id FOREIGN KEY (RoleID) REFERENCES AdminRoles (RoleID),
	CONSTRAINT fk_admin_emp_id FOREIGN KEY (EmployeeID) REFERENCES Employees (EmployeeID)
	);

CREATE TABLE Students (
	StudentID NUMBER DEFAULT student_id_seq.NEXTVAL PRIMARY KEY,
	FirstName VARCHAR(50) NOT NULL,
	LastName VARCHAR(50) NOT NULL,
	StartDate DATE NOT NULL,
	LocationID NUMBER NOT NULL,
	CONSTRAINT fk_students_loc_id FOREIGN KEY (LocationID) REFERENCES Locations (LocationID)
	);
-- Create table for historical field TeacherID
CREATE TABLE STeachers (
	STeacherID NUMBER DEFAULT steacher_id_seq.NEXTVAL PRIMARY KEY,
	TeacherID NUMBER NOT NULL,
	CONSTRAINT fk_teacherid FOREIGN KEY (TeacherID) REFERENCES Teachers (TeacherID)
	);
--Create associative table between Student and STeachers
CREATE TABLE Student_TeacherID (
    IDStudent_TeacherID NUMBER DEFAULT student_teacher_seq.NEXTVAL PRIMARY KEY,
	StudentID NUMBER NOT NULL,
	STeacherID NUMBER NOT NULL,
	StartTime TIMESTAMP,
	EndTime TIMESTAMP DEFAULT NULL,
	CONSTRAINT fk_s_t_id FOREIGN KEY (StudentID) REFERENCES Students (StudentID),
	CONSTRAINT fk_s_st_id FOREIGN KEY (STeacherID) REFERENCES STeachers (STeacherID)
	);
    
COMMIT;
