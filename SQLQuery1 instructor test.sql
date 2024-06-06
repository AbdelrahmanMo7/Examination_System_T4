 
 -- his data 
 select * from [dbo].[show_Instractor_Data_View]
 -- his courses
 select * from [dbo].[Show_Course_Data_For_Instractoer_View]
 -- all chosen students 
 select * from [dbo].[Show_All_Chosen_Student_VIEW]
 ---- students grade
 select * from [dbo].[Show_All_Student_ExamsGrade_View]
 ----add Exam 
 exec [dbo].[Add_New_Exam_withRandomQuestion_Proc] @exam_type='Exam', @start_time='10:50:00' ,@end_time= '20:50:00' ,@year=2222,
													@multi_Q_num =1,@multi_Q_degree =20,@t_f_Q_num=1,@t_f_Q_degree =30,@allawnece =1 ,
													@course_id= 11, @track_id =4,@intake_id =3,@branch_id =3

--- get exam  data
exec [dbo].[get_ExData] 35


  
--- select student to exam 

exec [dbo].[select_Exam_to_Student_Proc]  @student_id= 21 ,@exam_id=35 ,@exam_date='2024-01-14' ,@ChosenOrNot=1

-- 
