CREATE DATABASE CourseEnrollment
GO
USE CourseEnrollment
GO
create table tutors 
(
	tutorid int identity primary key,
	tutorname nvarchar(40) not null,
	tutoremail nvarchar(40) not null,
	tutorphone nvarchar(20) not null
)
GO
create table students
(
	studentid int identity primary key,
	studentname nvarchar(40) not null,
	studentemail nvarchar(40) not null,
	studentphone nvarchar(20) not null
)
GO
create table courses 
(
	courseid int identity primary key,
	coursename nvarchar(40) not null,
	duraioninweek int not null,
	fee money not null,
	tutorid int not null references tutors (tutorid)
)
go
create table enrollments
(
	studentid int not null references students(studentid),
	courseid int not null references courses(courseid),
	enrolldate date not null,
	paymentdate date  null,
	primary key (studentid, courseid)
)
GO
--Insert procedures
/*******************************************************/
--table tutors
create proc inserttutor @tutorname nvarchar(40),
				@tutoremail nvarchar(40),
				@tutorphone nvarchar(20)
as
declare @err nvarchar(200)
begin try
	insert into tutors (tutorname, tutoremail, tutorphone)
	values (@tutorname, @tutoremail, @tutorphone)
end try
begin catch
	set @err = ERROR_MESSAGE()
	raiserror(@err, 16, 1)
	return
end catch
go
--table courses
create proc insertcourse @coursename nvarchar(40),
				@duraioninweek int,
				@fee money,
				@tutorid int
as
declare @err nvarchar(200)
begin try
	insert into courses(coursename, duraioninweek, fee, tutorid)
	values (@coursename, @duraioninweek, @fee, @tutorid)
end try
begin catch
	set @err = ERROR_MESSAGE()
	raiserror(@err, 16, 1)
	return
end catch
go
--table student
create proc insertstudent @studentname nvarchar(40),
						@studentemail nvarchar(40) ,
					@studentphone nvarchar(20) 
as
declare @err nvarchar(200)
begin try
	insert into students(studentname, studentemail, studentphone)
	values (@studentname, @studentemail, @studentphone)
end try
begin catch
	set @err = ERROR_MESSAGE()
	raiserror(@err, 16, 1)
	return
end catch
go
--table ennrollments
create proc insertenrollment @studentid int ,
				@courseid int ,
				@enrolldate date ,
				@paymentdate date = null
as
declare @err nvarchar(200)
begin try
	insert into enrollments(studentid, courseid, enrolldate, paymentdate)
	values (@studentid, @courseid, @enrolldate, @paymentdate)
end try
begin catch
	set @err = ERROR_MESSAGE()
	raiserror(@err, 16, 1)
	return
end catch
go
--
--update procedures
/**********************************************/
--table tutors
create proc updatetutor 
				@tutorid INT,
				@tutorname nvarchar(40) = null,
				@tutoremail nvarchar(40) = null,
				@tutorphone nvarchar(20) = null
as
declare @err nvarchar(200)
begin try
	update tutors SET tutorname=ISNULL(@tutorname, tutorname), 
					tutoremail=ISNULL(@tutoremail, tutoremail), 
					tutorphone=ISNULL(@tutorphone,tutorphone)
	where tutorid=@tutorid
end try
begin catch
	set @err = ERROR_MESSAGE()
	raiserror(@err, 16, 1)
	return
end catch
go
--table courses
create proc updatecourse 
				@courseid INT,
				@coursename nvarchar(40)=NULL,
				@duraioninweek int=null,
				@fee money=null,
				@tutorid int
as
declare @err nvarchar(200)
begin try
	update courses 
	SET
		coursename=ISNULL(@coursename,coursename), 
		duraioninweek=ISNULL(@duraioninweek,duraioninweek), 
		fee=ISNULL(@fee, fee), 
		tutorid=ISNULL(@tutorid,tutorid)
	where courseid=@courseid 
end try
begin catch
	set @err = ERROR_MESSAGE()
	raiserror(@err, 16, 1)
	return
end catch
go
--table students
create proc updatestudent 
					@studentid int,
					@studentname nvarchar(40)=null,
					@studentemail nvarchar(40)=null ,
					@studentphone nvarchar(20)=null 
as
declare @err nvarchar(200)
	begin try
		update students set 
		studentname=isnull(@studentname, studentname), 
		studentemail=isnull(@studentemail,studentemail), 
		studentphone= isnull(@studentphone,studentphone)
	where studentid=@studentid
end try
begin catch
	set @err = ERROR_MESSAGE()
	raiserror(@err, 16, 1)
	return
end catch
go
--table enrollments
create proc updateenrollment 
				@studentid int ,
				@courseid int ,
				@enrolldate date =null,
				@paymentdate date =null
as
declare @err nvarchar(200)
begin try
		update  enrollments 
		set 
			enrolldate=isnull(@enrolldate, enrolldate), 
			paymentdate=isnull(@paymentdate,paymentdate)
		where  studentid=@studentid and  courseid=@courseid
end try
begin catch
	set @err = ERROR_MESSAGE()
	raiserror(@err, 16, 1)
	return
end catch
go
--delete procedure
/**************************************/
--table tutors
create proc deletetutor @tutorid int
as
declare @err nvarchar(200)
begin try
		delete  tutors 
		where  tutorid=@tutorid
