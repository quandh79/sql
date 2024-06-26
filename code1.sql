-- xây dựng db company
-- tạo db mới:
create database t2202e_company;
use t2202e_company;
-- tạo bảng employee
create table employee(
	Fname nvarchar(50) not null,
	minit int,
	Lname nvarchar(50),
	ssn char(6) primary key,
	bdate date,
	address nvarchar(255),
	sex nvarchar(10),
	salary numeric(18,0) check(salary >0),
	superssn char(6),
	dno varchar(10),
	foreign key (superssn)
	references employee(ssn)


);
-- tạo bảng department
	create table department(
		dname nvarchar(200) unique,
		dnumber varchar(10) primary key,
		mgrssn char(6),
		mgrstartdate date,
		foreign key (mgrssn)
		references employee(ssn),

	);

	alter table employee add constraint FK_employee_department_dno
	foreign key (dno) references department(dnumber);

	--- thêm mới bản ghi vào bảng---
	/*
	INSERT INTO <tên bảng> (<Tên các cột dữ liệu tương ứng>)
	VALUES (<dữ liệu tương ứng của từng cột>),(<dữ liệu tương ứng của từng cột>)
	*/
	-- thêm 1 nv với thông tin ssn và fname vào bảng
	-- trong 1 bảng
	INSERT INTO employee (ssn,Fname)
	VALUES 
	('1', N'Quân');
	INSERT INTO employee
	VALUES (N'Hải',null, null, '2', null, null, null, null, null, null);

	-- thêm nhiều bản ghi
	INSERT INTO employee (ssn, Fname, superssn)
	VALUES 
	('4', N'Ngọc', '2'),
	('5', N'Hải', '2');


	/*UPDATE: dữ liệu trong bảng đã có, dùng lệnh UPDATE
	-- để sửa/ cập nhật dữ liệu này bằng dữ liệu mới
	UPDATE <tên bảng> SET <tên cột> = <giá trị tương ứng cập nhật vào cột>,
	<tên cột 2> = <giá trị tương ứng cập nhật vào cột 2>
	WHERE <điều kiện các bản ghi sẽ được cập nhật>;
	*/
	-- cập nhật cột minit = 10 cho tất cả các hàng dữ liệu trong bảng imployee
	UPDATE employee set minit = 10;
	-- cập nhật salary của các nhân viên có id =1 về 1 tỷ
	UPDATE employee set salary = 1000000000 WHERE ssn = '1';
	-- cập nhật các nhân viên employee chưa có superssn thì superssn =5
	UPDATE employee set superssn = '5' WHERE superssn IS null;
	-- cập nhật các imployee chưa có salary thì Lname = 'Do' và minit = 5;
	UPDATE employee set Lname = 'Do', minit ='5' WHERE salary IS null;
	-- SELECT * FROM <tên bảng> : lấy tất cả dữ liệu đang có trong bảng
	SELECT * FROM employee;
	