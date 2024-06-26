-- xay dung db company:
-- tạo db mới:
create database t2202e_company;
use t2202e_company;
-- tao bảng employee
create table employee(
	fname nvarchar(50) not null,
	minit int,
	lname nvarchar(50),
	ssn char(6) primary key,
	bdate date,
	address nvarchar(255),
	sex nvarchar(10),
	salary numeric(18,0) check(salary > 0),
	superssn char(6),
	dno varchar(10),
	foreign key (superssn)
	references employee(ssn)
);
--- tao department
create table department(
	dname nvarchar(200) unique,
	dnumber varchar(10) primary key,
	mgrssn char(6),
	mgrstartdate date,
	foreign key (mgrssn)
	references employee(ssn)
);
alter table employee 
add constraint FK_employee_department_dno
foreign key (dno) references 
department(dnumber);

--- Thêm mới bản ghi vào bảng--
/*
INSERT INTO <tên bảng>(<TÊN CÁC CỘT DỮ LIỆU TƯƠNG ỨNG>)
VALUES (<dữ liệu tương ứng của từng cột>),
(<dữ liệu tương ứng của từng cột>),
(<dữ liệu tương ứng của từng cột>)
;
-- trong 1 bảng, tại lệnh insert, thì các cột not null bắt buộc phải được 
thêm dữ liệu

*/
-- thêm 1 nhân viên với thông tin ssn và fname vào bảng
-- 
INSERT INTO employee (ssn, fname) 
VALUES
	('1', 'Dung');
INSERT INTO employee
VALUES
	(N'Hải', null, null, '2', null, null, null, null, null, null);
-- thêm nhiều bản ghi
INSERT INTO employee(ssn, fname, superssn)
VALUES
	('4', N'Tính', '2'),
	('5', N'Hải', '3');
/*
UPDATE: dữ liệu trong bảng đã có, dùng lệnh UPDATE 
để sửa/ cập nhật dữ liệu này bằng dữ liệu mới
UPDATE <tên bảng> SET <tên cột>=<giá trị tương ứng cập nhật vào cột>,
<tên cột 2>=<giá trị cột 2>, <tên cột 3>=<giá trị cột 3>
WHERE <điều kiện các bản ghi sẽ được cập nhật>;
;
*/
-- cập nhật cột minit = 10 cho tất cả các hàng dữ liệu trong bảng employee
UPDATE employee set minit = 10;
-- cập nhật salary của các nhân viên có id = 1 về 1 tỷ
UPDATE employee set salary= 1000000000 WHERE ssn = '1';
-- cập nhật câc employee chưa có superssn thì superssn=5;
UPDATE employee set superssn = '5' WHERE superssn IS NULL;
-- cập nhật các employee chưa có salary thì lname = 'Pham' và minit = 5;
UPDATE employee SET lname='Pham', minit = 5 WHERE salary IS NULL;
SELECT * FROM employee WHERE salary IS NULL;


-- SELECT * FROM <tên bảng>: lấy tất cả dữ liệu đang có trong bảng
select * from employee WHERE ssn = '1';
SELECT * FROM employee;