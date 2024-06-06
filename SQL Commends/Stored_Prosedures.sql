-- Stored Procedures of DB  
use T4_Examination_System
go 
---- student table opration
----->> Add New Student Proc
create or alter procedure Add_New_Student_Proc (@name nvarchar(30),@age int ,@address nvarchar(50),
												@pesonal_data nvarchar(50),@track_id int,@intake_id int,
												@branch_id int )
as 
begin
	if (not(SUSER_NAME() like 'Student_%') and not(SUSER_NAME() like 'Ins%') )
		begin
			declare @st_id  int ,@tm_id int
			set @tm_id= (select [TR_ID] from [dbo].[Traning_Manager] where [TR_UserName] =SUSER_NAME() )			
			insert into [Training_Manager].[Student] 
			values  (@name,@age, @address, @pesonal_data, null,@track_id, @tm_id, @intake_id , @branch_id)
			set @st_id= (select top 1 s.ST_ID from [Training_Manager].[Student] s order by s.ST_ID  desc)
			update  [Training_Manager].[Student]
			set [ST_UserName] = ('Student_'+cast(@st_id as nvarchar(10) ))
			where ST_ID =@st_id	
			
			
			print 'student is Added Succesfully '
		end
	else 
		begin
			print 'You are not Training Manager or Admin.'
			print 'You are not allowed to add new student.'
		end
end

exec Add_New_Student_Proc @name= 'ahmed',@age=25 ,@address='mini' ,@pesonal_data='singel',@track_id=2, @intake_id=2 , @branch_id=3
select * from [Training_Manager].[Student] 
-------------------------------------

----->> update Student Proc
create or alter procedure Update_Student_Proc (@Student_Id int,@name nvarchar(30),@age int ,@address nvarchar(50),
												@pesonal_data nvarchar(50),@track_id int,@intake_id int,
												@branch_id int )
as 
begin
	if (not(SUSER_NAME() like 'Student_%') and not(SUSER_NAME() like 'Ins%') )
		begin
			declare @tm_id int
			set @tm_id= (select [TR_ID] from [dbo].[Traning_Manager] where [TR_UserName] =SUSER_NAME() )			
			update [Training_Manager].[Student] 
			set   [ST_Name]=@name ,[ST_Age]= @age, [ST_Address]=@address,[ST_Personal_Data]= @pesonal_data,[ST_TCK_id]=@track_id,[ST_TR_id]= @tm_id,[ST_IN_id]= @intake_id ,[ST_BR_id]=@branch_id
			where [ST_ID] = @Student_Id
			print 'student is updated Succesfully '
		end
	else 
		begin
			print 'You are not Training Manager.'
			print 'You are not allowed to update this student.'
		end
end

exec Update_Student_Proc @Student_Id=20, @name= 'ali',@age=25 ,@address='minia' ,@pesonal_data='married',@track_id=2, @intake_id=2 , @branch_id=3
select * from [Training_Manager].[Student] 
-----------------------------------------

----->> delate Student Proc
create or alter procedure delete_Student_Proc (@Student_Id int)
as 
begin
	if (not(SUSER_NAME() like 'Student_%') and not(SUSER_NAME() like 'Ins%') )
		begin
		------ 
			if exists (select * from [Training_Manager].[Student] s where s.ST_ID=@Student_Id ) 
				begin
					delete from [Student].[Student_Takes_Course]
					where [St_ID] = @Student_Id
					delete from [Training_Manager].[Student] 
					where [ST_ID] = @Student_Id
					print 'student is deleted Succesfully '
				end
			else 
				begin
					print 'this student does not exist.'
					print 'renter correct student Id .'
				end
		end
	else 
		begin
			print 'You are not Training Manager.'
			print 'You are not allowed to delete this student.'
		end
end

exec delete_Student_Proc @Student_Id=17
----------------------------------------------------------------------
---- Chosen student table opration

----->> Select new Chosen Student to perform exam Proc
create or alter procedure select_Exam_to_Student_Proc (@student_id int,@exam_id int ,@exam_date date,@ChosenOrNot bit)
as 
begin
	declare @type_ex nvarchar(30) =(select e.EX_Type from [Instructor].[Exam] e where e.EX_ID= @exam_id )
	declare @course_ex nvarchar(30) =(select e.Cour_Id from [Instructor].[Exam] e where e.EX_ID= @exam_id )
	declare @degree float  =(select p.Total_Result from [Student].[Student_Perform_Exam]p , [Instructor].[Exam] e where p.Student_ID =5 and e.EX_ID =p.Exam_ID and e.Cour_Id=5)
	
	if (not(SUSER_NAME() like 'Student_%') and not(SUSER_NAME() like 'T_M%') )
		begin
			if exists (select * from [Training_Manager].[Student] s where s.ST_ID=@Student_Id ) 
				begin
					if exists (select * from [Instructor].[Exam]e where e.EX_ID=@exam_id ) 
						begin
						declare @ins_id int
							if (@type_ex ='Corrective')
							begin

									if (@degree<50)
									begin
												
										set @ins_id= (select [INS_ID] from [dbo].[Instructor] where [INS_UserName]=SUSER_NAME() )		
										if not exists (select * from [Instructor].[Chosen_Student] where [CH_ST_ID]=@student_id and [CH_ST_EX_id] = @exam_id) 
											begin		
												insert into [Instructor].[Chosen_Student]
												values  (@student_id,@exam_id, @exam_date, @ChosenOrNot, @ins_id)
												print 'Student has selected to perform Exam Succesfully '
											end
										else 
											begin
												print 'this Exam exist for this student.'
												print 'renter correct Exam Id or correct Student Id.'
											end
									end 

							end 
							else 
							begin
									
								set @ins_id= (select [INS_ID] from [dbo].[Instructor] where [INS_UserName]=SUSER_NAME() )		
								if not exists (select * from [Instructor].[Chosen_Student] where [CH_ST_ID]=@student_id and [CH_ST_EX_id] = @exam_id) 
									begin		
										insert into [Instructor].[Chosen_Student]
										values  (@student_id,@exam_id, @exam_date, @ChosenOrNot, @ins_id)
										print 'Student has selected to perform Exam Succesfully '
									end
								else 
									begin
										print 'this Exam exist for this student.'
										print 'renter correct Exam Id or correct Student Id.'
									end
							end 
							
						end
					else 
						begin
							print 'this Exam does not exist.'
							print 'renter correct Exam Id .'
						end
				end
			else 
				begin
					print 'this student does not exist.'
					print 'renter correct student Id .'
				end
		end
	else 
		begin
			print 'You are not an Instructor.'
			print 'only the Instructors are allowed to select Students to perform Exams.'
		end
end


exec select_Exam_to_Student_Proc @student_id= 3,@exam_id=35 ,@exam_date='2024-01-12' ,@ChosenOrNot=1
select * from [Instructor].[Chosen_Student]
SELECT top 1 * FROM [Instructor].[Chosen_Student] WHERE CH_ST_EX_id = 3
 select * from [Training_Manager].[Student] 
 select SUSER_NAME()
 ------------------------------------------

----->> update chosen Student Proc
create or alter procedure Update_Chosen_Student_Proc (@student_id int,@exam_id int ,@exam_date date,@ChosenOrNot bit)
as 
begin
	if (not(SUSER_NAME() like 'Student_%') and not(SUSER_NAME() like 'T_M%') )
		begin
			if exists (select * from [Training_Manager].[Student] s where s.ST_ID=@Student_Id ) 
				begin
					if exists (select * from [Instructor].[Exam]e where e.EX_ID=@exam_id ) 
						begin
							declare @ins_id int
							set @ins_id= (select [INS_ID] from [dbo].[Instructor] where [INS_UserName]=SUSER_NAME() )		
							if exists (select * from [Instructor].[Chosen_Student] where [CH_ST_ID]=@student_id and [CH_ST_EX_id] = @exam_id) 
								begin
									update [Instructor].[Chosen_Student]
									set   [EX_Date]= @exam_date, [Chosen?]=@ChosenOrNot,[INS_id]=@ins_id
									where [CH_ST_ID]=@student_id and [CH_ST_EX_id] = @exam_id
									print 'chosen student is updated Succesfully '
								end
							else 
								begin
									print 'this Exam does not exist for this student.'
									print 'renter correct Exam Id or correct Student Id.'
								end
						end
					else 
						begin
							print 'this Exam does not exist.'
							print 'renter correct Exam Id .'
						end
				end
			else 
				begin
					print 'this student does not exist.'
					print 'renter correct student Id .'
				end
		end
	else 
		begin
			print 'You are not an Instructor.'
			print 'only the Instructors are allowed to update chosen Student table rows.'
		end
end

exec Update_Chosen_Student_Proc @student_id=2, @exam_id= 6 ,@exam_date='2024-02-25' ,@ChosenOrNot=1
select * from [Instructor].[Chosen_Student]
--------------------------------------------------

----->> delate chosen Student Proc
create or alter procedure delete_Chosen_Student_Proc (@Student_Id int,@exam_id int)
as 
begin
	if (not(SUSER_NAME() like 'Student_%') and not(SUSER_NAME() like 'T_M%') )
		begin			
			declare @ins_id int= (select [INS_ID] from [dbo].[Instructor] where [INS_UserName]=SUSER_NAME() )		
			if exists (select * from [Instructor].[Chosen_Student] where [CH_ST_ID]=@student_id and [CH_ST_EX_id] = @exam_id) 
				begin
					delete from [Instructor].[Chosen_Student] 
					where [CH_ST_ID]=@student_id and [CH_ST_EX_id] = @exam_id
					print 'chosen Student row is deleted Succesfully '
				end
			else 
				begin
					print 'this Exam does not exist for this student.'
					print 'renter correct Exam Id or correct Student Id.'
			end
		end
	else 
		begin
			print 'You are not an Instructor.'
			print 'only the Instructors are allowed to delate chosen Student table rows.'
		end
end

exec delete_Chosen_Student_Proc @student_id=2, @exam_id=6 
select * from [Instructor].[Chosen_Student]
-----------------------------------------------------------------------

----                                     Exam table opration
----->> Add New Exam random Proc

