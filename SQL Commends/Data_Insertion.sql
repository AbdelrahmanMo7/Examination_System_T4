--  DB  data insertion
use T4_Examination_System

---- 
INSERT INTO Traning_Manager (TR_name, TR_username)
VALUES 
    ('Islam', 'T_M_1'),
    ('Gomaa', 'T_M_1'),
    ('Abdelrahman', 'T_M_1'),
    ('mohamed', 'T_M_1'),
    ('sayed', 'T_M_1');

	--declare @x  int 
	--set @x=1
	--while (@x<= (select count(*) from Traning_Manager))
	--begin
	--	update Traning_Manager 
	--set  TR_username ='T_M_'+cast(@x as nvarchar(10))
	--where [TR_ID]= @x
	--set @x += 1
	--end

	select * from Traning_Manager
	------
	INSERT INTO Training_Manager.Department (DEP_name, TR_id)
VALUES 
    ('Engnering', 1),
    ('Softwear', 2),
    ('Hardwear', 3),
    ('Automation', 4),
    ('markting', 5);
	----
	INSERT INTO Training_Manager.Track (TCK_name, TR_id, DEP_id)
VALUES 
    ('Front-End', 1, 2),
    ('Back-End', 2, 2),
    ('SQL Server', 3, 2),
    ('PHP', 4, 2),
    ('MONGO-DB', 1, 2),
	('Machen learning', 2, 3),
	('Micatronix', 3, 3),
	('GIS', 4, 1),
	('embdet sys', 5, 4),
	('Digital markting', 5, 5);
	----
	
INSERT INTO Training_Manager.Branch (BR_name, TR_id)
VALUES 
    ('BeniSufe', 1),
    ('SMART', 2),
    ('EL-Mansora', 3),
    ('ALEX', 4),
    ('MONOFIA', 4);

	---------
	INSERT INTO Training_Manager.Intake (INT_name, TR_id)
VALUES 
    ('Intake1', 1),
    ('Intake2', 2),
    ('Intake3', 3),
    ('Intake4', 4),
    ('Intake5', 5);

	------
	INSERT INTO Training_Manager.Student 
VALUES 
    ('John Doe', 25, '123 Main St', 'PersonalInfo1', 'Student_1', 1, 1, 1, 1),
    ('Jane Smith', 29, '456 Oak St', 'PersonalInfo2', 'Student_2', 2, 2, 2, 2),
    ('Alex Johnson', 28, '789 Pine St', 'PersonalInfo3', 'Student_3', 3, 3, 3, 3),
    ('Eva White', 22, '101 Elm St', 'PersonalInfo4', 'Student_4', 4, 4, 4, 4),
    ('Michael Brown', 29, '202 Maple St', 'PersonalInfo5', 'Student_5', 5, 5, 5, 5),
    ('Olivia Taylor', 29, '303 Birch St', 'PersonalInfo6', 'Student_6', 1, 1, 1, 1),
    ('Sophia Harris', 27, '404 Cedar St', 'PersonalInfo200', 'Student_7', 4, 4, 4, 4),
    ('John Additional', 26, '789 Oak St', 'AdditionalInfo1', 'Student_8', 2, 3, 4, 1),
    ('Emma Johnson', 23, '456 Pine St', 'AdditionalInfo2', 'Student_9', 1, 2, 3, 4),
    ('William Black', 29, '101 Elm St', 'AdditionalInfo3', 'Student_10', 3, 4, 1, 2),
    ('Sophie Miller', 28, '555 Cedar St', 'AdditionalInfo4', 'Student_11', 2, 1, 4, 3),
    ('Daniel White', 29, '777 Birch St', 'AdditionalInfo5', 'Student_12', 4, 2, 1, 3),
    ('Oliver Davis', 24, '888 Pine St', 'AdditionalInfo6', 'Student_13', 5, 3, 2, 4),
    ('Ava Martin', 29, '999 Oak St', 'AdditionalInfo7', 'Student_14', 1, 4, 3, 2),
    ('Logan Wilson', 26, '111 Maple St', 'AdditionalInfo8', 'Student_15', 3, 1, 2, 4),
    ('Chloe Baker', 29, '222 Elm St', 'AdditionalInfo9', 'Student_16', 2, 3, 4, 1);

	--declare @i  int 
	--set @i=1
	--while (@i<= (select count(*) from Training_Manager.Student))
	--begin
	--	update Training_Manager.Student 
	--set  [ST_UserName]='Student_'+cast(@i as nvarchar(10))
	--where [ST_ID]= @i
	--set @i += 1
	--end

	select *from Training_Manager.Student 
