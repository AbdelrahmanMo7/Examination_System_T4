-- Veiws of DB  
use T4_Examination_System
go 
------------------------student Views 
------->> Show student all data view  
create or alter view Show_Student_All_Data_View
as
(
	select s.[ST_ID] 'Your ID',s.[ST_Name] 'Name' , s.[ST_Age] 'Age' ,s.[ST_Address] 'Address',s.[ST_Personal_Data] 'Pesonal Data',s.[ST_UserName] 'User Name' , c.[C_Name] 'Course'
			,[TCK_Name]'Track', [INT_Name] 'Intake',[BR_Name] 'Branch'
	from [Training_Manager].[Student] s ,[Student].[Student_Takes_Course]t, [dbo].[Course] c ,
		[Training_Manager].[Branch],[Training_Manager].[Intake],[Training_Manager].[Track] 
	where s.[ST_ID]=t.[St_ID] and [Cour_ID]= c.[C_ID] and s.[ST_TCK_id]=[TCK_ID] and s.[ST_IN_id]=[INT_ID]
			and s.[ST_BR_id]=[BR_ID]  and s.ST_UserName=cast (SUSER_NAME() as nvarchar(50))
)

----->> Show student personal data view  
create or alter view Show_Student_PesonallData_View
as
(
	select s.[ST_ID] 'Your ID',s.[ST_Name] 'Name' , s.[ST_Age] 'Age' ,s.[ST_Address] 'Address',s.[ST_Personal_Data] 'Pesonal Data',s.[ST_UserName] 'User Name' 
	from [Training_Manager].[Student] s 
	where  s.ST_UserName=cast (SUSER_NAME() as nvarchar(50))
)

select * from Show_Student_PesonallData_View

------->> Show student courses view  
create or alter view Show_Student_courses_View
as
(
	select  c.[C_Name] 'Course Name ', c.C_Description 'Description' 
	from [Training_Manager].[Student] s ,[Student].[Student_Takes_Course]t, [dbo].[Course] c 
	where s.[ST_ID]=t.[St_ID] and t.[Cour_ID]= c.[C_ID] and s.ST_UserName=cast (SUSER_NAME() as nvarchar(50))
)

select * from  Show_Student_courses_View


------->> Show student exams view  
create or alter view Show_Student_Exams_and_Grade_View
as
(
	select e.EX_Type 'Exam Type' , c.C_Name 'Course', e.EX_total_Time 'Total Time' , CONVERT(VARCHAR, e.EX_Start_Time, 24) 'Start at time ' , (e.EX_Multi_Q_Num+e.EX_T_F_Q_Num) 'Total Questions' ,p.Total_Result 'Your Final Grade '
	from  [Instructor].[Exam] e,[Student].[Student_Perform_Exam] p,[Training_Manager].[Student] s, [dbo].[Course] c  
	where e.EX_ID=p.Exam_ID and p.Student_ID=s.ST_ID and c.C_ID=e.Cour_Id  and   s.ST_UserName=cast (SUSER_NAME() as nvarchar(50))
)

select * from Show_Student_Exams_and_Grade_View
select * from [Student].[Student_Perform_Exam]

------->> Show student answer exams view  
create or alter view Show_Student_answers_View
as
(
	select a.Stu_Q_Exam_ID'Exam Id', c.EX_Date 'Exam date', q.Q_Body 'Question', a.Stu_Answer 'Your Answer' , case  a.Stu_Check_Correct when 1 then 'Correct' else 'Not Correct ' end  as 'Reasult'
	from [dbo].[Student_Answer] a , [Instructor].[Chosen_Student] c ,[dbo].[Question] q ,[Training_Manager].[Student] s
	where a.StuPerEX_Student_ID=3 and c.CH_ST_ID=s.ST_ID and a.Stu_Q_Exam_ID=c.CH_ST_EX_id and q.Q_ID=a.ExHasQ_Question_ID and  s.ST_UserName=cast (SUSER_NAME() as nvarchar(50))
)
select * from Show_Student_answers_View

------->> Show all students exams final reasult view  
create or alter view Show_All_Student_ExamsGrade_View
as
(
	select s.ST_ID 'Student Id', s.ST_Name 'Name',  e.EX_Type 'Exam Type' , ch.EX_Date 'Exam date', c.C_Name 'Course',p.Total_Result 'Your Exam Final Grade '
	from  [Instructor].[Exam] e,[Student].[Student_Perform_Exam] p,[Training_Manager].[Student] s, [dbo].[Course] c  , [Instructor].[Chosen_Student] ch 
	where e.EX_ID=p.Exam_ID and p.Student_ID=s.ST_ID and  c.C_ID=e.Cour_Id  and ch.CH_ST_EX_id=p.Exam_ID and ch.CH_ST_ID=p.Student_ID
)

select * from Show_All_Student_ExamsGrade_View

--------------------------------------------------------------------Eslam Views                           ---------------

create or alter view Get_Student_Data_VIEW
AS
	select s.ST_ID as 'Student Id' , s.ST_UserName as 'User Name ' , s.ST_Name'Student Name ', s.ST_Age as 'Age' ,B.BR_Name as 'Branch Name', s.ST_Personal_Data As 'Personal Data'
	from [Training_Manager].[Student]s , [Training_Manager].[Branch] B 
	where s.ST_BR_id = b.BR_ID

 select * from Get_Student_Data_VIEW
 --------------------------------------------
 --------------------------------------------
 create or alter view Show_All_Chosen_Student_VIEW