create or alter procedure Add_New_Exam_withRandomQuestion_Proc (@exam_type nvarchar(20),@start_time time ,@end_time time,@year int,
										@multi_Q_num int,@multi_Q_degree float,@t_f_Q_num int,@t_f_Q_degree float,@allawnece bit ,
										@course_id int, @track_id int,@intake_id int,@branch_id int)
as 
begin
	if (not(SUSER_NAME() like 'Student_%') and not(SUSER_NAME() like 'T_M%'))
		begin
		
			declare @ins_id int = (select [INS_ID] from [dbo].[Instructor] where [INS_UserName]=SUSER_NAME() )
			if (SUSER_NAME() like 'Ins%') 
			begin
			
				if not exists (select * from [dbo].[Course] c where c.C_ID =@course_id  and c.Inst_Id=@ins_id)
					begin
						raiserror('Instructor does not teach this course',16,1)
						return
					end
				else 
					begin
					if ((select count(*) from [dbo].[Question] q where q.Cour_Id=@course_id)>=(@multi_Q_num+@t_f_Q_num)  )
							begin
								insert into  [Instructor].[Exam]
								values  (@exam_type,@start_time, @end_time, @year, @multi_Q_num,@multi_Q_degree,@t_f_Q_num,@t_f_Q_degree,@allawnece,@course_id,@ins_id,@track_id, @branch_id,  @intake_id )
								print 'Exam is Added Succesfully '
								-- select Q randomly 
								declare @ex_id int  
								set @ex_id =(select top 1 e.EX_ID from [Instructor].[Exam] e order by e.EX_ID DESC )
								--select multi q
								declare c1 cursor  
								for  select top(@multi_Q_num)  q.Q_ID from [dbo].[Question] q where q.Cour_Id=@course_id and q.Q_Type='Multi' order by NEWID()
								declare @q_id int
								open c1  
								fetch c1 into @q_id
								while @@FETCH_STATUS =0
										begin
											insert into [dbo].[Exam_Has_Question]
											values (@ex_id,@q_id)
											fetch c1 into @q_id
										end	
								close c1 
								deallocate c1
								select * from  [dbo].[Course]
								--select T/F q
								declare c2 cursor  
								for  select top(@t_f_Q_num)  q.Q_ID from [dbo].[Question] q where q.Cour_Id=@course_id and q.Q_Type='T/F' order by NEWID()
								declare @q_id2 int
								open c2  
								fetch c2 into @q_id2
								while @@FETCH_STATUS =0
										begin
											insert into [dbo].[Exam_Has_Question]
											values (@ex_id,@q_id2)
											fetch c2 into @q_id2
										end	
								close c2 
								deallocate c2
								print 'Questiones is Added Succesfully to this exam '
							end
						else 
							begin
								print 'nubmer of  this Exam Questiones is more than the existed Questions inthis course '
							end
					end

					
			end
		else if (not(SUSER_NAME() like 'Ins%')) 
			begin
			
				if not exists (select * from [dbo].[Course] c where c.C_ID =@course_id )
					begin
						raiserror('this Course does not exsit ',16,1)
						return
					end
				else
					begin
					if ((select count(*) from [dbo].[Question] q where q.Cour_Id=@course_id)>=(@multi_Q_num+@t_f_Q_num)  )
							begin
						insert into  [Instructor].[Exam]
						values  (@exam_type,@start_time, @end_time, @year, @multi_Q_num,@multi_Q_degree,@t_f_Q_num,@t_f_Q_degree,@allawnece,@course_id,@ins_id,@track_id, @branch_id,  @intake_id )
						print 'Exam is Added Succesfully '
						-- select Q randomly 
						declare @ex_id11 int  =(select top 1 e.EX_ID from [Instructor].[Exam] e order by e.EX_ID DESC )
						--select multi q
						declare c1 cursor  
						for  select top(@multi_Q_num)  q.Q_ID from [dbo].[Question] q where q.Cour_Id=@course_id and q.Q_Type='Multi' order by NEWID()
						declare @q_id11 int
						open c1  
						fetch c1 into @q_id11
						while @@FETCH_STATUS =0
								begin
									insert into [dbo].[Exam_Has_Question]
									values (@ex_id11,@q_id11)
									fetch c1 into @q_id11
								end	
						close c1 
						deallocate c1

						--select T/F q
						declare c2 cursor  
						for  select top(@t_f_Q_num)  q.Q_ID from [dbo].[Question] q where q.Cour_Id=@course_id and q.Q_Type='T/F' order by NEWID()
						declare @q_id22 int
						open c2  
						fetch c2 into @q_id22
						while @@FETCH_STATUS =0
								begin
									insert into [dbo].[Exam_Has_Question]
									values (@ex_id11,@q_id22)
									fetch c2 into @q_id22
								end	
						close c2 
						deallocate c2
						print 'Questiones is Added Succesfully to this exam '
						end
						else 
							begin
								print 'nubmer of  this Exam Questiones is more than the existed Questions inthis course '
							end
					end
			end
		end
	else 
		begin
			print 'You are not Instructor.'
			print 'You are not allowed to add new Exam.'
		end
end

exec Add_New_Exam_withRandomQuestion_Proc @exam_type='Exam', @start_time='10:50:00' ,@end_time= '20:50:00' ,@year=2222,
										@multi_Q_num =5,@multi_Q_degree =20,@t_f_Q_num=3,@t_f_Q_degree =30,@allawnece =1 ,
										@course_id= 11, @track_id =4,@intake_id =3,@branch_id =3

select * from [Instructor].[Exam]
select * from [dbo].[Exam_Has_Question] s ,[dbo].[Question] q  where s.Exam_ID=35 and s.Question_ID=q.Q_ID order by q.Q_Type
--------------------
-- Add New Exam manul Proc
create or alter procedure Add_New_Exam_withManulQ_Proc (@exam_type nvarchar(20),@start_time time ,@end_time time,@year int,
										@multi_Q_num int,@multi_Q_degree float,@t_f_Q_num int,@t_f_Q_degree float,@allawnece bit ,
										@course_id int, @track_id int,@intake_id int,@branch_id int)
as 
begin
	if (not(SUSER_NAME() like 'Student_%') and not(SUSER_NAME() like 'T_M%'))
		begin
		    declare @ins_id int = (select [INS_ID] from [dbo].[Instructor] where [INS_UserName]=SUSER_NAME() )
			declare @ex_id int 
			if (SUSER_NAME() like 'Ins%') 
				begin
					if not exists (select * from [dbo].[Course] c where c.C_ID =@course_id  and c.Inst_Id=@ins_id)
						begin
							raiserror('Instructor does not teach this course',16,1)
							return
						end
						else
							begin
								insert into  [Instructor].[Exam]
								values  (@exam_type,@start_time, @end_time, @year, @multi_Q_num,@multi_Q_degree,@t_f_Q_num,@t_f_Q_degree,@allawnece,@course_id,@ins_id,@track_id, @branch_id,  @intake_id )
								print 'Exam is Added Succesfully '
								-- select Q randomly 
								
								set @ex_id=(select top 1 e.EX_ID from [Instructor].[Exam] e order by e.EX_ID DESC )
								print 'use this new exam to enter questions '
								select  @ex_id  As 'New Exam ID' , @course_id As 'Exam Course ID'
								select * from [dbo].[Question] q where q.Cour_Id=@course_id order by q.Q_Type
							end
				end
			else  
				begin
					if not exists (select * from [dbo].[Course] c where c.C_ID =@course_id )
						begin
							raiserror('this Course does not exsit ',16,1)
							return
						end
					else
						begin
						if ((select count(*) from [dbo].[Question] q where q.Cour_Id=@course_id)>=(@multi_Q_num+@t_f_Q_num)  )
							begin
							insert into  [Instructor].[Exam]
							values  (@exam_type,@start_time, @end_time, @year, @multi_Q_num,@multi_Q_degree,@t_f_Q_num,@t_f_Q_degree,@allawnece,@course_id,@ins_id,@track_id, @branch_id,  @intake_id )
							print 'Exam is Added Succesfully '
							-- select Q randomly 
							set @ex_id=(select top 1 e.EX_ID from [Instructor].[Exam] e order by e.EX_ID DESC )
							print 'use this new exam to enter questions '
							select  @ex_id  As 'New Exam ID' , @course_id As 'Exam Course ID'
							select * from [dbo].[Question] q where q.Cour_Id=@course_id order by q.Q_Type
						end
						else 
							begin
								print 'nubmer of  this Exam Questiones is more than the existed Questions inthis course '
							end
						end
				end
		end
	else 
		begin
			print 'You are not Instructor.'
			print 'You are not allowed to add new Exam.'
		end
end

exec Add_New_Exam_withManulQ_Proc @exam_type='Exam', @start_time='10:50:00' ,@end_time= '11:50:00' ,@year=2222,
										@multi_Q_num =2,@multi_Q_degree =20,@t_f_Q_num=2,@t_f_Q_degree =30,@allawnece =1 ,
										@course_id= 11, @track_id =4,@intake_id =3,@branch_id =3

