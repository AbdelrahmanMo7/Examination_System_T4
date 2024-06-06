--	Trigger of DB  
use T4_Examination_System
go 
---------------------------------------------------------
----->> Check Exam Total Degree Trigger

create or alter trigger Check_Exam_TotalDegree_trg
on [Instructor].[Exam] 
after insert ,Update 
as 
begin
	declare @course_id int  =(select [Cour_Id] from inserted )
	declare @course_max_degree float =(select [C_Max_Degree] from [dbo].[Course] c where c.C_ID= @course_id)
	declare @course_min_degree float =(select [C_Min_Degree] from [dbo].[Course] c where c.C_ID= @course_id)
	declare @exam_total_degree float =(	select (EX_Multi_Q_Degree*EX_Multi_Q_Num)+(EX_T_F_Q_Degree*EX_T_F_Q_Num)  from inserted )
	if (@exam_total_degree between @course_min_degree and @course_max_degree )
		begin
			print 'Trigger is Ok '
		end 
	else 
		begin
			print ' Total degree for all Questions in this Exam is not between 
						the Min Degree and Max Degree of it`s course '
			print 'correct them .'
			rollback
		end
end 
----

exec update_Exam_data_Proc @exam_id=15, @exam_type='Exam', @start_time='06:30:00' ,@end_time= '23:50:00' ,@year=2444,
										@multi_Q_num =4,@multi_Q_degree =10,@t_f_Q_num=10,@t_f_Q_degree =5,@allawnece =1 ,
										 @track_id =4,@intake_id =3,@branch_id =2
------test result
select *from [Instructor].[Exam] e where e.EX_ID= 15
select e.Cour_Id, (EX_Multi_Q_Degree*EX_Multi_Q_Num)+(EX_T_F_Q_Degree*EX_T_F_Q_Num) 'total degree' 
from [Instructor].[Exam]e where e.EX_ID= 15
select * from [dbo].[Course] c where c.C_ID= 8
-- more test
select * from [Instructor].[Exam]
select * from [dbo].[Exam_Has_Question] s ,[dbo].[Question] q  where s.Exam_ID=15 and s.Question_ID=q.Q_ID  order by q.Q_Type


----------------------------------------------------------------------
----->> Calc Exam final reasult of the students Trigger

create or alter trigger Calc_stu_Exam_finalReasult_trg
on [dbo].[Student_Answer]
after insert ,Update 
as 
begin
	declare @st_id int  =(select [StuPerEX_Student_ID] from inserted )
	declare @ex_id int  =(select [Stu_Q_Exam_ID] from inserted )
	declare @Multi_Q_Degree float =(select e.EX_Multi_Q_Degree  from [Instructor].[Exam] e where e.EX_ID= @ex_id)
	declare @T_F_Q_Degree float =(select e.EX_T_F_Q_Degree  from [Instructor].[Exam] e where e.EX_ID= @ex_id)
	declare @m_num int =0,@t_num int =0
	
	declare c1 cursor  
	for  select s.ExHasQ_Question_ID ,s.Stu_Check_Correct from Student_Answer s where s.Stu_Q_Exam_ID=35
	declare @q_id int , @is_ok bit
	open c1  
	fetch c1 into @q_id ,@is_ok
	while @@FETCH_STATUS =0
		begin
			if(@is_ok=1)
				begin
					if ((select q.Q_Type from [dbo].[Question] q where q.Q_ID =@q_id)='Multi')
						begin
							set @m_num = @m_num+1
						end
					else
						begin
							set @t_num = @t_num+1
						end
				end
			fetch c1 into @q_id ,@is_ok
		end	
	close c1 
	deallocate c1

	update [Student].[Student_Perform_Exam]
	set [Total_Result] =(@Multi_Q_Degree*@m_num)+(@T_F_Q_Degree*@t_num)
	where [Student_ID]=@st_id and [Exam_ID]=@ex_id
end 
----
exec Stuent_Set_Answer
@Exam_Id = 35,
@Student_ID = 3,
@Q_ID = 57,
@Answer = A
select * from Student_Answer s where s.Stu_Q_Exam_ID=35 order by s.StuPerEX_Student_ID desc
select * from [Student].[Student_Perform_Exam] x where x.Exam_ID=35


-------------------------------------------------------------
----->> pervent delete in student Answer Trigger

create or alter trigger pervent_Delete_Answer_trg
on [dbo].[Student_Answer]
instead of delete
as 
begin
	print 'You cannot delete any student Answer'
end 
----
delete from Student_Answer 
where StuPerEX_Student_ID= 2 and Stu_Q_Exam_ID=6 and ExHasQ_Question_ID=56

select * from Student_Answer s where StuPerEX_Student_ID= 2 and Stu_Q_Exam_ID=6

-----------------------------------------------------------------
----->> pervent delete Exam final reasult of student Trigger  ======> in [Student].[Student_Perform_Exam] table

create or alter trigger pervent_Delete_Final_Reasult_trg
on [Student].[Student_Perform_Exam]
instead of delete
as 
begin
	print 'You cannot delete Exam final reasult of student. '
end 
----
select * from [Student].[Student_Perform_Exam]

delete from [Student].[Student_Perform_Exam]
where Student_ID =2 and Exam_ID =6