-------
----Instructor table

INSERT INTO Instructor VALUES 
('Abdelrahamn' , 25 , 'Cairo' , 'marital status: Single' , 'Ins1'),
('Ahmed' , 28 , 'Alexandria' , 'marital status: Single', 'Ins2'),
('Mona' , 29 , 'Luxor' , 'marital status: Married' , 'Ins3'),
('Islam' , 31 , 'South Sinai' , 'marital status: Married' , 'Ins4'),
('Nader' , 25 , 'Dakahlia' , 'marital status: Single' , 'Ins5'),
('Fatma' , 27 , 'Port Said' , 'marital status: Single' , 'Ins6'),
('Rana' , 30 , 'Qena' , 'marital status: Married' , 'Ins7');

select * from Instructor

-- Inserting data into the Course table
INSERT INTO Course VALUES 
    ('Computer Science', 'Fundamental concepts of computer science.', 70.0, 100.0, 4),
    ('English Literature', 'Exploration of classic and modern literature.', 60.0, 95.0, 5),
    ('Mathematics', 'Advanced mathematical principles for engineering.', 75.0, 98.0, 2),
    ('Civilizations', 'Study of ancient cultures and civilizations.', 65.0, 90.0, 7),
    ('Financial', 'Principles and practices of financial accounting.', 80.0, 100.0, 2),
    ('Psychology', 'Basic concepts in psychology and human behavior.', 70.0, 95.0, 4),
    ('Data Structures', 'Implementation of data structures and algorithms.', 85.0, 100.0, 5),
    ('Art History', 'Exploration of artistic movements throughout history.', 60.0, 88.0, 4),
    ('Marketing ', 'Foundations of marketing strategies and concepts.', 75.0, 98.0, 7),
    ('Environmental', 'Study of environmental issues and conservation.', 68.0, 92.0,Null);
select * from Course