select * from [Instructor].[Exam]
select * from [dbo].[Exam_Has_Question] s ,[dbo].[Question] q  where s.Exam_ID=26 and s.Question_ID=q.Q_ID  order by q.Q_Type
--------------------------------------------- 
--                     question to exam manully
create or alter procedure Add_Question_to_Exam_Manully_Proc (@exam_id int,@Question_id int)
as 
begin
-- check user name
	if (not(SUSER_NAME() like 'Student_%') and not(SUSER_NAME() like 'T_M%'))
		begin
			declare @cor_id int =(select e.Cour_Id from [Instructor].[Exam] e where e.EX_ID=@exam_id)
			-- check if the exam is already exist
			if not exists (select * from  [Instructor].[Exam] e where e.EX_ID=@exam_id ) 
			begin 
				raiserror(' this exam does not exsit ',16,1)
				return
			end
		else
			begin
			-- check if the course of the exam is already exist
				if not exists (select * from [dbo].[Course] c where c.C_ID =@cor_id )
					begin
						raiserror(' Course of this exam and question does not exsit ',16,1)
						return
					end
				else 
					begin
					-- check if the exam is already need more Questions
						if (  (select count(*)from [dbo].[Exam_Has_Question] ehq where ehq.Exam_ID=@exam_id )
									< (select e.EX_Multi_Q_Num+e.EX_T_F_Q_Num from [Instructor].[Exam] e where e.EX_ID=@exam_id )  )
							begin
							-- check if this question is already exist
								if not exists (select * from [dbo].[Question] q where q.Q_ID = @Question_id  )
									begin
										raiserror(' this question does not exsit ',16,1)
										raiserror(' enter correct question ID ',16,1)
										select  *  from [dbo].[Exam_Has_Question] s ,[dbo].[Question] q  where s.Exam_ID=@exam_id and s.Question_ID=q.Q_ID
										print 'use this new exam to enter questions '
										select  @exam_id  As 'New Exam ID' , @cor_id As 'Exam Course ID'
										select * from [dbo].[Question] q where q.Cour_Id=@cor_id order by q.Q_Type
										return
									end
								else 
									begin
										---- check if this question course is already the same of the exam course
										declare @Q_course_id int =(select q.Cour_Id from [dbo].[Question] q where q.Q_ID=@Question_id)
										if(@cor_id=@Q_course_id)
											begin
											-- check if this question is already exist in this exam
												if exists (select * from [dbo].[Exam_Has_Question] ehq where ehq.Question_ID = @Question_id and ehq.Exam_ID= @exam_id  )
													begin
														raiserror(' this question is already exsit in this exam ',16,1)
														raiserror(' renter another question ID ',16,1)
														select  *  from [dbo].[Exam_Has_Question] s ,[dbo].[Question] q  where s.Exam_ID=@exam_id and s.Question_ID=q.Q_ID
														print 'use this new exam to enter questions '
														select  @exam_id  As 'New Exam ID' , @cor_id As 'Exam Course ID'
														select * from [dbo].[Question] q where q.Cour_Id=@cor_id order by q.Q_Type
														return
													end
												else 
													begin
														declare @q_type nvarchar(20) =(select q.Q_Type from [dbo].[Question] q where q.Q_ID= @Question_id)
														declare @num_of_existed_Multi_Q int =(select count(*) from[dbo].[Exam_Has_Question] ehq ,[dbo].[Question] q where ehq.Question_ID=q.Q_ID and q.Q_Type='Multi' and ehq.Exam_ID=@exam_id)
														declare @num_of_existed_T_F_Q int =(select count(*) from[dbo].[Exam_Has_Question] ehq ,[dbo].[Question] q where ehq.Question_ID=q.Q_ID and q.Q_Type='T/F' and ehq.Exam_ID=@exam_id)
														declare @num_of_exam_M_Q int =(select e.EX_Multi_Q_Num from [Instructor].[Exam] e where e.EX_ID=@exam_id )
														declare @num_of_exam_T_F_Q int =(select e.EX_T_F_Q_Num  from [Instructor].[Exam] e where e.EX_ID=@exam_id )
												
														if(@q_type='Multi' )
															begin
															-- check if this exam is already need more questions of type "Multiple"
																if(@num_of_existed_Multi_Q<@num_of_exam_M_Q)
																	begin
																		-----insert questions of type "Multiple"
																		insert into [dbo].[Exam_Has_Question] 
																		values (@exam_id,@Question_id)
																		select  *  from [dbo].[Exam_Has_Question] s ,[dbo].[Question] q  where s.Exam_ID=@exam_id and s.Question_ID=q.Q_ID
																		print 'use this new exam to enter questions '
																		select  @exam_id  As 'New Exam ID' , @cor_id As 'Exam Course ID'
																		select * from [dbo].[Question] q where q.Cour_Id=@cor_id  order by q.Q_Type
																
																	end
																else
																	begin
																		raiserror(' you can not add more questions of type "Multiple" to this exam ',16,1)
																		raiserror(' renter another question ID of type "True / False" ',16,1)
																		print 'use this new exam to enter questions '
																		select  @exam_id  As 'New Exam ID' , @cor_id As 'Exam Course ID'
																		select * from [dbo].[Question] q where q.Cour_Id=@cor_id and q.Q_Type='T/F' order by q.Q_Type
																		return
																	end
															end
														else
															begin
															-- check if this exam is already need more questions of type "True / False"
																if(@num_of_existed_T_F_Q<@num_of_exam_T_F_Q)
																	begin
																		-----insert questions of type "True / False"
																		insert into [dbo].[Exam_Has_Question] 
																		values (@exam_id,@Question_id)
																		select  * from [dbo].[Exam_Has_Question] s ,[dbo].[Question] q  where s.Exam_ID=@exam_id and s.Question_ID=q.Q_ID
																		print 'use this new exam to enter questions '
																		select  @exam_id  As 'New Exam ID' , @cor_id As 'Exam Course ID'
																		select * from [dbo].[Question] q where q.Cour_Id=@cor_id  order by q.Q_Type
																	end
																else
																	begin
																		raiserror(' you can not add more questions of type "True / False" to this exam ',16,1)
																		raiserror(' renter another question ID of type "Multiple" ',16,1)
																		print 'use this new exam to enter questions '
																		select  @exam_id  As 'New Exam ID' , @cor_id As 'Exam Course ID'
																		select * from [dbo].[Question] q where q.Cour_Id=@cor_id and q.Q_Type='Multi' order by q.Q_Type
																		return
																	end
															end
													end
										
											end 
											else 
												begin
														raiserror(' this question does not belonge to the Exam course Questions ',16,1)
														raiserror(' enter correct question ID ',16,1)
														select  *  from [dbo].[Exam_Has_Question] s ,[dbo].[Question] q  where s.Exam_ID=@exam_id and s.Question_ID=q.Q_ID
														print 'use this new exam to enter questions '
														select  @exam_id  As 'New Exam ID' , @cor_id As 'Exam Course ID'
														select * from [dbo].[Question] q where q.Cour_Id=@cor_id order by q.Q_Type
														return
												end
									end
							end 
						else 
							begin
							     print 'you can not add more question to this exam '
						         return
							end

					end
			end
		end
	else 
		begin
			print 'You are not Instructor.'
			print 'You are not allowed to add Questions to this Exam.'
		end

end

exec Add_Question_to_Exam_Manully_Proc @exam_id= 29,@Question_id=47

select * from [Instructor].[Exam]
select * from [dbo].[Exam_Has_Question] s ,[dbo].[Question] q  where s.Exam_ID=29 and s.Question_ID=q.Q_ID order by q.Q_Type
----------------------------------

----              update exam data
create or alter procedure update_Exam_data_Proc (@exam_id int ,@exam_type nvarchar(20),@start_time time ,@end_time time,@year int,
												@multi_Q_num int,@multi_Q_degree float,@t_f_Q_num int,@t_f_Q_degree float,@allawnece bit ,
											 @track_id int,@intake_id int,@branch_id int)
as 
begin
	if (not(SUSER_NAME() like 'Student_%') and not(SUSER_NAME() like 'T_M%'))
		begin
			declare @course_id int =(select e.Cour_Id from [Instructor].[Exam] e where e.EX_ID=@exam_id)
			declare @ins_id int = (select [INS_ID] from [dbo].[Instructor] where [INS_UserName]=SUSER_NAME() )
			if  not exists (select * from[Instructor].[Exam] e where e.EX_ID= @exam_id)
				begin
					raiserror(' this Exam does not exist  ',16,1)
					raiserror(' renter correct Exam ID ',16,1)
				end
			else
				begin
					if (SUSER_NAME() like 'Ins%') 
						begin
							if not exists (select * from [dbo].[Course] c where c.C_ID =@course_id  and c.Inst_Id=@ins_id)
								begin
									raiserror('Instructor does not teach this course',16,1)
									return
								end
								else
									begin
									if ((select count(*) from [dbo].[Question] q where q.Cour_Id=@course_id)>=(@multi_Q_num+@t_f_Q_num)  )
										begin
										update   [Instructor].[Exam]
										set  [EX_Type]=@exam_type,  [EX_Start_Time]=@start_time,  [EX_End_Time]= @end_time,   [EX_Year]= @year,  
													[EX_Multi_Q_Num]=@multi_Q_num,  [EX_Multi_Q_Degree]=@multi_Q_degree,  [EX_T_F_Q_Num]=@t_f_Q_num,  [EX_T_F_Q_Degree]= @t_f_Q_degree ,     
													[EX_Allowance_Options]=@allawnece,  [Cour_Id]= @course_id,[Inst_Id]= @ins_id,   [Tck_Id]=@track_id,   [Br_Id]= @branch_id,   [Intake_Id]= @intake_id 
										where  [EX_ID]=@exam_id
										print 'Exam is updated Succesfully '
										select * from [Instructor].[Exam] e where e.EX_ID=@exam_id
									end
									else 
										begin
											print 'nubmer of  this Exam Questiones is more than the existed Questions inthis course '
										end
									end
						end
					else  
						begin
							if not exists (select * from [dbo].[Course] c where c.C_ID =@course_id )
								begin
									raiserror('this Course does not exsit ',16,1)
									return
								end
							else
								begin
									update   [Instructor].[Exam]
										set  [EX_Type]=@exam_type,  [EX_Start_Time]=@start_time,  [EX_End_Time]= @end_time,   [EX_Year]= @year,  
													[EX_Multi_Q_Num]=@multi_Q_num,  [EX_Multi_Q_Degree]=@multi_Q_degree,  [EX_T_F_Q_Num]=@t_f_Q_num,  [EX_T_F_Q_Degree]= @t_f_Q_degree ,     
													[EX_Allowance_Options]=@allawnece,  [Cour_Id]= @course_id,[Inst_Id]= @ins_id,   [Tck_Id]=@track_id,   [Br_Id]= @branch_id,   [Intake_Id]= @intake_id 
										where  [EX_ID]=@exam_id
										print 'Exam is updated Succesfully '
										select * from [Instructor].[Exam] e where e.EX_ID=@exam_id
								end
						end
		
				end
			end
	else 
		begin
			print 'You are not Instructor.'
			print 'You are not allowed to add new Exam.'
		end
