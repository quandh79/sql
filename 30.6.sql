select * from employee;
-- cap nhat 2tr cho cac nv chua co thong tin luong
update employee set salary = 2000000 where salary is null;
select 
-- các cột ảo dữ liệu tập hợp
min(SALARY) as LUONG_MIN, MAX(SALARY) LUONG_MAX, AVG(salary) LUONG_TB,
COUNT(salary) SOLUONG, SUm(salary) TONG_LUONG 
-- các cột không tập hợp:
,Fname, Lname
, concat(Fname, ' ', Lname) fullname
from employee
group by Fname, Lname, concat(Fname, ' ', Lname);
select min(SALARY) as LUONG_MIN, Fname
from employee
group by Fname;
-- lấy dữ liệu thông kê (min, max, avg, sum, count)  về lương theo phòng ban
select min(salary) luong_min, max(salary) luong_max, avg(salary) luong_tb,
 dno
from employee where dno is not null
group by dno;
-- lấy dữ liệu thông kê (min, max, avg, sum, count)  về lương theo phòng ban
-- luong_min > 5tr: điều kiện về tập hợp khi có group by thì phải kết hợp having
select min(salary) luong_min, max(salary) luong_max, avg(salary) luong_tb,
 dno
from employee where dno is not null
group by dno
having min(salary) > 5000000 and max(salary) < 100000000
order by min(salary) ;


-- 

select * from employee;
select * from department;
-- lấy thông tin nhân viên và tên phòng ban của nhân viên 
select a.Fname, a.Lname, a.address, a.salary, d.dnumber, d.dname
from employee a inner join department d on a.dno = d.dnumber;
-- lấy thông tin của phòng ban và thông tin lãnh đạo ( họ tên, địa chỉ, lương)
select d.*, concat(e.Fname,' ', e.Lname) fullname, e.address, e.salary
from employee as e inner join department as d on e.ssn = d.mgrssn;
-- lấy thông tin của nhân viên và quản lí cua nhân viên 
select e_nv.Fname fname_nv, e_nv.Lname lname_nv, e_nv.salary salary_nv,
e_ql.Fname fname_ql, e_ql.Lname lname_ql, e_ql.salary salary_ql
from employee e_nv inner join employee e_ql on e_nv.superssn = e_ql.ssn;
-- lef join
select d.*, concat(e.Fname,' ', e.Lname) fullname, e.address, e.salary
from employee as e left join department as d on e.ssn = d.mgrssn;
--left join : lấy tất cả nhân viên và thông tin phòng ban của nhân viên


/*
	 e.dno = d.dnumber: e là left, d: right
	 left join: lấy tất cả bản ghi của e và không trùng với d
	 right join: lấy tất cả bản ghi của d không trùng với e
	 full join: lấy tất cả bản ghi cùng tồn tại trong d,e và phần không trùng của d và e


*/
select d.*, concat(e.Fname,' ', e.Lname) fullname, e.address, e.salary
from department as d right join employee as e on e.dno = d.dnumber;