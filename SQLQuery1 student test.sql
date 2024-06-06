-----

--student 21 get his data
select * from [dbo].[Show_Student_PesonallData_View]
--
select * from [dbo].[Show_Student_PesonallData_View]
-- his courses 
select * from [dbo].[Show_Student_courses_View]
--
------------
--- student show exam
exec [dbo].[get_ExData] 35

--- student choose exam 
exec [dbo].[Sudent_Choose_Exam] 35

--- student choose answer
exec [dbo].[Stuent_Set_Answer]
@Exam_Id = 35,
@Q_ID = 8,
@Answer = d

---- 
exec [dbo].[get_ExAndDegree] 21

---- his exams  and degree
 select * from [dbo].[Show_Student_Exams_and_Grade_View]