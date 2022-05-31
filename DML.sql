USE CourseEnrollment
GO
--Test insert procedure
/*************************************/
exec inserttutor @tutorname = "Manik mia",
				@tutoremail = "manik11@gmail.com",
				@tutorphone ="01719220112"
exec inserttutor @tutorname = "Munaim sarker",
				@tutoremail = "munaim14@gmail.com",
				@tutorphone ="01339090522"
exec inserttutor @tutorname = "sakib sarker",
				@tutoremail = "sakib@gmail.com",
				@tutorphone ="01715000111"
exec inserttutor @tutorname = "Abdur rahman",
				@tutoremail = "abdurrahman789@gmail.com",
				@tutorphone ="01919030141"
exec inserttutor @tutorname = "Asib mustakim",
				@tutoremail = "asibmustakim45@gmail.com",
				@tutorphone ="01619012411"
GO
select * from tutors
GO
EXEC insertcourse @coursename ='SQL',
				@duraioninweek =4,
				@fee =4500.00,
				@tutorid =3
EXEC insertcourse @coursename ='C#',
				@duraioninweek =5,
				@fee =5000.00,
				@tutorid =1
EXEC insertcourse @coursename ='HTML CSS',
				@duraioninweek =3,
				@fee =2500.00,
				@tutorid =2
EXEC insertcourse @coursename ='ASP.NET Core',
				@duraioninweek =5,
				@fee =4500.00,
				@tutorid =4
EXEC insertcourse @coursename ='Photoshop',
				@duraioninweek =4,
				@fee =4500.00,
				@tutorid =5
GO
SELECT * FROM courses
GO
EXEC insertstudent @studentname ='Shohel khan',
					@studentemail ='shohelkhan4@yahoo.com' ,
					@studentphone ='01345821212'
EXEC insertstudent @studentname ='Bulbul Hossain',
					@studentemail ='bulbul@yahoo.com' ,
					@studentphone ='01766212121' 
EXEC insertstudent @studentname ='Riad mia',
					@studentemail ='riadmia@yahoo.com' ,
					@studentphone ='01966919191' 
EXEC insertstudent @studentname ='Maruf Hossain',
					@studentemail ='maruf@yahoo.com' ,
					@studentphone ='01666121212' 
EXEC insertstudent @studentname ='Yusuf Ali',
					@studentemail ='yusuf@yahoo.com' ,
					@studentphone ='01766009911' 
EXEC insertstudent @studentname ='Tokir alam',
					@studentemail ='alam456@yahoo.com' ,
					@studentphone ='01766888888' 
GO
SELECT * FROM students
GO
exec  insertenrollment @studentid =1,
				@courseid = 3 ,
				@enrolldate ='2021-06-03' ,
				@paymentdate ='2021-06-03'
exec  insertenrollment @studentid =2,
				@courseid = 3 ,
				@enrolldate ='2021-06-03' 
			
exec  insertenrollment @studentid =3,
				@courseid = 1 ,
				@enrolldate ='2021-06-05' ,
				@paymentdate ='2021-06-05'
exec  insertenrollment @studentid =4,
				@courseid = 1 ,
				@enrolldate ='2021-06-03' ,
				@paymentdate ='2021-06-03'
exec  insertenrollment @studentid =5,
				@courseid = 2 ,
				@enrolldate ='2021-06-03' ,
				@paymentdate ='2021-06-03'
GO
select * from enrollments
GO
--Test update procedure
/*************************************/

--Test delete procedure
/*************************************/

--Test views
/**************************************************/
select * from vcoursestudents
go
select * from coursewisestudentsaggregate
go
select * from coursesummarybytutor
go
--Test UDF
/***************************************************/
--1
select dbo.fnstudentcount(1)
go
select dbo.fnstudentcount(2)
go
--2
select dbo.fntotalamount(1)
go
select dbo.fntotalamount(2)
go
select dbo.fntotalamount(3)
go
--3
select * from fncourseinfo(1)
go
select * from fncourseinfo(2)
go
select * from fncourseinfo(3)
go
--4
select * from fncourseaggregate(1)
go
select * from fncourseaggregate(2)
go
select * from fncourseaggregate(3)
go
--Test triggers
/***************************************************/
--insert enroll
select * from enrollments
go
exec  insertenrollment @studentid =5,
				@courseid = 1 ,
				@enrolldate ='2021-06-03' ,
				@paymentdate ='2021-06-02'
--insert  rejected
go
select * from enrollments
go
exec  insertenrollment @studentid =5,
				@courseid = 1 ,
				@enrolldate ='2021-06-03' ,
				@paymentdate ='2021-06-04'
--insert  ok
go
select * from enrollments
go
--delete enroll
select * from enrollments
go
exec deleteenrollment @studentid =2, @courseid =3
--delete ok
go
select * from enrollments
go
exec deleteenrollment @studentid =1, @courseid =3
--reject, shows error
go
select * from enrollments
go