AS
	select s.ST_Name as 'Name' ,E.EX_Type as 'Exam type' ,CH.EX_Date 'Date of Exam',C.C_Name as 'Course Name'
		from [Instructor].[Chosen_Student] CH ,
		[Instructor].[Exam] E ,
		[dbo].[Course] C ,
		[Training_Manager].[Student] S
	where ch.CH_ST_ID = s.ST_ID and ch.CH_ST_EX_id = E.EX_ID and e.Cour_Id = c.C_ID

select * from Show_All_Chosen_Student_VIEW
--------------------------------------------
--------------------------------------------
Create or alter view show_Instractor_Data_View
As
	Select I.INS_ID as 'ID',  I.INS_Name as 'Name' , I.INS_UserName as 'User NAme' ,I.INS_Age as 'Age' ,I.INS_Address as 'Address' , I.INS_PersonalData AS 'Personal Data' 
	From Instructor I
	where I.INS_UserName = cast (SUSER_NAME() as nvarchar(50));

select * from show_Instractor_Data_View
--------------------------------------------

--------------------------------------------
Create view Show_All_StudentName_With_CorseNAme
AS
select S.ST_Name As 'Student Name' , C.C_Name As 'Course Name'
from [Training_Manager].[Student] S ,
[dbo].[Course] C,
[Student].[Student_Takes_Course] STC
Where S.ST_ID = STC.St_ID And STC.Cour_ID = c.C_ID;

select * from Show_All_StudentName_With_CorseNAme
--------------------------------------------
--------------------------------------------
Create or alter View Show_Course_Data_For_Instractoer_View
AS
	Select I.INS_Name As 'Instractor Name',C.C_Name As 'Course Name'
	from [dbo].[Instructor] I ,[dbo].[Course] C
	where  c.Inst_Id=i.INS_ID  and cast (SUSER_NAME() as nvarchar(50)) = i.INS_UserName

select * from Show_Course_Data_For_Instractoer_View
--------------------------------------------
--------------------------------------------
create or alter View show_All_inst_Qustion_View
As
	Select  e.EX_ID'Exam ID', c.C_Name 'Course', Q.Q_Body as 'Qustion body' ,Q.Q_CH1 as 'A' ,
	Q.Q_CH2 As 'B' , Q.Q_CH3 as 'C' ,
	Q.Q_CH4 as' d',Q.Q_Correct_Answer as 'Correct Answer'
	From [dbo].[Instructor] I ,
	[dbo].[Question] Q ,
	[dbo].[Course] c,
	[dbo].[Exam_Has_Question] h,
	[Instructor].[Exam] e
	where q.Q_ID=h.Question_ID and e.EX_ID=h.Exam_ID and   c.C_ID = q.Cour_Id and e.Inst_Id=i.INS_ID and  cast (SUSER_NAME() as nvarchar(50))= i.INS_UserName
--and i.INS_ID=5 
select * from show_All_inst_Qustion_View
----------------------------------------------
----------------------------------------------
Create or alter View Instractor_Exams_View
As
	select E.EX_ID as 'Exam Id' ,
	c.C_Name as 'Course Name' ,e.EX_Start_Time as 'Exam Start Time' ,
	e.EX_End_Time 'Exam End Time' ,E.EX_Year as 'Exam Year'  ,e.EX_Type as 'Exam Type',b.BR_Name as 'Branch Name' 
	From [dbo].[Instructor]I,[Instructor].[Exam]E ,
	[Training_Manager].[Branch]B ,[dbo].[Course] c
	Where   E.Br_Id = b.BR_ID and e.Inst_Id=i.INS_ID and e.Cour_Id=c.C_ID   and cast (SUSER_NAME() as nvarchar(50)) = i.INS_UserName;
--and i.INS_ID=5 
select * from Instractor_Exams_View
	----------------------------------------------
--------------------------------------------------
Create or alter  View All_Instractor_Data_View
As
	Select I.INS_ID as 'Instractor ID',
	I.INS_Name as 'Name' , I.INS_Age as'Age' ,
	I.INS_Address as 'Address' ,I.INS_UserName 'User Name'
	from [dbo].[Instructor] I

select * from All_Instractor_Data_View

	----------------------------------------------
--------------------------------------------------
Create or alter View All_Courses_View
As
Select C.C_ID As 'Course Id',i.INS_Name as 'Instractor Degree' ,
c.C_Description as 'Course Description' , 
C.C_Max_Degree as 'Max Degree' , C.C_Min_Degree as 'Min Degree'
from [dbo].[Course]C ,[dbo].[Instructor] i
where i.INS_ID=c.Inst_Id


select * from All_Courses_View
----------------------------------------------
--------------------------------------------------
Create or alter View  All_Tracks_View
as 
Select t.TR_id as 'Track ID' , T.TCK_Name as 'Track Name' , tm.TR_Name 'Training Manager'
from [Training_Manager].[Track] t, [dbo].[Traning_Manager] tm
where tm.TR_ID= t.TR_id

----------------------------------------------
----------------------------------------------
Create or Alter View All_Department_View
As 
Select d.DEP_ID as 'Department Id' ,d.DEP_Name as 'DepartMent Name ' ,tr.TR_Name as 'Traning Manger Name'
from [Training_Manager].[Department] d ,[dbo].[Traning_Manager]tr
where tr.TR_ID = d.TR_id
----------------------------------------------
--------------------------------------------------
Create or Alter View All_Intake_View
as
Select ta.INT_ID as 'Intake ID' ,ta.INT_Name 'Intake Name '
from [Training_Manager].[Intake] ta