-- Data insertion to Question Table   ...................
INSERT INTO Question VALUES
    ('Multi', 'What is the capital of France?','A' , 'A-C', 'B-Paris', 'C-Berlin', 'D-London', 7),
    ('T/F', 'The sun rises in the west.' , 'F',NULL , Null, NULL, NULL, 7),
    ('Multi', 'Which of the following is a mammal?', 'C', 'A-Fish', 'B-Dog', 'C-Bird', 'D-Snake', 8),
    ('T/F', 'Water boils at 100 degrees Celsius.', 'T',NULL , Null, NULL, NULL, 9),
    ('Multi', 'What is the largest planet in our solar system?' ,'D' , 'A-Jupiter', 'B-Mars', 'C-Earth', 'D-Saturn', 10),
    ('Multi', 'Which programming language is commonly used for web development?', 'B', 'A-Java', 'B-Python', 'C-HTML', 'D-C++', 14),
    ('T/F', 'Mount Everest is the tallest mountain in the world.', 'T',NULL , Null, NULL, NULL, 11),
    ('Multi', 'What is the chemical symbol for gold?','A','A-Au', 'B-Ag', 'C-Fe', 'D-Cu', 12),
    ('Multi', 'Which of the following is a primary color?','C', 'A-Green', 'B-Orange', 'C-Red', 'D-Purple', 13),
    ('T/F', 'The Great Wall of China is visible from space.','F',NULL , Null, NULL, NULL, 14),
    ('Multi', 'What is the capital of Brazil?', 'C', 'A-Buenos' , 'B-Lima', 'C-Bras�lia', 'D-Santiago', 7),
    ('T/F', 'The Great Wall of China is visible from the moon.', 'F',NULL , Null, NULL, NULL, 9),
    ('Multi', 'Which programming language is used for building Android apps?', 'D','A-Java', 'B-Swift', 'C-C#', 'D-Python', 7),
    ('Multi', 'What is the largest continent on Earth?' , 'C', 'A-Europe', 'B-Asia','C-North America', 'D-Africa', 8),
    ('T/F', 'The Pyramids of Giza were built in the 3rd century BC.', 'F',NULL , Null, NULL, NULL, 9),
    ('Multi', 'Which gas makes up the majority of Earth\s atmosphere?', 'B', 'A-Oxygen', 'B-Carbon Dioxide', 'C-Nitrogen', 'D-Argon', 10),
    ('Multi', 'Who wrote the play "Romeo and Juliet"?','A' , 'A-Charles Dickens','B-Jane Austen', 'C-William Shakespeare', 'D-Mark Twain', 11),
    ('T/F', 'The currency used in Japan is the Yuan.', 'T',NULL , Null, NULL, NULL, 12),
    ('Multi', 'What is the boiling point of water at sea level?', 'D', 'A-100�C', 'B-75�C', 'C-50�C', 'D-25�C', 13),
    ('Multi', 'Which of the following is a prime number?', 'C', 'A-15', 'B-22', 'C-7', 'D-12', 14),
    ('T/F', 'The Amazon River is the longest river in the world.', 'T',NULL , Null, NULL, NULL, 15),
    ('Multi', 'Who painted the famous artwork "Starry Night"?', 'D', 'A-Pablo Picasso', 'B-Vincent van Gogh', 'C-Leonardo da Vinci', 'D-Claude Monet', 7),
    ('Multi', 'What is the capital of South Africa?', 'A', 'A-Nairobi', 'B-Cairo', 'C-Johannesburg', 'D-Cape Town', 8),
    ('T/F', 'Spiders are insects.', 'F',NULL , Null, NULL, NULL, 9),
    ('Multi', 'Which planet is known as the "Blue Planet"?' , 'C','A-Earth', 'B-Mars', 'C-Neptune', 'D-Uranus', 10),
    ('Multi', 'What is the main component of natural gas?' , 'B','A-Methane', 'B-Oxygen', 'C-Nitrogen', 'D-Carbon Dioxide', 11),
    ('T/F', 'The Statue of Liberty is located in New York City.', 'T',NULL , Null, NULL, NULL, 12),
    ('Multi', 'Who discovered penicillin?', 'D', 'A-Marie Curie', 'B-Alexander Fleming', 'C-Louis Pasteur', 'D-Antoine Lavoisier', 13),
    ('Multi', 'Which continent is home to the Sahara Desert?', 'B', 'A-Asia', 'B-North America', 'C-Africa', 'D-Europe', 14),
    ('T/F', 'Bananas are berries.', 'T',NULL , Null, NULL, NULL, 8),
    ('Multi', 'What is the chemical symbol for gold?', 'A', 'A-Au', 'B-Ag', 'C-Fe', 'D-Cu', 7),
    ('Multi', 'Which ocean is the largest on Earth?' ,'B', 'A-Atlantic Ocean', 'B-Indian Ocean', 'C-Southern Ocean', 'D-Pacific Ocean', 8),
    ('T/F', 'The currency used in Switzerland is the Euro.', 'F',NULL , Null, NULL, NULL, 9),
    ('Multi', 'Who wrote "To Kill a Mockingbird"?', 'A','A-J.K. Rowling', 'B-George Orwell', 'C-Harper Lee', 'D-Ernest Hemingway', 10),
    ('Multi', 'What is the largest island in the world?', 'B','A-Borneo', 'B-Greenland', 'C-Madagascar', 'D-Java', 11),
    ('T/F', 'Cheetahs are the fastest land animals.', 'T',NULL , Null, NULL, NULL, 12),
    ('Multi', 'Which element has the atomic number 79?', 'D', 'A-Gold', 'B-Silver', 'C-Copper', 'D-Platinum', 13),
    ('Multi', 'What is the largest mountain range in the world?', 'C', 'A-Andes', 'B-Himalayas', 'C-Rocky Mountains', 'D-Alps', 14),
    ('T/F', 'The Great Barrier Reef is located in the Pacific Ocean.', 'F',NULL , Null, NULL, NULL, 7);
	select * from Question