end


exec update_Exam_data_Proc @exam_id=15, @exam_type='Corrective', @start_time='08:30:00' ,@end_time= '20:50:00' ,@year=2333,
										@multi_Q_num =4,@multi_Q_degree =20,@t_f_Q_num=2,@t_f_Q_degree =30,@allawnece =1 ,
										 @track_id =4,@intake_id =3,@branch_id =2

select * from [Instructor].[Exam]
select * from [dbo].[Exam_Has_Question] s ,[dbo].[Question] q  where s.Exam_ID=33 and s.Question_ID=q.Q_ID  order by q.Q_Type
----------------------------------

----              update or chenge exam Question
create or alter procedure update_Exam_Question_Proc (@exam_id int ,@old_Q_id int, @new_Q_id int )
as 
begin
	if (not(SUSER_NAME() like 'Student_%') and not(SUSER_NAME() like 'T_M%'))
		begin
			declare @course_id int =(select e.Cour_Id from [Instructor].[Exam] e where e.EX_ID=@exam_id)
			declare @ins_id int = (select [INS_ID] from [dbo].[Instructor] where [INS_UserName]=SUSER_NAME() )
			if  not exists (select * from[Instructor].[Exam] e where e.EX_ID= @exam_id)
				begin
					raiserror(' this Exam does not exist  ',16,1)
					raiserror(' renter correct Exam ID ',16,1)
				end
			else
				begin
					if (SUSER_NAME() like 'Ins%') 
						begin
							if not exists (select * from [dbo].[Course] c where c.C_ID =@course_id  and c.Inst_Id=@ins_id)
								begin
									raiserror('Instructor does not teach this course',16,1)
									return
								end
							else
								begin
										---- check if this question course is already the same of the exam course
										declare @Q_course_id int =(select q.Cour_Id from [dbo].[Question] q where q.Q_ID=@new_Q_id)
										if(@course_id=@Q_course_id)
											begin
											-- check if this question is already exist in this exam
												if exists (select * from [dbo].[Exam_Has_Question] ehq where ehq.Question_ID = @new_Q_id and ehq.Exam_ID= @exam_id  )
													begin
														raiserror(' this question is already exsit in this exam ',16,1)
														raiserror(' renter another question ID of the same type of the old Question ',16,1)
														select  *  from [dbo].[Exam_Has_Question] s ,[dbo].[Question] q  where s.Exam_ID=@exam_id and s.Question_ID=q.Q_ID and s.Question_ID=@old_Q_id
														select * from [dbo].[Question] q where q.Cour_Id=@course_id order by q.Q_Type
														return
													end

												else 
													begin
													    if ((select q.Q_Type from [dbo].[Question] q where q.Q_ID= @old_Q_id)=(select q.Q_Type from [dbo].[Question] q where q.Q_ID= @new_Q_id))
															begin
																update  [dbo].[Exam_Has_Question]
																set  [Question_ID]= @new_Q_id
																where  [Exam_ID]=@exam_id and [Question_ID]=@old_Q_id
																print 'Exam Question is updated Succesfully '
																select * from [dbo].[Question] q where q.Q_ID=@new_Q_id 
																select * from [dbo].[Exam_Has_Question] s ,[dbo].[Question] q  where s.Exam_ID=@exam_id and s.Question_ID=q.Q_ID  order by q.Q_Type
															end
														else
															begin
																raiserror(' this Question is not of the same type of the old Question ',16,1)
																raiserror(' renter another question ID of the same type of the old Question',16,1)
															end 
													end
											end 
										else 
											begin
														raiserror(' this question does not belonge to the Exam course Questions ',16,1)
														raiserror(' enter correct question ID ',16,1)
														select  *  from [dbo].[Exam_Has_Question] s ,[dbo].[Question] q  where s.Exam_ID=@exam_id and s.Question_ID=q.Q_ID and s.Question_ID=@old_Q_id
														select * from [dbo].[Question] q where q.Cour_Id=@course_id order by q.Q_Type
														return
											end
									end
						end
     ---------------
					else  
						begin
							if not exists (select * from [dbo].[Course] c where c.C_ID =@course_id )
								begin
									raiserror('this Course does not exsit ',16,1)
									return
								end
							else
								begin
										---- check if this question course is already the same of the exam course
										set @Q_course_id =(select q.Cour_Id from [dbo].[Question] q where q.Q_ID=@new_Q_id)
										if(@course_id=@Q_course_id)
											begin
											-- check if this question is already exist in this exam
												if exists (select * from [dbo].[Exam_Has_Question] ehq where ehq.Question_ID = @new_Q_id and ehq.Exam_ID= @exam_id  )
													begin
														raiserror(' this question is already exsit in this exam ',16,1)
														raiserror(' renter another question ID of the same type of the old Question ',16,1)
														select  *  from [dbo].[Exam_Has_Question] s ,[dbo].[Question] q  where s.Exam_ID=@exam_id and s.Question_ID=q.Q_ID and s.Question_ID=@old_Q_id
														select * from [dbo].[Question] q where q.Cour_Id=@course_id order by q.Q_Type
														return
													end

												else 
													begin
													    if ((select q.Q_Type from [dbo].[Question] q where q.Q_ID= @old_Q_id)=(select q.Q_Type from [dbo].[Question] q where q.Q_ID= @new_Q_id))
															begin
																update  [dbo].[Exam_Has_Question]
																set  [Question_ID]= @new_Q_id
																where  [Exam_ID]=@exam_id and [Question_ID]=@old_Q_id
																print 'Exam Question is updated Succesfully '
																select * from [dbo].[Question] q where q.Q_ID=@new_Q_id 
																select * from [dbo].[Exam_Has_Question] s ,[dbo].[Question] q  where s.Exam_ID=@exam_id and s.Question_ID=q.Q_ID  order by q.Q_Type
															end
														else
															begin
																raiserror(' this Question is not of the same type of the old Question ',16,1)
																raiserror(' renter another question ID of the same type of the old Question',16,1)
															end 
													end
											end 
										else 
											begin
														raiserror(' this question does not belonge to the Exam course Questions ',16,1)
														raiserror(' enter correct question ID ',16,1)
														select  *  from [dbo].[Exam_Has_Question] s ,[dbo].[Question] q  where s.Exam_ID=@exam_id and s.Question_ID=q.Q_ID and s.Question_ID=@old_Q_id
														select * from [dbo].[Question] q where q.Cour_Id=@course_id order by q.Q_Type
														return
											end
									end
						end
		
				end
			end
	else 
		begin
			print 'You are not Instructor.'
			print 'You are not allowed to add new Exam.'
		end
end

exec update_Exam_Question_Proc @exam_id= 34 ,@old_Q_id=57 ,@new_Q_id= 66

select * from [Instructor].[Exam]
select * from [dbo].[Exam_Has_Question] s ,[dbo].[Question] q  where s.Exam_ID=34 and s.Question_ID=q.Q_ID  order by q.Q_Type

----------------------------------

----              Delete  exam 
create or alter procedure delete_Exam_Proc (@exam_id int )
as 
begin
	if (not(SUSER_NAME() like 'Student_%') and not(SUSER_NAME() like 'T_M%'))
		begin
			if  not exists (select * from[Instructor].[Exam] e where e.EX_ID= @exam_id)
				begin
					raiserror(' this Exam does not exist  ',16,1)
					raiserror(' renter correct Exam ID ',16,1)
				end
			else 
				begin
					delete from [dbo].[Exam_Has_Question]
					where [Exam_ID]=@exam_id
					delete from [Instructor].[Exam]
					where  [EX_ID]=@exam_id
					print 'Exam is deleted Succesfully '
				end
		end
	else 
		begin
			print 'You are not Instructor or Admin.'
			print 'You are not allowed to add new Exam.'
		end
end


exec delete_Exam_Proc @exam_id=83

select * from [Instructor].[Exam]
select * from [dbo].[Exam_Has_Question] s ,[dbo].[Question] q  where s.Exam_ID=33 and s.Question_ID=q.Q_ID  order by q.Q_Type

----------------------------------------------------------------------------------
---------------- eslam proc 

----Tmanger----
----Insert-----
----
Create or alter PROCEDURE InsertNewTraningManager
    @TR_Name NVARCHAR(30)
  
AS
BEGIN

    SET NOCOUNT ON;
    -- Check if the provided TR_Name is not empty
    IF LEN(@TR_Name) = 0 OR @TR_Name IS NULL
    BEGIN
        PRINT 'Error: Training Manager name cannot be empty.';
        RETURN;
    END
    -- Check if the provided TR_UserName is not empty
   
    -- Check if the provided TR_UserName is unique
    
        -- Insert new record into Traning_Manager table
        INSERT INTO Traning_Manager 
        VALUES (@TR_Name, 'tm');
        PRINT 'New Training Manager added successfully.';
  update [dbo].[Traning_Manager]
	 set [TR_UserName] =('T_M_'+ cast((select top 1[TR_ID] from [dbo].[Traning_Manager] order by [TR_ID] desc)  as nvarchar(10) ))
	 where [TR_ID] = (select top 1[TR_ID] from [dbo].[Traning_Manager] order by [TR_ID] desc)
END;
----
EXEC InsertNewTraningManager
    @TR_Name = 'Ahmed ho'
	select * from [dbo].[Traning_Manager]

-----------delete-----
	CREATE PROCEDURE DeleteTraningManager
    @TR_ID INT
AS
BEGIN
    -- Check if TR_ID exists
    IF EXISTS (SELECT 1 FROM Traning_Manager WHERE TR_ID = @TR_ID)
    BEGIN
        -- Delete the record
        DELETE FROM Traning_Manager WHERE TR_ID = @TR_ID;
        PRINT 'Traning Manager deleted successfully.';
    END
    ELSE
    BEGIN
        -- Print a message if TR_ID does not exist
        PRINT 'Traning Manager with specified TR_ID does not exist.';
    END
END;
EXEC DeleteTraningManager @TR_ID = 7;
select * from [dbo].[Traning_Manager]
-------update-------
CREATE PROCEDURE UpdateTraningManager
    @TR_ID INT,
    @New_TR_Name NVARCHAR(30)
