use t2202e_company;
-- thêm dữ liệu vào bảng department
-- chuỗi kiểu date: yyyymmdd
insert into department (dnumber, dname, mgrssn, mgrstartdate)
values 
('PHC', N'Phòng hành chính', '1', '20100101'),-- 01/01/2010
('PKT', N'Phòng kế toán', '1', '20121201'),
('PKD', N'Phòng kinh doanh', '2', '20110101');

-- Lệnh lấy dữ liệu từ bảng hoặc 1 nhóm quan hệ
/*
SELECT <danh sách các cột cần lấy dữ liệu ra(,)>
FROM <tên bảng>
WHERE <các điều kiên để lấy các hàng dữ liệu ra>
ORDER BY <các cột cồn được sắp xếp dữ liệu> (ASC/DESC)



*/
-- lấy tất cả dữ liệu của bảng department:
SELECT * FROM department;
-- lấy dữ liệu mã phòng ban, tên phòng ban từ bảng department:
SELECT dnumber, dname FROM department;
SELECT dnumber, dname FROM department WHERE 1=1;
-- lấy tất cả dữ liệu của bảng department sắp xếp theo tăng dần của mã phòng ban: ORDER BY
SELECT * FROM department ORDER BY dnumber;
-- lấy tất cả dữ liệu của bảng department sắp xếp theo tăng dần người quản lí, giảm dần của thời gian nhận chức
SELECT * FROM department ORDER BY mgrssn ASC, mgrstartdate DESC;
-- lấy tất cả dữ liệu của bảng department với người quản lý =1:
SELECT * FROM department WHERE mgrssn='1';
-- lấy tất cả dữ liệu của bảng department với thời gian nhận chức bắt đầu từ năm 2011
SELECT * FROM department WHERE mgrstartdate >= '20110101' ;
-- thêm dữ liệu nhân viên vào bảng employee:
insert into employee(ssn, address, bdate, dno,Fname,Lname, minit, salary,sex, superssn)
values
('6',N'Trung Hòa, Nhân Chính, Cầu Giấy, HN', '20000412', 'PKD', N'Dương', N'NGuyễn', 2, 10000000, 'nam', 1),
('7',N'Dịch vọng hậu, Cầu Giấy, HN', '19961205', 'PKD', N'Huyền', N'Lê', 2, 15000000, N'Nữ', 2),
('8',N'Mễ trì, HN', '19920412', 'PKT', N'Anh', N'Phạm', 4, 10000000, 'nam', 1),
('9',N'Trinh kính, Cầu Giấy, HN', '19901002', 'PHC', N'Lam', N'NGuyễn', 4, 30000000, 'nam', 2);
SELECT * FROM employee;
-- lấy thông tin firstname, last name, mã nhân viên, mã người quản lí, mã phòng ban
-- lương của các nhân viên
-- theo giảm dần của lương
select Fname, Lname, ssn, superssn, dno, salary from employee order by salary desc;
-- lấy thông tin firstname, last name, mã nhân viên, mã người quản lí, mã phòng ban
-- lương của các nhân viên
-- đã được gán phòng ban
select Fname, Lname, ssn, superssn, dno, salary from employee
where dno is not null;
select * from employee;
-- lấy tất cả thông tin của nhân viên mà có phòng ban và lastname không được trống
select * from employee where dno is not null and Lname is not null;
select * from employee where len (dno) > 0 and len (Lname) >0;
-- lấy tất cả nhân viên mà chỉ cần có tên và lương nhỏ hơn 10tr
select * from employee where (Fname is not null or Lname is not null )
and salary <10000000; 

-- lấy tất cả nhân viên đã được gán phòng ban
-- lấy tất cả nhân viên có phòng ban thuộc danh sách các phòng ban đã có
select * from employee where dno in ('PKT', 'PKD', 'PHC');

select * from employee where dno in( select dnumber from department);
select * from employee where concat (dno,',', superssn )in( select concat (dnumber,',',mgrssn) from department);


update employee set salary = 6000000 where ssn ='4';


-- lấy tất cả nhân viên có lương trong khoảng từ 10tr -20tr

select * from employee where salary >= 10000000 and salary <=20000000;
select * from employee where salary between 10000000 and 20000000;
select year(bdate ) as byear, bdate from employee where (year(getdate())-year(bdate))>20;