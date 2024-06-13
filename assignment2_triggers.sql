-- SQL script to create INSERT/UPDATE/DELETE triggers for Views
-- Authored by: Andrew Kim
-- Should be run while connected as assignmentAppAdmin


CREATE OR REPLACE TRIGGER stuview_trigger
INSTEAD OF INSERT OR UPDATE ON Student_View
FOR EACH ROW
BEGIN

        IF INSERTING THEN
        INSERT INTO Students(StudentID, firstname, lastname, StartDate, LocationID) VALUES (student_id_seq.NEXTVAL, :NEW.firstname, :NEW.lastname, :New.startdate, :NEW.LocationID);
        
        INSERT INTO STeachers (STeacherID, TeacherID)
        VALUES (steacher_id_seq.NEXTVAL, :NEW.TeacherID);
        
        INSERT INTO Student_TeacherID (IDStudent_TeacherID, StudentID, STeacherID, starttime, endtime)
        VALUES (student_teacher_seq.NEXTVAL, student_id_seq.CURRVAL, steacher_id_seq.CURRVAL, SYSDATE, NULL);
        
      
        END IF;
    
    IF UPDATING THEN
                
        UPDATE Students
        SET firstname = :new.firstname,
            lastname = :new.lastname,
            locationID = :new.locationID
        WHERE Students.studentID = :OLD.StudentID;

        -- Insert a new record into the STeachers table
        IF :OLD.TeacherID <> :NEW.TeacherID THEN
        INSERT INTO STeachers (STeacherID, TeacherID)
        VALUES (steacher_id_seq.NEXTVAL, :NEW.TeacherID);
        
        UPDATE Student_TeacherID
        SET endtime = SYSDATE
        WHERE Student_TeacherID.studentID = :OLD.StudentID
        AND endtime IS NULL;
        
        -- Insert a new record into the Student_TeacherID table
        INSERT INTO Student_TeacherID (IDStudent_TeacherID, StudentID, STeacherID, starttime, endtime)
        VALUES (student_teacher_seq.NEXTVAL, :OLD.StudentID, steacher_id_seq.CURRVAL, SYSDATE, NULL);
        
        END IF;

    END IF;
    
        IF DELETING THEN            
            UPDATE Student_TeacherID
            SET EndTime = SYSDATE 
            WHERE (Student_TeacherID.EndTime IS NULL);
        END IF;
END;
/

CREATE OR REPLACE TRIGGER empview_trigger
INSTEAD OF INSERT OR UPDATE ON Employee_View
FOR EACH ROW
BEGIN

        IF INSERTING THEN
        INSERT INTO Employees(employeeID, locationID, firstname, lastname) VALUES (emp_id_seq.NEXTVAL, :NEW.locationID, :NEW.firstname, :NEW.lastname);
        
        -- Insert a new record into the HRates table
        INSERT INTO HRates (HRateID, HourlyRate)
        VALUES (hrate_seq.NEXTVAL, :NEW.HourlyRate);
    
        -- Insert a new record into the Employee_HourlyRate table
        INSERT INTO Employee_HourlyRate (IDEmployee_HourlyRate, EmployeeID, HRateID, starttime, endtime)
        VALUES (emp_hr_seq.NEXTVAL, emp_id_seq.CURRVAL, hrate_seq.CURRVAL, SYSDATE, NULL);
    

        END IF;
        
        IF UPDATING THEN
        
        UPDATE Employees
        SET firstname = :new.firstname,
            lastname = :new.lastname,
            locationID = :new.locationID
        WHERE Employees.EmployeeID = :OLD.EmployeeID;
        
        IF :OLD.HourlyRate <> :NEW.HourlyRate THEN
        -- Insert a new record into the HRates table
        INSERT INTO HRates (HRateID, HourlyRate)
        VALUES (hrate_seq.NEXTVAL, :NEW.HourlyRate);
        
        UPDATE Employee_HourlyRate
        SET endtime = SYSDATE
        WHERE Employee_HourlyRate.EmployeeID = :OLD.EmployeeID
        AND endtime IS NULL;
        
      
        -- Insert a new record into the Employee_HourlyRate table
        INSERT INTO Employee_HourlyRate (IDEmployee_HourlyRate, EmployeeID, HRateID, starttime, endtime)
        VALUES (emp_hr_seq.NEXTVAL, :OLD.EmployeeID, hrate_seq.CURRVAL, SYSDATE, NULL);
        END IF;
    END IF;    
        IF DELETING THEN
            UPDATE Employee_HourlyRate
            SET EndTime = SYSDATE 
            WHERE (Employee_HourlyRate.EndTime IS NULL);
        END IF;
END;
/

CREATE OR REPLACE TRIGGER teacherview_trigger
INSTEAD OF INSERT OR UPDATE ON Teacher_View
FOR EACH ROW
BEGIN

        IF INSERTING THEN
        INSERT INTO Teachers(TeacherID, EmployeeID, GenreID) VALUES (teacher_id_seq.NEXTVAL, :NEW.EmployeeID, :NEW.GenreID);
        
         -- Insert a new record into the OffVirtuals table
        INSERT INTO OffVirtuals (OffVirtualID, OffersVirtual)
        VALUES (ov_seq.NEXTVAL, :NEW.OffersVirtual);
        
        -- Insert a new record into the Teachers_Virtual table
        INSERT INTO Teachers_Virtual (IDTeachers_Virtual, TeacherID, OffVirtualID, starttime, endtime)
        VALUES (t_ov_seq.NEXTVAL, teacher_id_seq.CURRVAL, ov_seq.CURRVAL, SYSDATE, NULL);
    
        END IF;
        
        IF UPDATING THEN
        
        UPDATE Teachers
        SET EmployeeID = :NEW.EmployeeID,
            GenreID = :NEW.GenreID
        WHERE Teachers.TeacherID = :OLD.TeacherID;
        
        IF :OLD.OffersVirtual <> :NEW.OffersVirtual THEN
        -- Insert a new record into the OffVirtuals table
        INSERT INTO OffVirtuals (OffVirtualID, OffersVirtual)
        VALUES (ov_seq.NEXTVAL, :NEW.OffersVirtual);
        
        UPDATE Teachers_Virtual
        SET endtime = SYSDATE
        WHERE Teachers_Virtual.TeacherID = :OLD.TeacherID
        AND endtime IS NULL;  
        -- Insert a new record into the Teachers_Virtual table
        INSERT INTO Teachers_Virtual (IDTeachers_Virtual, TeacherID, OffVirtualID, starttime, endtime)
        VALUES (t_ov_seq.NEXTVAL, :OLD.TeacherID, ov_seq.CURRVAL, SYSDATE, NULL);
        END IF;
    
    END IF;
        
        IF DELETING THEN            
            UPDATE Teachers_Virtual
            SET EndTime = SYSDATE 
            WHERE (Teachers_Virtual.EndTime IS NULL);
        END IF;
END;
/

SELECT TeacherID, LocationID, FirstName, LastName, dbo_GENRES.Name, HourlyRate
FROM Teacher_View LEFT JOIN Genres ON Teacher_View.GenreID = Genres.GenreID;