AS
BEGIN
    SET NOCOUNT ON;

    -- Check if TR_ID exists
    IF EXISTS (SELECT 1 FROM Traning_Manager WHERE TR_ID = @TR_ID)
    BEGIN
        -- Check if the provided New_TR_Name is not empty
        IF LEN(@New_TR_Name) = 0 OR @New_TR_Name IS NULL
        BEGIN
            PRINT 'Error: New Training Manager name cannot be empty.';
            RETURN;
        END
  -- Update the Training Manager information
            UPDATE Traning_Manager
            SET TR_Name = @New_TR_Name 
            WHERE TR_ID = @TR_ID;

            PRINT 'Training Manager updated successfully.';        
    END
    ELSE
    BEGIN
        PRINT 'Error: Training Manager with specified TR_ID does not exist.';
    END
END;

EXEC UpdateTraningManager 
	@TR_ID = 6 ,
    @New_TR_Name ='Islamo'
		---*****************************************************************************
	---*****************************************************************************
	                                     ---------Branch----------
	----------Insert---------------
	create or alter  PROCEDURE InsertNewBranch
    @BR_Name NVARCHAR(30)
 
AS
BEGIN
declare  @TR_id INT =(select t.TR_ID from [dbo].[Traning_Manager] t where t.TR_UserName =SUSER_NAME())
    SET NOCOUNT ON;
    -- Check if the provided BR_Name is not empty
    IF LEN(@BR_Name) = 0 OR @BR_Name IS NULL
    BEGIN
        PRINT 'Error: Branch name cannot be empty.';
        RETURN;
    END
	
    -- Check if the provided BR_Name is unique
    IF NOT EXISTS (SELECT 1 FROM Training_Manager.Branch WHERE BR_Name = @BR_Name)
    BEGIN
        -- Insert new record into Branch table
        INSERT INTO Training_Manager.Branch (BR_Name, TR_id)
        VALUES (@BR_Name, @TR_id);
        PRINT 'New Branch added successfully.';
    END
    ELSE
    BEGIN
        PRINT 'Error: The provided branch name is already in use. Please choose a different branch name.';
    END
END;
------
EXEC InsertNewBranch
    @BR_Name = 'Berlin'
	select * from Training_Manager.Branch
	----update----
	--------------
	CREATE or alter PROCEDURE UpdateBranch
    @BR_ID INT,
    @New_BR_Name NVARCHAR(30)
AS
BEGIN
    SET NOCOUNT ON;

    -- Check if the provided New_BR_Name is not empty
    IF LEN(@New_BR_Name) = 0 OR @New_BR_Name IS NULL
    BEGIN
        PRINT 'Error: New Branch name cannot be empty.';
        RETURN;
    END

    -- 
        -- Check if the new branch name is unique (excluding the current branch being updated)
        IF NOT EXISTS (SELECT 1 FROM Training_Manager.Branch WHERE BR_Name = @New_BR_Name AND BR_ID <> @BR_ID)
        BEGIN
            -- Update the branch information
            UPDATE Training_Manager.Branch
            SET BR_Name = @New_BR_Name
            WHERE BR_ID = @BR_ID;

            PRINT 'Branch updated successfully.';
        END
        ELSE
        BEGIN
            PRINT 'Error: The provided new branch name is already in use. Please choose a different branch name.';
        END
END;
EXEC UpdateBranch
	@BR_ID = 3 ,
    @New_BR_Name = 'Mniya'
select * from Training_Manager.Branch
	----delete----
	--------------
CREATE PROCEDURE DeleteBranch
    @BR_ID INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Check if BR_ID exists
    IF EXISTS (SELECT 1 FROM Training_Manager.Branch WHERE BR_ID = @BR_ID)
    BEGIN
        -- Delete the Branch
        DELETE FROM Training_Manager.Branch WHERE BR_ID = @BR_ID;
        PRINT 'Branch deleted successfully.';
    END
    ELSE
    BEGIN
        PRINT 'Error: Branch with specified BR_ID does not exist.';
    END
END;
EXEC DeleteBranch
@BR_ID = 6;

select * from Training_Manager.Branch

	---*****************************************************************************
	---*****************************************************************************
                                       ----------track--------
-----------Insert------------
	
	CREATE or Alter PROCEDURE InsertNewTrack
    @TCK_Name NVARCHAR(30),
    @DEP_id INT
AS
BEGIN
    SET NOCOUNT ON;
	declare  @TR_id INT =(select t.TR_ID from [dbo].[Traning_Manager] t where t.TR_UserName =SUSER_NAME())
    -- Check if the provided TCK_Name is not empty
    IF LEN(@TCK_Name) = 0 OR @TCK_Name IS NULL
    BEGIN
        PRINT 'Error: Track name cannot be empty.';
        RETURN;
    END

    -- Check if the provided DEP_id exists in the Department table
    IF NOT EXISTS (SELECT 1 FROM Training_Manager.Department WHERE DEP_ID = @DEP_id)
    BEGIN
        PRINT 'Error: Invalid DEP_id. Department does not exist.';
        RETURN;
    END

    -- Check if the provided TCK_Name is unique
    IF NOT EXISTS (SELECT 1 FROM Training_Manager.Track WHERE TCK_Name = @TCK_Name)
    BEGIN
        -- Insert new record into Track table
        INSERT INTO Training_Manager.Track (TCK_Name, TR_id, DEP_id)
        VALUES (@TCK_Name, @TR_id, @DEP_id);

        PRINT 'New Track added successfully.';
    END
    ELSE
    BEGIN
        PRINT 'Error: The provided track name is already in use. Please choose a different track name.';
    END
END;
------
EXEC InsertNewTrack
    @TCK_Name = 'New Track Name',
    @DEP_id = 2;

select * from Training_Manager.Track 
	-----------Update------------
	----------track--------
	CREATE or Alter PROCEDURE UpdateTrack
    @TCK_ID INT,
    @New_TCK_Name NVARCHAR(30),
    @New_DEP_id INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Check if the provided New_TCK_Name is not empty
    IF LEN(@New_TCK_Name) = 0 OR @New_TCK_Name IS NULL
    BEGIN
        PRINT 'Error: New Track name cannot be empty.';
        RETURN;
    END

    
    -- Check if the provided New_DEP_id exists in the Department table
    IF NOT EXISTS (SELECT 1 FROM Training_Manager.Department WHERE DEP_ID = @New_DEP_id)
    BEGIN
        PRINT 'Error: Invalid New_DEP_id. Department does not exist.';
        RETURN;
    END

    -- Check if the specified TCK_ID exists in the Track table
    IF EXISTS (SELECT 1 FROM Training_Manager.Track WHERE TCK_ID = @TCK_ID)
    BEGIN
        -- Check if the new track name is unique (excluding the current track being updated)
        IF NOT EXISTS (SELECT 1 FROM Training_Manager.Track WHERE TCK_Name = @New_TCK_Name AND TCK_ID <> @TCK_ID)
        BEGIN
            -- Update the track information
            UPDATE Training_Manager.Track
            SET TCK_Name = @New_TCK_Name,
               
                DEP_id = @New_DEP_id
            WHERE TCK_ID = @TCK_ID;

            PRINT 'Track updated successfully.';
        END
        ELSE
        BEGIN
            PRINT 'Error: The provided new track name is already in use. Please choose a different track name.';
        END
    END
    ELSE
    BEGIN
        PRINT 'Error: Invalid TCK_ID. Track does not exist.';
    END
END;
----
EXEC UpdateTrack
@TCK_ID =11,
    @New_TCK_Name ='xx_END',
    @New_DEP_id =3;

select * from Training_Manager.Track 

	-----------Delete------------
	----------track--------
	CREATE PROCEDURE DeleteTrack
    @TCK_ID INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Check if TCK_ID exists
    IF EXISTS (SELECT 1 FROM Training_Manager.Track WHERE TCK_ID = @TCK_ID)
    BEGIN
        -- Delete the Track
        DELETE FROM Training_Manager.Track WHERE TCK_ID = @TCK_ID;
        PRINT 'Track deleted successfully.';
    END
    ELSE
    BEGIN
        PRINT 'Error: Track with specified TCK_ID does not exist.';
    END
END;

EXEC DeleteTrack
@TCK_ID = 11;
select * from Training_Manager.Track 
---*****************************************************************************
	---*****************************************************************************
	                                     ---------Intake----------
	-----------Insert--------------
	CREATE or Alter PROCEDURE InsertNewIntake
    @INT_Name NVARCHAR(30)
AS
BEGIN
    SET NOCOUNT ON;
	declare  @TR_id INT =(select t.TR_ID from [dbo].[Traning_Manager] t where t.TR_UserName =SUSER_NAME())

    -- Check if the provided INT_Name is not empty
    IF LEN(@INT_Name) = 0 OR @INT_Name IS NULL
    BEGIN
        PRINT 'Error: Intake name cannot be empty.';
        RETURN;
    END

    -- Insert new record into Intake table
    INSERT INTO Training_Manager.Intake (INT_Name, TR_id)
    VALUES (@INT_Name, @TR_id);

    PRINT 'New Intake added successfully.';
END;

EXEC InsertNewIntake
    @INT_Name = 'New Intake Name'

select * from Training_Manager.Intake

	----------update---------------
	---------Intake----------
	CREATE or alter PROCEDURE UpdateIntake
    @INT_ID INT,
    @New_INT_Name NVARCHAR(30)
   
AS
BEGIN
    SET NOCOUNT ON;

    -- Check if the provided New_INT_Name is not empty
    IF LEN(@New_INT_Name) = 0 OR @New_INT_Name IS NULL
    BEGIN
        PRINT 'Error: New Intake name cannot be empty.';
        RETURN;
    END

    
    -- Check if the specified INT_ID exists in the Intake table
    IF EXISTS (SELECT 1 FROM Training_Manager.Intake WHERE INT_ID = @INT_ID)
    BEGIN
        -- Check if the new intake name is unique (excluding the current intake being updated)
        IF NOT EXISTS (SELECT 1 FROM Training_Manager.Intake WHERE INT_Name = @New_INT_Name AND INT_ID <> @INT_ID)
        BEGIN
            -- Update the intake information
            UPDATE Training_Manager.Intake
            SET INT_Name = @New_INT_Name
            WHERE INT_ID = @INT_ID;

            PRINT 'Intake updated successfully.';
        END
        ELSE
        BEGIN
            PRINT 'Error: The provided new intake name is already in use. Please choose a different intake name.';
        END
    END
    ELSE
    BEGIN
        PRINT 'Error: Invalid INT_ID. Intake does not exist.';
    END
