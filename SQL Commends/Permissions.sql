-- Permissions of DB  
use T4_Examination_System
go 
------------------------student Views 
------->> Show student all data view  


select SUSER_NAME() 'user name'

CREATE LOGIN Student_21
    WITH PASSWORD = '123';  
GO  

-- Creates a database user for the login created above.  
CREATE USER Student_21 FOR LOGIN Student_21; 


--- s proc
grant execute on object :: [dbo].[Sudent_Choose_Exam] to  Student_21--done
grant execute on object ::  [dbo].[get_ExAndDegree]    to  Student_21
grant execute on object ::   [dbo].[get_ExData]  to  Student_21
grant execute on object ::   [dbo].[get_Student_Data]  to  Student_21
grant execute on object ::   [dbo].[Show_Exam_Question]   to  Student_21
grant execute on object ::   [dbo].[Stuent_Set_Answer]   to  Student_21
grant execute on object ::    [dbo].[Sudent_Choose_Exam]  to  Student_21

--view
grant select on object ::[dbo].[Show_Student_PesonallData_View] to Student_21 
grant select on object :: [dbo].[Show_Student_answers_View] to Student_21 
grant select on object :: [dbo].[Show_Student_courses_View] to Student_21 
grant select on object :: [dbo].[Show_Student_Exams_and_Grade_View] to Student_21 


 select * from [Training_Manager].[Student]
 select * from [dbo].[Show_All_Chosen_Student_VIEW]


 -----------------------inst

 CREATE LOGIN Ins6
    WITH PASSWORD = '123';  
GO  

-- Creates a database user for the login created above.  
CREATE USER Ins6 FOR LOGIN Ins6; 


grant execute on object ::   [dbo].[Add_New_Exam_withManulQ_Proc]   to  Ins6
grant execute on object ::   [dbo].[Add_New_Exam_withRandomQuestion_Proc]   to  Ins6
grant execute on object ::   [dbo].[Add_Question_to_Exam_Manully_Proc]   to  Ins6
grant execute on object ::    [dbo].[delete_Chosen_Student_Proc]  to  Ins6
grant execute on object ::   [dbo].[delete_Exam_Proc]   to  Ins6
grant execute on object ::   [dbo].[get_ExData]   to  Ins6
grant execute on object ::  [dbo].[get_Instructor_Data]    to  Ins6
grant execute on object ::   [dbo].[select_Exam_to_Student_Proc]   to  Ins6
grant execute on object ::  [dbo].[Show_Exam_Question]    to  Ins6
grant execute on object ::   [dbo].[update_Exam_data_Proc]    to  Ins6
grant execute on object ::    [dbo].[update_Exam_Question_Proc]  to  Ins6
grant execute on object ::   [dbo].[Update_Chosen_Student_Proc]   to  Ins6


-----views
grant select on object :: [dbo].[Instractor_Exams_View] to Ins6 
grant select on object :: [dbo].[Show_All_Chosen_Student_VIEW] to Ins6 
grant select on object :: [dbo].[Show_All_Student_ExamsGrade_View] to Ins6 
grant select on object :: [dbo].[Show_All_StudentName_With_CorseNAme] to Ins6 
grant select on object :: [dbo].[Show_Course_Data_For_Instractoer_View]  to Ins6 
grant select on object :: [dbo].[show_Instractor_Data_View] to Ins6 





---------------------------------------- T M

CREATE LOGIN T_M_6
    WITH PASSWORD = '123';  
GO  

-- Creates a database user for the login created above.  
CREATE USER T_M_6 FOR LOGIN T_M_6; 


grant execute on object ::   [dbo].[UpdateTrack]   to  T_M_6
grant execute on object ::   [dbo].[UpdateIntake]   to  T_M_6
grant execute on object ::   [dbo].[UpdateDepartment]   to  T_M_6
grant execute on object ::   [dbo].[UpdateBranch]   to  T_M_6
grant execute on object ::  [dbo].[Update_Student_Proc]    to  T_M_6
grant execute on object ::   [dbo].[update_Course_proc] to  T_M_6
grant execute on object ::   [dbo].[InsertNewTrack]   to  T_M_6
grant execute on object ::   [dbo].[InsertNewIntake]   to  T_M_6
grant execute on object ::  [dbo].[InsertNewIntake]    to  T_M_6
grant execute on object ::   [dbo].[InsertNewDepartment]   to  T_M_6
grant execute on object ::   [dbo].[InsertNewBranch]   to  T_M_6
grant execute on object ::   [dbo].[get_Student_Data]   to  T_M_6
grant execute on object ::   [dbo].[get_ExData]   to  T_M_6
grant execute on object ::   [dbo].[DeleteTrack]   to  T_M_6
grant execute on object ::    [dbo].[DeleteIntake]  to  T_M_6
grant execute on object ::    [dbo].[DeleteDepartment]  to  T_M_6
grant execute on object ::   [dbo].[DeleteBranch]   to  T_M_6
grant execute on object ::  [dbo].[delete_Course_proc]    to  T_M_6
grant execute on object ::  [dbo].[Add_New_Course_proc]    to  T_M_6


--- views
grant select on object :: [dbo].[All_Courses_View] to T_M_6 
grant select on object :: [dbo].[All_Department_View] to T_M_6 
grant select on object :: [dbo].[All_Instractor_Data_View]  to T_M_6 
grant select on object :: [dbo].[All_Instractor_Data_View] to T_M_6 
grant select on object :: [dbo].[All_Intake_View] to T_M_6 
grant select on object :: [dbo].[All_Tracks_View] to T_M_6 
grant select on object :: [dbo].[Show_All_Chosen_Student_VIEW] to T_M_6 
grant select on object :: [dbo].[Show_All_Student_ExamsGrade_View] to T_M_6 
grant select on object :: [dbo].[Show_All_StudentName_With_CorseNAme] to T_M_6 