-- Data Insertion to Exam Table   ................
insert into Instructor.Exam ( EX_Type ,EX_Start_Time,EX_End_Time ,EX_Year ,EX_Multi_Q_Num,EX_Multi_Q_Degree ,EX_T_F_Q_Num,EX_T_F_Q_Degree ,EX_Allowance_Options ,Cour_Id,Inst_Id,Tck_Id,Br_Id,Intake_Id)
values
('Exam' , '10:50:00' , '11:50:00' ,default,2,2,2,1,0,7,6,4,3,3 ),
('Exam' , '10:50:00' , '11:50:00' ,2022,2,3,2,1,1,8,5,4,3,3 ),
('Exam' , '10:50:00' , '11:50:00' ,2023,3,4,2,1,1,8,5,4,3,3 ),
('Corrective' , '10:50:00' , '11:50:00' ,2023,2,1,2,1,0,8,5,4,3,3 ),
('Corrective' , '10:50:00' , '11:50:00' ,2021,4,2,2,1,1,7,5,4,3,3 ),
('Corrective' , '10:50:00' , '11:50:00' ,2022,3,1,2,1,0,9,5,4,3,3 )
 select *from Instructor.Exam

 ----Data Insertion to Chosen_Student Table
 INSERT INTO Instructor.Chosen_Student VALUES
	(2, 6, '2024-01-20', 0, 4),
	(2, 14, '2024-01-25', 1, 5),
	(3, 6, '2024-01-19', 0, 6),
	(4, 6, '2024-01-17', 1, 7),
	(5, 6, '2024-01-20', 0, 1),
	(6, 12, '2024-01-26', 1, 2),
	(5, 12, '2024-01-22', 0, 1),
    (2, 12, '2024-01-23', 1, 4),
    (3, 12, '2024-01-25', 0, 5),
	(4, 13, '2024-01-26', 1, 6),
	(5, 13, '2024-01-22', 0, 7),
    (6, 13, '2024-01-24', 1, 2),
	(2, 11, '2024-01-23', 0, 2);

	select * from Instructor.Chosen_Student

 ----Data Insertion to Student_Takes_Course Table
 INSERT INTO Student.Student_Takes_Course VALUES
	(2 , 8),(2 , 10),(2 , 11),
	(3 , 9),(3 , 12),(3 , 13),(3 , 8),
	(4 , 7),(5 , 8),(5 , 14),(5, 10),
	(6 , 12),(6 , 9),(6 , 14);

 ----Data Insertion to Exam_Has_Question Table
 INSERT INTO Exam_Has_Question VALUES 
	(11 , 51),(11 , 52),(11 , 53),(11 , 54),
	(6 , 55),(6 , 56),(6 , 57),(6 , 58),
	(12 , 59),(12 , 60),(12 , 61),(12 , 62),
	(15 , 63),(15 , 64),(15 , 65),(15 , 66),
	(16 , 67),(16 , 68);

----Data Insertion to Student_Perform_Exam Table
INSERT INTO Student.Student_Perform_Exam VALUES 
	(2 , 11 , NULL),
	(2 , 12 , NULL),
	(2 , 6, NULL),
	(3 , 6 , NULL),
	(3 , 11 , NULL),
	(4 , 11 , NULL),
	(4 , 6 , NULL),
	(5 , 12, NULL),
	(5 , 15, NULL),
	(6 , 15, NULL),
	(6 , 6, NULL);

 -- Data Insertion to Student_Answer Table   ................
insert into Student_Answer values
(2,6,55,'A',0 ),(2,6,56,'T',0 ),(2,6,57,'A',1 ),(2,6,58,'A',1 ),
(2,12,59,'F',0 ),(2,12,60,'B',0 ),(2,12,61,'T',1 ),(2,12,62,'C',1 ),
(3,6,55,'A',0 ),(3,6,56,'T',0 ),(3,6,57,'A',1 ),(3,6,58,'A',1 )

select *from Student_Answer
 
 

 