END;
---
exec UpdateIntake
 @INT_ID =6,
 @New_INT_Name = 'in2';

select * from Training_Manager.Intake

   ----------Delete---------------
	---------Intake----------
	CREATE PROCEDURE DeleteIntake
    @INT_ID INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Check if INT_ID exists
    IF EXISTS (SELECT 1 FROM Training_Manager.Intake WHERE INT_ID = @INT_ID)
    BEGIN
        -- Delete the Intake
        DELETE FROM Training_Manager.Intake WHERE INT_ID = @INT_ID;
        PRINT 'Intake deleted successfully.';
    END
    ELSE
    BEGIN
        PRINT 'Error: Intake with specified INT_ID does not exist.';
    END
END;
-------
exec DeleteIntake
 @INT_ID = 6;
 select * from Training_Manager.Intake

  	---*****************************************************************************
	---*****************************************************************************

	                             ---------Department----------
	-------------Insert------------
	CREATE or alter PROCEDURE InsertNewDepartment
    @DEP_Name NVARCHAR(30)
AS
BEGIN
    SET NOCOUNT ON;
	declare  @TR_id INT =(select t.TR_ID from [dbo].[Traning_Manager] t where t.TR_UserName =SUSER_NAME())

    -- Check if the provided DEP_Name is not empty
    IF LEN(@DEP_Name) = 0 OR @DEP_Name IS NULL
    BEGIN
        PRINT 'Error: Department name cannot be empty.';
        RETURN;
    END
    -- Insert new record into Department table
    INSERT INTO Training_Manager.Department (DEP_Name, TR_id)
    VALUES (@DEP_Name, @TR_id);
    PRINT 'New Department added successfully.';
END;
EXEC InsertNewDepartment
    @DEP_Name = 'New Department Namrre'
 select * from Training_Manager.Department

	---------Department----------
	-------------update------------
	CREATE or Alter PROCEDURE UpdateDepartment
    @DEP_ID INT,
    @New_DEP_Name NVARCHAR(30)
AS
BEGIN
    SET NOCOUNT ON;

    -- Check if the provided New_DEP_Name is not empty
    IF LEN(@New_DEP_Name) = 0 OR @New_DEP_Name IS NULL
    BEGIN
        PRINT 'Error: New Department name cannot be empty.';
        RETURN;
    END

    -- Check if the specified DEP_ID exists in the Department table
    IF EXISTS (SELECT 1 FROM Training_Manager.Department WHERE DEP_ID = @DEP_ID)
    BEGIN
        -- Check if the new department name is unique (excluding the current department being updated)
        IF NOT EXISTS (SELECT 1 FROM Training_Manager.Department WHERE DEP_Name = @New_DEP_Name AND DEP_ID <> @DEP_ID)
        BEGIN
            -- Update the department information
            UPDATE Training_Manager.Department
            SET DEP_Name = @New_DEP_Name
            WHERE DEP_ID = @DEP_ID;

            PRINT 'Department updated successfully.';
        END
        ELSE
        BEGIN
            PRINT 'Error: The provided new department name is already in use. Please choose a different department name.';
        END
    END
    ELSE
    BEGIN
        PRINT 'Error: Invalid DEP_ID. Department does not exist.';
    END
END;
EXEC UpdateDepartment
	@DEP_ID=6 ,
    @New_DEP_Name = 'DX'
  select * from Training_Manager.Department

	---------Department----------
	-------------Delete------------
	CREATE or Alter PROCEDURE DeleteDepartment
    @DEP_ID INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Check if DEP_ID exists
    IF EXISTS (SELECT 1 FROM Training_Manager.Department WHERE DEP_ID = @DEP_ID)
    BEGIN
        -- Delete the Department
        DELETE FROM Training_Manager.Department WHERE DEP_ID = @DEP_ID;
        PRINT 'Department deleted successfully.';
    END
    ELSE
    BEGIN
        PRINT 'Error: Department with specified DEP_ID does not exist.';
    END
END;
ExEc DeleteDepartment
 @DEP_ID = 6 ;

select * from Training_Manager.Department

---***********************************************************
 
 -----------------------------------------------------------------------------

----------------------------- student Show_Exam_Question proc
CREATE OR ALTER PROCEDURE Show_Exam_Question
    @Exam_Id INT
    
AS
BEGIN
    SET NOCOUNT ON;
	declare  @Student_ID INT= (select s.ST_ID from [Training_Manager].[Student] s where s.ST_UserName =SUSER_NAME() )
    IF NOT EXISTS (SELECT top 1 * FROM [Instructor].[Chosen_Student] WHERE CH_ST_ID = @Student_ID)
    BEGIN
        PRINT 'Not Exist Student Id..';
        RETURN;
    END

    IF NOT EXISTS (SELECT top  1 * FROM [Instructor].[Chosen_Student] WHERE CH_ST_EX_id = @Exam_Id)
    BEGIN
        PRINT 'Not Exist Exam Id..';
        RETURN;
    END

    IF NOT EXISTS (SELECT top 1 * FROM [Instructor].[Chosen_Student] WHERE CH_ST_EX_id = @Exam_Id AND CH_ST_ID = @Student_ID)
    BEGIN
        PRINT 'this Student did not selected to perform this Exam ';
        RETURN;
    END
    ELSE
    BEGIN
        DECLARE @IsDate NVARCHAR(5);

        SELECT @IsDate = 
            CASE 
                WHEN [Instructor].[Chosen_Student].EX_Date = CONVERT(DATE, GETDATE()) THEN 'True'
                ELSE 'False'
            END
        FROM [Instructor].[Chosen_Student]
        WHERE CH_ST_EX_id = @Exam_Id AND CH_ST_ID = @Student_ID;

        IF (@IsDate = 'False')
        BEGIN
            PRINT 'Is Exam Date Valid: ' + @IsDate;
            RETURN;
        END

        DECLARE @IsTimeValid NVARCHAR(5);

        SELECT @IsTimeValid = 
            CASE 
                WHEN CAST(GETDATE() AS TIME) BETWEEN [Instructor].[Exam].EX_Start_Time AND [Instructor].[Exam].EX_End_Time THEN 'True'
                ELSE 'False'
            END
        FROM [Instructor].[Exam]
        WHERE EX_ID = @Exam_Id;

        IF (@IsTimeValid = 'False')
        BEGIN
            PRINT 'Is Exam Time Valid: ' + @IsTimeValid;
            RETURN;
        END
    END
	select q.Q_ID,q.Q_Body ,Q_CH1 ,Q_CH2 ,Q_CH3 ,Q_CH4
	from [dbo].[Question] q , [dbo].[Exam_Has_Question]E
	where q.Q_ID =e.Question_ID and e.Exam_ID =35 and q.Q_Type = 'Multi'
	select q.Q_ID, q.Q_Body as 'T or F'
	from [dbo].[Question] q , [dbo].[Exam_Has_Question]E
	where q.Q_ID =e.Question_ID and e.Exam_ID =35  and q.Q_Type = 'T/F' 
	--where [dbo].[Exam_Has_Question].Exam_ID =@Exam_Id 
END;
exec Show_Exam_Question
@Exam_Id = 35

select CAST(GETDATE() AS date)
select * from  [Instructor].[Chosen_Student]
select * from [Instructor].[Exam] e where e.EX_ID =15
 --------------------------------------------------------------------

--- Sudent_Choose_Exam proc
CREATE OR ALTER PROCEDURE Sudent_Choose_Exam
    @STExam_Id INT
AS 
BEGIN
    SET NOCOUNT ON;
	declare  @STStudent_ID INT =(select s.ST_ID from [Training_Manager].[Student] s where s.ST_UserName =SUSER_NAME() )

    IF NOT EXISTS (SELECT 1 FROM [Instructor].[Chosen_Student] WHERE CH_ST_ID = @STStudent_ID)
    BEGIN
        PRINT'You are not choosen Student ..';
        RETURN;
    END

    IF NOT EXISTS (SELECT   1  FROM [Instructor].[Chosen_Student] WHERE CH_ST_EX_id = @STExam_Id)
    BEGIN
        PRINT 'Not Exist Exam Id..';
        RETURN;
    END

    DECLARE @IsDate NVARCHAR(5);

    SELECT @IsDate = 
        CASE 
            WHEN [Instructor].[Chosen_Student].EX_Date = CONVERT(DATE, GETDATE()) THEN 'True'
            ELSE 'False'
        END
    FROM [Instructor].[Chosen_Student]
    WHERE CH_ST_EX_id = @STExam_Id AND CH_ST_ID = @STStudent_ID;

    IF (@IsDate = 'False')
    BEGIN
        PRINT 'Is Exam Date Valid: ' + @IsDate;
        RETURN;
    END

    -- Assuming that Show_Exam_Question is a valid stored procedure

        exec Show_Exam_Question
						@Exam_Id = @STExam_Id
		 IF NOT EXISTS (SELECT   1  FROM [Student].[Student_Perform_Exam] x WHERE x.Exam_ID = @STExam_Id and x.Student_ID=@STStudent_ID)
		BEGIN
        	
			INSERT INTO Student.Student_Perform_Exam VALUES 
			( @STStudent_ID , @STExam_Id , NULL)
		END
END


exec Sudent_Choose_Exam
@STExam_Id = 35

select * from Student.Student_Perform_Exam 

select * from  [Student].[Student_Perform_Exam]

