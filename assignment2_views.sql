--Create views for Students, Employees, Teachers
--Authored by: Andrew Kim
--Should be run while connected as assignmentAppAdmin

CREATE OR REPLACE VIEW Student_View AS
SELECT Students.StudentID, FirstName, LastName, StartDate, LocationID, STeachers.TeacherID
FROM Students
	LEFT JOIN Student_TeacherID
		ON Students.StudentID = Student_TeacherID.StudentID
	LEFT JOIN  STeachers
		ON Student_TeacherID.STeacherID = STeachers.STeacherID
WHERE
	(Student_TeacherID.ENDTIME is NULL);

CREATE OR REPLACE VIEW Employee_View AS
SELECT Employees.EmployeeID, LocationID, FirstName, LastName, HRates.HourlyRate
FROM Employees
	LEFT JOIN Employee_HourlyRate
		ON Employee_HourlyRate.EmployeeID = Employees.EmployeeID
	LEFT JOIN HRates
		ON HRates.HRateID = Employee_HourlyRate.HRateID
WHERE
	(Employee_HourlyRate.ENDTIME is NULL);

CREATE OR REPLACE VIEW Teacher_View AS 
SELECT Teachers.TeacherID, EmployeeID, GenreID, OffVirtuals.OffersVirtual
FROM Teachers
	LEFT JOIN Teachers_Virtual
        ON Teachers_Virtual.TeacherID = Teachers.TeacherID
    LEFT JOIN OffVirtuals
        ON OffVirtuals.OffVirtualID = Teachers_Virtual.OffVirtualID
WHERE
	(Teachers_Virtual.ENDTIME is NULL);
    

COMMIT;