end try
begin catch
	set @err = ERROR_MESSAGE()
	;
	throw  50001, @err, 1
	return
end catch
go
--table courses
create proc deletecourse @courseid int
as
declare @err nvarchar(200)
begin try
		delete  courses 
		where  courseid=@courseid
end try
begin catch
	set @err = ERROR_MESSAGE()
	;
	throw  50001, @err, 1
	return
end catch
go
--table students
create proc deletestudent @studentid int
as
declare @err nvarchar(200)
begin try
		delete  students 
		where  studentid=@studentid
end try
begin catch
	set @err = ERROR_MESSAGE()
	;
	throw  50001, @err, 1
	return
end catch
go
--table enrollments
create proc deleteenrollment @studentid int, @courseid int
as
declare @err nvarchar(200)
begin try
		delete  enrollments 
		where  studentid=@studentid and courseid=@courseid
end try
begin catch
	set @err = ERROR_MESSAGE()
	;
	throw  50001, @err, 1
	return
end catch
go
---views
/***********************************************/
--Shows all information
create view vcoursestudents
AS
select c.coursename, t.tutorname, c.duraioninweek, c.fee, s.studentname, e.enrolldate, e.paymentdate
from courses c
inner join enrollments e on c.courseid = e.courseid
inner join students s on e.studentid = s.studentid
inner join tutors t on c.tutorid = t.tutorid
GO
--aggregate
create view coursewisestudentsaggregate
as
select c.coursename, count(s.studentid) 'studentcount', sum(c.fee) 'totalrecieved'
from courses c
inner join enrollments e on c.courseid = e.courseid
inner join students s on e.studentid = s.studentid
inner join tutors t on c.tutorid = t.tutorid
group by c.coursename
go
--group
create view coursesummarybytutor
as
select t.tutorname, count(c.courseid) 'coursecount'
from courses c
inner join tutors t on c.tutorid = t.tutorid
group by t.tutorname
go
--UDF
/********************************************/
--scalar udf
/*-----------*/
--students count of a specific course
create function fnstudentcount(@courseid int) returns int
as
begin
	declare @c int
	select @c= count(s.studentid)
	from courses c
	inner join enrollments e on c.courseid = e.courseid
	inner join students s on e.studentid = s.studentid
	where c.courseid = @courseid
	return @c
end 
go
-- total payment amount of certain course
create function fntotalamount(@courseid int) returns money
as
begin
	declare @amount money
	select @amount=sum(c.fee)
	from courses c
	inner join enrollments e on c.courseid = e.courseid
	inner join students s on e.studentid = s.studentid
	where c.courseid = @courseid
	having count(s.studentid)>0
	return @amount
end
go
--table-valued udf
/*---------------------*/
--combined information of a course
create function fncourseinfo (@courseid int) returns table
as
return
(
	select c.coursename, t.tutorname, c.duraioninweek, c.fee, s.studentname, e.enrolldate, e.paymentdate
	from courses c
	inner join enrollments e on c.courseid = e.courseid
	inner join students s on e.studentid = s.studentid
	inner join tutors t on c.tutorid = t.tutorid
	where c.courseid = @courseid
)
go
--Multi statement UDF
--Agregate view
create function fncourseaggregate(@courseid int)
	returns @tbl TABLE (studentcount int, totalrecieved money)
as
begin
	insert into @tbl
	select count(s.studentid) 'studentcount', sum(c.fee) 'totalrecieved'
	from courses c
	inner join enrollments e on c.courseid = e.courseid
	inner join students s on e.studentid = s.studentid
	inner join tutors t on c.tutorid = t.tutorid
	where c.courseid = @courseid

	return
end
go
--Triggers
/********************************************/
--Insert trigger on enrollment
create trigger trinsertenroll
on enrollments
instead of insert
as
begin
	declare @ed date, --enrolldate
			@pd date --paymentdate
	select @ed =enrolldate, @pd = paymentdate
	from inserted
	if cast(@pd as date) < cast(@ed as date) --paymentdate cannot be < enrolldate
	begin
		raiserror('Invalid payment date', 16, 1)
		return
	end
	--all ok, insert 
	insert into enrollments 
	select * from inserted
end
go
--update trigger on enrollment
create trigger trupdateenroll
on enrollments
for update
as
begin
	declare @ed date, --enrolldate
			@pd date --paymentdate
	select @ed =enrolldate, @pd = paymentdate
	from inserted
	if cast(@pd as date) < cast(@ed as date) --paymentdate cannot be < enrolldate
	begin
		rollback tran
		raiserror('Invalid payment date', 16, 1)
		return
	end
	
end
go
--delete trigger on enroll
create trigger trdeleteenroll
on enrollments
instead of delete
as
begin
	declare @pd date, --paymentdate
			@csid int, --course id,
			@stid int --student id
	select  @pd = paymentdate, @csid=courseid, @stid=studentid
	from deleted
	if @pd is not null --student has paid for the course
	begin
		
		raiserror('Cannot delete. Student aleady has paid', 16, 1)
		return
	end
	--ok
	delete 
	from enrollments 
	where courseid = @csid and studentid =@stid
	
	
end
go