------------------------------------------------------------------
-----
------------Stuent_Set_Answer proc
Create or Alter PROCEDURE Stuent_Set_Answer
@Exam_Id INT,
@Q_ID int ,
@Answer varchar(5)
As 
Begin
SET NOCOUNT ON;
	declare @Student_ID INT= (select s.ST_ID from [Training_Manager].[Student] s where s.ST_UserName =SUSER_NAME() )
    IF NOT EXISTS (SELECT 1 FROM [Instructor].[Chosen_Student] WHERE CH_ST_ID = @Student_ID)
    BEGIN
        PRINT 'Not Exist Student Id..';
        RETURN;
    END
	
	----
    else IF NOT EXISTS (SELECT 1 FROM [Instructor].[Chosen_Student] WHERE CH_ST_EX_id = @Exam_Id)
    BEGIN
        PRINT 'Not Exist Exam Id..';
        RETURN;
    END
	---
	DECLARE @IsTimeValid NVARCHAR(5);

        SELECT @IsTimeValid = 
            CASE 
                WHEN CAST(GETDATE() AS TIME) BETWEEN [Instructor].[Exam].EX_Start_Time AND [Instructor].[Exam].EX_End_Time THEN 'True'
                ELSE 'False'
            END
        FROM [Instructor].[Exam]
        WHERE EX_ID = @Exam_Id;

        IF (@IsTimeValid = 'False')
        BEGIN
            PRINT 'Is Exam Time Valid: ' + @IsTimeValid;
            RETURN;
        END
		---
		DECLARE @IsDefiend NVARCHAR(5);

        SELECT @IsDefiend = 
            CASE 
                WHEN @Q_ID =[dbo].[Exam_Has_Question].Question_ID  AND @Exam_Id = [dbo].[Exam_Has_Question].Exam_ID THEN 'True'
                ELSE 'False'
            END
        FROM [dbo].[Exam_Has_Question]
        WHERE [dbo].[Exam_Has_Question].Question_ID = @Q_ID and [dbo].[Exam_Has_Question].Exam_ID = @Exam_Id;

        IF (@IsTimeValid = 'False')
        BEGIN
            PRINT 'ExamID or QID Defiend: ' + @IsTimeValid;
            RETURN;
        END
		

		----
		DECLARE @IsCorrect bit

	SELECT @IsCorrect = 
		 CASE 
		   WHEN @Answer = Q.Q_Correct_Answer THEN 1
		  ELSE 0
	 END
	FROM [dbo].[Question] AS Q
	WHERE Q.Q_ID = @Q_ID;
		 IF NOT EXISTS (SELECT   1  FROM Student_Answer a WHERE a.Stu_Q_Exam_ID= @Exam_Id and a.StuPerEX_Student_ID=@Student_ID and  a.ExHasQ_Question_ID=@Q_ID)
			BEGIN
				insert into Student_Answer 
				values (@Student_ID ,@Exam_Id,@Q_ID,@Answer,@IsCorrect );
			end 
		else 
			begin 
				print ' you have been already answered this Question , you can not update your Answer .'
			end 
		exec Show_Exam_Question
						@Exam_Id = @Exam_Id
End


exec Stuent_Set_Answer
@Exam_Id = 35,
@Q_ID = 66,
@Answer = B

select * from Student_Answer s where s.Stu_Q_Exam_ID=35 order by s.StuPerEX_Student_ID desc

exec Sudent_Choose_Exam
@STExam_Id = 35,
@STStudent_ID = 3;
select * from [dbo].[Question]q where q.Q_ID=36
select * from [Student].[Student_Perform_Exam] x where x.Exam_ID=35
select *  from [dbo].[Exam_Has_Question] h where h.Exam_ID=35

-------------------------------------------------------------------------------- Abdelrahman Gomaa Proc 
--Create Stored Proc For [dbo].[Instructor] Table Do What After ..............

--First Add Instructor............................................................. 

CREATE OR ALTER PROC Add_New_Instrctor_proc (@ins_name NVARCHAR(50) , @ins_Age INT , 
@ins_adress NVARCHAR(50) , @ins_personal_data NVARCHAR(50))
AS
BEGIN TRY 
    DECLARE @add_ins NVARCHAR(50)
    SET @add_ins = (SELECT COUNT(*) FROM [dbo].[Instructor])+1
	--Add Chek for user exist or not 
    INSERT INTO [dbo].[Instructor]
    VALUES ( @ins_name , @ins_Age , @ins_adress , @ins_personal_data ,null)
	 update  [dbo].[Instructor]
	 set [INS_UserName] =('Ins'+ cast((select top 1 [INS_ID] from [dbo].[Instructor] order by [INS_ID] desc)  as nvarchar(10) ))
	 where [INS_ID]=(select top 1 [INS_ID] from [dbo].[Instructor] order by [INS_ID] desc)
    SELECT CONCAT('Instructor is Added Succesfully,He Name is :' , @ins_name ) AS NewConstructor 
	SELECT * FROM [dbo].[Instructor]
END TRY
BEGIN CATCH
    SELECT ('The User Name Is frequent , Can You Try Again') , ERROR_MESSAGE(), ERROR_LINE();   
END CATCH 

EXECUTE  Add_New_Instrctor_proc @ins_name = 'Ahmed' , @ins_Age = 50 ,@ins_adress = 'Mansoura' ,@ins_personal_data = 'Single' 

--Scond Update Instructor ...............................................................

CREATE OR ALTER PROC update_Instrctor_proc (@ins_id INT , @ins_name NVARCHAR(50) , @ins_Age INT , 
@ins_adress NVARCHAR(50) , @ins_personal_data NVARCHAR(50) , @ins_username NVARCHAR(50))
AS
BEGIN TRY 
   IF (@ins_Age >= 25 AND @ins_username LIKE 'Ins%')
   BEGIN
    UPDATE Instructor
    SET  INS_Name = @ins_name , INS_Age = @ins_Age , INS_Address = @ins_adress ,
	INS_PersonalData = @ins_personal_data , INS_UserName = @ins_username 
	WHERE  INS_ID = @ins_id
	END
	 SELECT CONCAT('Instructor is Update Succesfully,He Name is :' , @ins_name , 'And User Name is :' , @ins_username ) AS UpdateConstructor 
	 SELECT * FROM [dbo].[Instructor]
END TRY
BEGIN CATCH
    SELECT ('The User Name Not Start With Ins or Age Less Than 20 Or The User Name Is frequent , Can You Try Again') , ERROR_MESSAGE(), ERROR_LINE();   
END CATCH 

EXECUTE update_Instrctor_proc @ins_id= 1,@ins_name = 'Ahmed' , @ins_Age = 50 ,@ins_adress = 'Mansoura' ,@ins_personal_data = 'Single' ,@ins_username = 'Ins1'


--Therd Delete Instructor ...............................................................

CREATE OR ALTER PROC remove_Instrctor_proc (@ins_id INT )
AS
BEGIN TRY 
    DECLARE @delete_ins NVARCHAR(50)
    SET @delete_ins = (SELECT COUNT(*) FROM [dbo].[Instructor])-1
	DELETE [Instructor].[Chosen_Student]
    WHERE INS_id = @ins_id
    DELETE [dbo].[Instructor]
	WHERE INS_ID = @ins_id 

END TRY
BEGIN CATCH
    SELECT ('The User Name Not Found , Can You Try Again') , ERROR_MESSAGE(), ERROR_LINE();   
END CATCH 

EXECUTE remove_Instrctor_proc @ins_id= 8
 select * from [dbo].[Instructor]

--Create Stored Proc For [dbo].[Course] Table Do What After ..............
--First Add Course ............................

CREATE OR ALTER PROC Add_New_Course_proc (@c_name NVARCHAR(50) , @c_description NVARCHAR(100) , @c_min_degree FLOAT , @c_max_degree FLOAT , @inst_id INT)

AS
BEGIN TRY 
    IF(@inst_id != 0 AND @c_min_degree > 50 AND @c_max_degree = 100)          --Add Check Instructor 
	BEGIN 
      DECLARE @add_Course NVARCHAR(100)
      SET @add_Course = (SELECT COUNT(*) FROM [dbo].[Instructor])+1
	END
    INSERT INTO [dbo].[Course]
    VALUES ( @c_name , @c_description , @c_min_degree , @c_max_degree ,@inst_id)
    SELECT CONCAT('Course Added Succesfully, Name is :' , @c_name, 'And Instructor id What Tech is :' , @inst_id) AS NewCourse
	SELECT * FROM [dbo].[Course]
END TRY
BEGIN CATCH
    SELECT ('The min_degree Less than 50 or max_degree greater than 100 , Try Again') , ERROR_MESSAGE(), ERROR_LINE();   
END CATCH 

EXECUTE Add_New_Course_proc @c_name = 'Javascript' , @c_description = 'Advanced mathematical principles for engineering.',
@c_min_degree = 60 , @c_max_degree  = 100 , @inst_id = 2

--Scond Update Course ............................
CREATE OR ALTER PROC update_Course_proc (@c_id INT , @c_name NVARCHAR(50) , @c_description NVARCHAR(100) , @c_min_degree FLOAT , @c_max_degree FLOAT , @inst_id INT)

AS
  BEGIN TRY 
   IF (@inst_id != 0 AND @c_min_degree > 50 AND @c_max_degree < 50)   --Add Check Instructor 
   BEGIN
    UPDATE [dbo].[Course]
    SET  C_Name = @c_name  , C_Description = @c_description , 
	C_Min_Degree = @c_min_degree , C_Max_Degree = @c_max_degree , Inst_Id = @inst_id
	WHERE C_ID = @c_id 
    SELECT CONCAT('Course Update Succesfully, Name is :' , @c_name, 'And Instructor id What Tech is :' , @inst_id) AS RempveCourse
	SELECT * FROM [dbo].[Course]
	END
  END TRY
BEGIN CATCH
    SELECT ('The Inst_Is OR C_ID Not Found  , Can You Try Again') , ERROR_MESSAGE(), ERROR_LINE();   
END CATCH 

EXECUTE update_Course_proc @c_id = 7, @c_name = 'Java' , @c_description = 'Advanced mathematical principles for engineering.',
@c_min_degree = 60.8 , @c_max_degree  = 99.9 , @inst_id = 4

--Third Delete .........................................................
CREATE OR ALTER PROC delete_Course_proc (@c_id INT , @c_name NVARCHAR(50) , @inst_id INT)

