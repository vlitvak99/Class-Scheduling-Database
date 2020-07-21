connect to mydatabase^
CREATE TABLE UNIVERSITY.STUDENT(
	Id varchar(5) NOT NULL UNIQUE,
	First varchar(10),
	Last varchar(10)
)^
CREATE TABLE UNIVERSITY.CLASS(
	ClassId varchar(5) NOT NULL UNIQUE,
	Name varchar(10),
	Description varchar(20)
)^
CREATE TABLE UNIVERSITY.CLASSREQ(
	ClassId varchar(5) NOT NULL,
	CONSTRAINT FK_ClassId FOREIGN KEY (ClassId) REFERENCES UNIVERSITY.CLASS (ClassId) ON DELETE CASCADE,
	PrereqId varchar(5) NOT NULL,
	CONSTRAINT FK_PrereqId FOREIGN KEY (PrereqId) REFERENCES UNIVERSITY.CLASS (ClassId) ON DELETE CASCADE,
	Coreq char(1),
	CHECK (Coreq = 'T' OR Coreq = 'F')
)^
CREATE TABLE UNIVERSITY.SCHEDULE(
	StudentId varchar(5) NOT NULL,
	CONSTRAINT FK_StudentId FOREIGN KEY (StudentID) REFERENCES UNIVERSITY.STUDENT (Id) ON DELETE CASCADE,
	ClassId varchar(5) NOT NULL,
	CONSTRAINT FK_ClassId FOREIGN KEY (ClassId) REFERENCES UNIVERSITY.CLASS (ClassId) ON DELETE CASCADE,
	Semester char(1),
	Year int,
	CHECK (Semester = 'S' OR Semester = 'M' OR Semester = 'F')
)^
CREATE TRIGGER UNIVERSITY.PREREQ_CHECK
AFTER INSERT ON UNIVERSITY.SCHEDULE
REFERENCING NEW AS N
FOR EACH ROW MODE DB2SQL
WHEN ((SELECT COUNT(*) FROM UNIVERSITY.CLASSREQ WHERE ClassId = N.ClassId) > 0)
BEGIN ATOMIC
	IF (SELECT COUNT(*) FROM UNIVERSITY.CLASSREQ WHERE ClassId = N.ClassId AND Coreq = 'F' > 0)
	THEN
		IF ((SELECT COUNT(*) FROM UNIVERSITY.SCHEDULE WHERE ClassId = (SELECT MAX(PrereqId) FROM UNIVERSITY.CLASSREQ WHERE ClassId = N.ClassId AND Coreq = 'F') AND StudentId = N.StudentId) = 0)
		THEN
			DELETE FROM UNIVERSITY.SCHEDULE WHERE StudentId = N.StudentID AND ClassId = N.ClassId AND Semester = N.Semester AND Year = N.Year;
			SIGNAL SQLSTATE '88888' ('Missing Prereq');
		ELSE
			IF ((SELECT MAX(Year) FROM UNIVERSITY.SCHEDULE WHERE ClassID = (SELECT MAX(PrereqId) FROM UNIVERSITY.CLASSREQ WHERE ClassId = N.ClassId AND Coreq = 'F') AND StudentId = N.StudentId) = N.Year)
			THEN
				IF (N.Semester = 'S')
				THEN
					DELETE FROM UNIVERSITY.SCHEDULE WHERE StudentId = N.StudentID AND ClassId = N.ClassId AND Semester = N.Semester AND Year = N.Year;
					SIGNAL SQLSTATE '88888' ('Missing Prereq');
				ELSEIF (N.Semester = 'M')
				THEN
					IF ((SELECT MAX(Semester) FROM UNIVERSITY.SCHEDULE WHERE ClassID = (SELECT MAX(PrereqId) FROM UNIVERSITY.CLASSREQ WHERE ClassId = N.ClassId AND Coreq = 'F') AND StudentId = N.StudentId) = 'M')
					THEN
						DELETE FROM UNIVERSITY.SCHEDULE WHERE StudentId = N.StudentID AND ClassId = N.ClassId AND Semester = N.Semester AND Year = N.Year;
						SIGNAL SQLSTATE '88888' ('Missing Prereq');
					ELSEIF ((SELECT MAX(Semester) FROM UNIVERSITY.SCHEDULE WHERE ClassID = (SELECT MAX(PrereqId) FROM UNIVERSITY.CLASSREQ WHERE ClassId = N.ClassId AND Coreq = 'F') AND StudentId = N.StudentId) = 'F')
					THEN
						DELETE FROM UNIVERSITY.SCHEDULE WHERE StudentId = N.StudentID AND ClassId = N.ClassId AND Semester = N.Semester AND Year = N.Year;
						SIGNAL SQLSTATE '88888' ('Missing Prereq');
					END IF;
				ELSEIF (N.Semester = 'F')
				THEN
					IF ((SELECT MAX(Semester) FROM UNIVERSITY.SCHEDULE WHERE ClassID = (SELECT MAX(PrereqId) FROM UNIVERSITY.CLASSREQ WHERE ClassId = N.ClassId AND Coreq = 'F') AND StudentId = N.StudentId) = 'F')
					THEN
						DELETE FROM UNIVERSITY.SCHEDULE WHERE StudentId = N.StudentID AND ClassId = N.ClassId AND Semester = N.Semester AND Year = N.Year;
						SIGNAL SQLSTATE '88888' ('Missing Prereq');
					END IF;
				END IF;

			ELSEIF ((SELECT MAX(Year) FROM UNIVERSITY.SCHEDULE WHERE ClassID = (SELECT MAX(PrereqId) FROM UNIVERSITY.CLASSREQ WHERE ClassId = N.ClassId AND Coreq = 'F') AND StudentId = N.StudentId) > N.Year)
			THEN
				DELETE FROM UNIVERSITY.SCHEDULE WHERE StudentId = N.StudentID AND ClassId = N.ClassId AND Semester = N.Semester AND Year = N.Year;
				SIGNAL SQLSTATE '88888' ('Missing Prereq');
			END IF;
		END IF;
	END IF;
	IF (SELECT COUNT(*) FROM UNIVERSITY.CLASSREQ WHERE ClassId = N.ClassId AND Coreq = 'T' > 0)
	THEN
		IF ((SELECT COUNT(*) FROM UNIVERSITY.SCHEDULE WHERE ClassId = (SELECT MAX(PrereqId) FROM UNIVERSITY.CLASSREQ WHERE ClassId = N.ClassId AND Coreq = 'T') AND StudentId = N.StudentId) = 0)
		THEN
			DELETE FROM UNIVERSITY.SCHEDULE WHERE StudentId = N.StudentID AND ClassId = N.ClassId AND Semester = N.Semester AND Year = N.Year;
			SIGNAL SQLSTATE '88888' ('Missing Coreq');
		ELSE
			IF ((SELECT MAX(Year) FROM UNIVERSITY.SCHEDULE WHERE ClassID = (SELECT MAX(PrereqId) FROM UNIVERSITY.CLASSREQ WHERE ClassId = N.ClassId AND Coreq = 'T') AND StudentId = N.StudentId) = N.Year)
			THEN
				IF (N.Semester = 'S')
				THEN
					IF ((SELECT MAX(Semester) FROM UNIVERSITY.SCHEDULE WHERE ClassID = (SELECT MAX(PrereqId) FROM UNIVERSITY.CLASSREQ WHERE ClassId = N.ClassId AND Coreq = 'T') AND StudentId = N.StudentId) = 'M')
					THEN
						DELETE FROM UNIVERSITY.SCHEDULE WHERE StudentId = N.StudentID AND ClassId = N.ClassId AND Semester = N.Semester AND Year = N.Year;
						SIGNAL SQLSTATE '88888' ('Missing Coreq');
					ELSEIF ((SELECT MAX(Semester) FROM UNIVERSITY.SCHEDULE WHERE ClassID = (SELECT MAX(PrereqId) FROM UNIVERSITY.CLASSREQ WHERE ClassId = N.ClassId AND Coreq = 'T') AND StudentId = N.StudentId) = 'F')
					THEN
						DELETE FROM UNIVERSITY.SCHEDULE WHERE StudentId = N.StudentID AND ClassId = N.ClassId AND Semester = N.Semester AND Year = N.Year;
						SIGNAL SQLSTATE '88888' ('Missing Coreq');
					END IF;
				ELSEIF (N.Semester = 'M')
				THEN
					IF ((SELECT MAX(Semester) FROM UNIVERSITY.SCHEDULE WHERE ClassID = (SELECT MAX(PrereqId) FROM UNIVERSITY.CLASSREQ WHERE ClassId = N.ClassId AND Coreq = 'T') AND StudentId = N.StudentId) = 'F')
					THEN
						DELETE FROM UNIVERSITY.SCHEDULE WHERE StudentId = N.StudentID AND ClassId = N.ClassId AND Semester = N.Semester AND Year = N.Year;
						SIGNAL SQLSTATE '88888' ('Missing Coreq');
					END IF;
				END IF;

			ELSEIF ((SELECT MAX(Year) FROM UNIVERSITY.SCHEDULE WHERE ClassID = (SELECT MAX(PrereqId) FROM UNIVERSITY.CLASSREQ WHERE ClassId = N.ClassId AND Coreq = 'T') AND StudentId = N.StudentId) > N.Year)
			THEN
				DELETE FROM UNIVERSITY.SCHEDULE WHERE StudentId = N.StudentID AND ClassId = N.ClassId AND Semester = N.Semester AND Year = N.Year;
				SIGNAL SQLSTATE '88888' ('Missing Coreq');
			END IF;
		END IF;
	END IF;
END^
terminate^