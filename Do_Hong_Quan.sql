create database t2202e_Practical;
use t2202e_Practical;
--1.Create the tables to the above designing
create table Books(
	BookID int identity(100,1),
	Title nvarchar(200),
	Author nvarchar(100),
	ISBN nvarchar(50),
	Image varchar(150),
	Summary nvarchar(300),
	primary key (BookID),

);
create table Users(
	UserID varchar(20)  ,
	FullName nvarchar(100),
	Email varchar(30) unique,
	Address nvarchar(200),
	primary key (UserID)

);
create table Loans (
	LoanID int identity,
	UserID varchar(20),
	BookID int,
	DueDate datetime,
	Created datetime not null default current_timestamp,
	Modofied datetime,
	primary key (LoanID),
	foreign key(UserID) references Users(UserID),
	foreign key(BookID) references Books(BookID)

);
--2.Create an unique constraint named UQ_Books_ISBN on ISBN column on Books 
alter table Books add constraint UQ_Books_ISBN unique(ISBN);
--3.Insert into above tables at least 3 records per table.
insert into Books(Title, Author, ISBN,Image,Summary )
values (N'Sach1', N'tg1', 'ISBN1','url1',N'kể về 1' ),
		(N'Sach2', N'tg2', 'ISBN1','url2',N'kể về 2' ),
		(N'Sach3', N'tg3', 'ISBN1','url3',N'kể lại 3' );

select * from Books;
insert into Users(UserID, FullName, Email,Address )
values (11,N'Trần Văn 1', 'Email1@gmail.com', N'Hà Nội' ),
		(22,N'Trần Văn 2', 'Email2@gmail.com',N'Thái Nguyên' ),
		(33,N'Trần Văn 3', 'Email3@gmail.com',N'Hà Nam' );
select * from Users;
insert into Loans(UserID, BookID, DueDate,Modofied )
values (11,101, '20200204', '20210102' ),
		(33,100, '20200608', '20220203' ),
		(22,102, '20210402', '20220408' );
--4.Searching for book’s titles starting with ‘M’.
select * from Books where Title like 'M%';
--6.Create a view, named v_DueDate includes Users (UserID, FullName, Email,
create VIEW v_DueDate AS
 select u.UserID, u.FullName, u.Email
 from Users u;
 SELECT * FROM v_DueDate;
-- 7.Create a view named v_TopLoan includes information of the five most borrowed 
create VIEW v_DueDate AS
 select *
 from Books b inner join Loans l on b.BookID = l.BookID;