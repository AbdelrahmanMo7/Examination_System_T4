-- INDEX of DB  
use T4_Examination_System
go 
------------------------
----->> Index Exam Table
--year index
create  nonclustered index Exam_YEAR_index
on Instructor.Exam([EX_Year])

--course index
create nonclustered index Exam_COURSE_ID_index
on Instructor.Exam([Cour_Id])

--instructor index
create nonclustered index Exam_INSTRUCTOR_ID_index
on Instructor.Exam([Inst_Id])

--Type index
create nonclustered index Exam_TYPE_index
on Instructor.Exam([EX_Type])

