---UNION/ UNION ALL ---- gop ket qua truy van (select) co cung cau truc cot voi nhau
/*
<select 1>
union
<select 2>

*/

use t2202e_qlsv;
-- lay tat ca danh sacch cua sinh vien va giang vien trong truong
-- lay ds sinh vien:
select * from sinhvien;
-- lay danh sach giang vien:
select * from giangvien;
-- gop
select masv ma, tensv ten, 'sinh vien' as vaitro from sinhvien

union all
select magv ma, tengv ten, 'giang vien' as vaitro from giangvien;
-- lay danh sach sv va gv ho nguyen
select masv ma, tensv ten, 'sinh vien' as vaitro from sinhvien
where tensv like N'Nguyễn%'
union all
select magv ma, tengv ten, 'giang vien' as vaitro from giangvien
where tengv like N'Nguyễn%'
order by ten;
--
select 'bva' as ma, N'Nguyen văn A' ten, N'bao vệ' as vaitro;
select * from(
	select masv ma, tensv ten, 'sinh vien' as vaitro from sinhvien

	union all
	select magv ma, tengv ten, 'giang vien' as vaitro from giangvien
) as ds
where ten like N'Nguyễn%';


select 1 cot1, 1 cot2
union all
select 2 cot1, 2 cot2
union all
select 1 cot1, 1 cot2
union all
select 2 cot1, 2 cot2
union all
select 3 cot1, 3cot2;

--- lay ra các hàng dữ liệu trùng nhau trong tập dữ liệu
select * from (
	select 1 cot1, 1 cot2
	union
	select 2 cot1, 2 cot2
)a1
intersect
select * from(
	select 1 cot1, 1 cot2
	union
	select 2 cot1, 2 cot2
	union
	select 3 cot1, 3cot2
) a2;

-- c2:
select cot1, cot2 /*count(cot1) slcot1, count (cot2) slcot2*/ from
(
select 1 cot1, 1 cot2
union all
select 2 cot1, 2 cot2
union all
select 1 cot1, 1 cot2
union all
select 2 cot1, 2 cot2
union all
select 3 cot1, 3 cot2
) a
group by  cot1, cot2 having count(cot1)>1 and count (cot2)>1  ;
-- Liệt kê các các lớp học chưa có sinh viên
-- tất caer các lớp
select * lop;
-- các lớp đã có sinh viên:
select distinct malop from sinhvien;

select malop from lop
except
select distinct malop from sinhvien;


-- thêm cột từ các bảng khác => JOIN
select * from lop a inner join (
select malop from lop
except
select distinct malop from sinhvien)
b on a.malop = b.malop;


-- c2:
select malop, tenlop, makhoa from lop
except
select distinct b.malop, b.tenlop, b.makhoa from sinhvien a inner join lop b on a.malop = b.malop;


-- c3

select distinct b.malop, b.tenlop, b.makhoa from sinhvien a right join lop b on a.malop = b.malop
where a.malop is null;

-- tìm các môn học mà sinh vien chưa thi
--c1:
select mamh, tenmh from monhoc
except
select distinct b.mamh, b.tenmh from diemthi a
inner join monhoc b on a.mamh = b.mamh;

--c2
select distinct a.mamh from diemthi a left join monhoc b on a.mamh = b.mamh
where b.mamh is null
-- hiển thị bảng điểm chi tiết và điểm trung bình của học viên lần thi =1 theo từng môn
--ảng điểm chi tiết lần thi =1
select masv, mamh, lanthi, diemthi from diemthi from diemthi where lanthi = 1;
--điểm trung bình của học viên lan thi 1
select avg(diemthi), mamh from diemthi where lanthi = 1 group by mamh;

select masv, mamh, lanthi, diemthi , 1 danhdau from diemthi where lanthi = 1
union all
select '' masv, mamh, 1 lanthi, avg(diemthi) diemthi , 2 danhdau from diemthi where lanthi = 1 
group by mamh
order by mamh, danhdau;