AS
  BEGIN TRY 
   IF (@inst_id != 0)
   BEGIN
    DECLARE @delete_Course NVARCHAR(50)
    SET @delete_Course = (SELECT COUNT(*) FROM [dbo].[Instructor])-1
    DELETE [Student].[Student_Takes_Course]
    WHERE Cour_ID = @c_id
    DELETE [dbo].[Course]
	WHERE C_ID = @c_id AND Inst_Id = @inst_id
    SELECT CONCAT('Course Update Succesfully, Name is :' , @c_name, 'And Instructor id What Tech is :' , @inst_id) AS RempveCourse
	SELECT * FROM [dbo].[Course]
	END
  END TRY
BEGIN CATCH
    SELECT ('The Inst_Is OR C_ID Not Found  , Can You Try Again') , ERROR_MESSAGE(), ERROR_LINE();   
END CATCH     

EXECUTE delete_Course_proc @c_id = 9, @c_name = 'Java' ,  @inst_id = 2     


--Create Stored Proc For[dbo].[Question]Table Do What After ..............
--First Add Question .................................................

CREATE OR ALTER PROC Add_New_Question_proc (@q_type NVARCHAR(20),@q_body NVARCHAR(200) ,@q_corr_answer NVARCHAR(10) ,
@q_ch1 NVARCHAR(20) , @q_ch2 NVARCHAR(20), @q_ch3 NVARCHAR(20), @q_ch4 NVARCHAR(20) , @cours_id INT)             --Add Constraint on course_id 

AS
BEGIN TRY 
    DECLARE @add_Question NVARCHAR(100)
    SET @add_Question = (SELECT COUNT(*) FROM [dbo].[Instructor])+1
    INSERT INTO [dbo].[Question]
    VALUES (@q_type , @q_body , @q_corr_answer , @q_ch1 ,@q_ch2 ,@q_ch3 , @q_ch4 ,@cours_id)
    SELECT CONCAT('Question Added Succesfully, Name is :' , @q_body, 'And Course_id is :' ,  @cours_id ) AS NewQuestion
	SELECT * FROM [dbo].[Question]
END TRY
BEGIN CATCH
    SELECT ('No Added , Try Again') , ERROR_MESSAGE(), ERROR_LINE();   
END CATCH 

EXECUTE Add_New_Question_proc @q_type = 'Multi' , @q_body = 'What is the capital of France?',
@q_corr_answer = 'A' , @q_ch1  = 'A-C', @q_ch2 = 'B-Paris' , @q_ch3 = 'C-Berlin' , @q_ch4 = 'D-London' , @cours_id = 8

--Scond Update Question .................................................
CREATE OR ALTER PROC update_Question_proc (@q_id INT , @q_type NVARCHAR(20),@q_body NVARCHAR(200) ,@q_corr_answer NVARCHAR(10) ,
@q_ch1 NVARCHAR(20) , @q_ch2 NVARCHAR(20), @q_ch3 NVARCHAR(20), @q_ch4 NVARCHAR(20) , @cours_id INT)

AS
BEGIN TRY 
    UPDATE [dbo].[Question]
    SET Q_Type = @q_type , Q_Body = @q_body , Q_Correct_Answer = @q_corr_answer ,
	Q_CH1 = @q_ch1 , Q_CH2 = @q_ch2 ,Q_CH3 = @q_ch3 ,Q_CH4 = @q_ch4 ,Cour_Id = @cours_id
	WHERE Q_ID = @q_id ;
    SELECT CONCAT('Question Update Succesfully, Name is :' , @q_body, 'And Course_id is :' ,  @cours_id ) AS NewQuestion
	SELECT * FROM [dbo].[Question]
END TRY
BEGIN CATCH
    SELECT ('No Update , Try Again') , ERROR_MESSAGE(), ERROR_LINE();   
END CATCH 

EXECUTE update_Question_proc @q_id = 80 , @q_type = 'T/F' , @q_body = 'The currency used in Switzerland is the Euro.',
@q_corr_answer = 'F' , @q_ch1  = NULL, @q_ch2 = NULL , @q_ch3 = NULL , @q_ch4 = NULL , @cours_id = 8

--Third delete Question .................................................

CREATE OR ALTER PROC delete_Question_proc (@q_id INT )
AS
BEGIN TRY 
    DELETE [dbo].[Question]
	WHERE Q_ID = @q_id ;    
   
END TRY
BEGIN CATCH
    SELECT ('No Update , Try Again') , ERROR_MESSAGE(), ERROR_LINE();   
END CATCH  --Add Qi_Exam Hase Question

EXECUTE delete_Question_proc @q_id = 80

select * from [dbo].[Question] q order by q.Q_ID desc
-----------------------------------------------------------
--Create Proc Take Id from Instructor And Return Data Of Course And Instrctor 

  CREATE OR ALTER PROC get_Instructor_Data @id_Ins INT 
AS
BEGIN
    BEGIN TRY 
        IF EXISTS (
            SELECT *
            FROM [dbo].[Instructor] AS i
            WHERE i.INS_ID = @id_Ins 
        )
        BEGIN
            --The Select if my condation Right if the condition exists
            SELECT INS_Name , INS_PersonalData , INS_UserName , C_Name
            FROM [dbo].[Instructor] AS i
            JOIN [dbo].[Course] AS c ON i.INS_ID = c.Inst_Id
            WHERE i.INS_ID = @id_Ins AND @id_Ins != 0
			ORDER BY C_Name
        END
        ELSE
        BEGIN
            --The Select if my condation Rong if the condition exists
            THROW 5000, 'The Inst_Is  Not Found. Please try again.', 1;
        end 
    END TRY 

    BEGIN CATCH
        --  logic for catching and handling errors
        SELECT ERROR_MESSAGE() AS ErrorMessage, ERROR_LINE() AS ErrorLine;
    END CATCH 
END;

EXECUTE get_Instructor_Data @id_Ins = 7; 

--Create Proc Take Id from Student And Return Data Of Course And Instrctor 
 CREATE OR ALTER PROC get_Student_Data @id_Student INT 
AS
BEGIN
    BEGIN TRY 
        IF EXISTS (
		              SELECT * 
                      FROM [Training_Manager].[Student] AS TMStudent
					  WHERE TMStudent.ST_ID = @id_Student

                    )
        BEGIN
            --The Select if my condation Right if the condition exists
                      SELECT TMStudent.ST_Name , TMStudent.ST_Personal_Data ,TMStudent.ST_Address , 
					  TMStudent.ST_Age , TMStudent.ST_UserName ,C_Name , BR_Name    
                      FROM [Training_Manager].[Student] AS TMStudent
                      INNER JOIN [Student].[Student_Takes_Course] AS StudentCourse
                      ON TMStudent.ST_ID = StudentCourse.St_ID
                      INNER JOIN [dbo].[Course]
                      ON C_ID = StudentCourse.Cour_ID 
					  INNER JOIN [Training_Manager].[Branch] AS TMBranch
					  ON TMStudent.ST_BR_id = TMBranch.BR_ID
					  WHERE TMStudent.ST_ID = @id_Student 
        END
        ELSE
        BEGIN
            --The Select if my condation Rong if the condition exists
            THROW 5000, 'The Student_Is Not Found. Please try again.', 1;
        END
    END TRY 

    BEGIN CATCH
        -- Your logic for catching and handling errors
        SELECT ERROR_MESSAGE() AS ErrorMessage, ERROR_LINE() AS ErrorLine;
    END CATCH 
END;

EXECUTE get_Student_Data @id_Student = 20; 

select * from [Training_Manager].[Student]
--Create Proc For Show Exame And Degree From Student Id 
CREATE OR ALTER PROC get_ExAndDegree @student_Id INT 
AS
BEGIN
    BEGIN TRY 
        IF EXISTS (
		              SELECT *
					  FROM [Training_Manager].[Student] 

                    )
        BEGIN

            --The Select if my condation Right if the condition exists 
                      SELECT s.ST_Name  , ex.EX_ID, ex.EX_Type , spe.Total_Result , c.C_Name
					  FROM [Training_Manager].[Student] s
					  INNER JOIN [Student].[Student_Perform_Exam] spe
					  ON ST_ID = Student_ID
					  INNER JOIN [Instructor].[Exam] ex
					  ON EX_ID = Exam_ID
					  INNER JOIN [dbo].[Course] c
					  ON ex.Cour_Id = c.C_ID
					  WHERE ST_ID = @student_Id
			

        END
        ELSE
        BEGIN
            --The Select if my condation Rong if the condition exists
            THROW 5000, 'The Student_Is Not Found. Please try again.', 1;
        END
    END TRY 

    BEGIN CATCH
        -- Your logic for catching and handling errors
        SELECT ERROR_MESSAGE() AS ErrorMessage, ERROR_LINE() AS ErrorLine;
    END CATCH 
END;

EXECUTE get_ExAndDegree @student_Id = 21


--Add Course Name ...........................................................................
--Create Proc For Show Data Of Exam From ExameId     
CREATE OR ALTER PROC get_ExData @Ex_id INT 
AS
BEGIN
    BEGIN TRY 
        IF EXISTS (
		              SELECT *
					  FROM [Instructor].[Exam] ex
                    )
        BEGIN
            --The Select if my condation Right if the condition exists
                      SELECT ex.EX_ID, ex.EX_Type, ex.EX_Start_Time , ex.EX_End_Time , ex.EX_total_Time , ex.EX_Year ,c.C_Name
					  FROM [Instructor].[Exam] ex , [dbo].[Course] c
					  WHERE ex.Cour_Id = c.C_ID AND EX_ID = @Ex_id
					
            END
          ELSE
        BEGIN
		
            --The Select if my condation Rong if the condition exists
            THROW 5000, 'The ExamId Not Found. Please try again.', 1;
        END
    END TRY 

    BEGIN CATCH
        -- Your logic for catching and handling errors
        SELECT ERROR_MESSAGE() AS ErrorMessage, ERROR_LINE() AS ErrorLine;
    END CATCH 
END;

EXECUTE get_ExData @Ex_id = 6
 select * from [Instructor].[Exam]


