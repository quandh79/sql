use t2202e_qlsv;
/*
(1) Hiển thị thông tin điểm thi, sinh viên của những sinh viên có giới tính nữ ( 1), sắp xếp tăng dần tensv
thong tin dien thi: diemthi
thong tin sinh vien: sinh vien
gioi tinh nu: sinh vien
tbl: dien thi, sinh vien
--> inner join
*/

select sv.masv,( case when sv.gioitinh = 1 then N'Nu' when sv.gioitinh=0 then 'nam' else N'Khac' end) as gioitinh, 
sv.tensv, sv.malop, dt.mamh, dt.lanthi, dt.diemthi,
-- cột ligic ảo
(case when dt.diemthi >=4 then 'Dat' else 'Khong dat' end) as danhgia


from sinhvien sv inner join diemthi dt on sv.masv = dt.masv
where sv.gioitinh = 1 order by sv.tensv;
/*
(2) Hiển thị thông tin điểm thi, sinh viên của những sinh viên có ngày sinh > 01/01/2002, sắp xếp tăng dần ten lop
1. xác định các thông tin cần lấy -> tìm bảng chứa các thông tin đó
thông tin điểm thi: diemthi -> select
thông tin sinh viên: sinhvien -> select
2. xác định cột dữ liệu xần xét diều kiện -> tìm bảng chứa cột đó
dk:ngày sinh > 01/01/2002 -> cột ngày sinh -> sinh viên
3. các thông tin liên quan khác: nhóm, sắp  xếp
order: sắp xếp tăng dần theo lớp -> cột tenlop -> lop
=> cần lấy dữ liệu/dk/sắp xếp từ 3 bảng sinhvien,diemthi,lop
*/
select sv.masv,( case when sv.gioitinh = 1 then N'Nu' when sv.gioitinh=0 then 'nam' else N'Khac' end) as gioitinh, 
sv.tensv, sv.malop, dt.mamh, dt.lanthi, dt.diemthi,
-- cột ligic ảo
(case when dt.diemthi >=4 then 'Dat' else 'Khong dat' end) as danhgia, lp.tenlop, lp.makhoa
 from sinhvien sv
inner join diemthi dt on sv.masv = dt.masv -- kết hợp bảng sinh viên và điểm thi
inner join lop lp on sv.malop = lp.malop -- kết hợp bảng sinh viên và lớp
where sv.ngaysinh > '20020101'
order by lp.tenlop;
/*
(3) Hiển thị mã sinh viên, tên sinh viên, giới tính, ngày sinh, tên lớp, tên khoa của danh sách sinh viên có thể được học với giảng viên có magv =GV0001.
-- sinhvien,giangvien,lop,khoa
*/
select *
from sinhvien sv inner join lop lp on sv.malop = lp.malop--- sinhvien-lop
inner join khoa kh on lp.makhoa = kh.makhoa --- lop-khoa
inner join giangvien gv on kh.makhoa = gv.makhoa -- khoa - giangvien
where gv.magv like '%0001'; --like: ss tương đối '%0001' - ss tuyệt đối 'gt tuyệt đối'
--c2: trong where xét điều kiên bảng giangvien
select *
from sinhvien sv inner join lop lp on sv.malop = lp.malop--- sinhvien-lop
inner join khoa kh on lp.makhoa = kh.makhoa --- lop-khoa
where 
-- tìm các khoa có GV0001 giảng dạy
kh.makhoa in (
select makhoa from giangvien where magv= 'GV0001'
);
/*
(4) Hiển thị số lượng sinh viên theo từng lớp:
sinhvien
-> số lượng :hàm count(masv),malop
*/
select count(masv) soluong, malop
from sinhvien group by malop
order by count(masv);
/*
(7) Hiển thị mã lớp và tên lớp của những lớp chưa có sinh viên. (*)

*/
-- tìm lớp mà lop đó không tồn tại trong lớp của sinhvien
select * from lop where malop not in (
	select distinct malop from sinhvien 
);
select * from lop lp left join sinhvien sv on lp.malop = sv.malop
where sv.masv is null;
/* hiển thị thông tin kết quả điểm thi của sinh viên, giữa 2 lần thi cùng môn sinh viên được tính điểm cao hơn

*/
select max(diemthi) diem, masv, mamh from diemthi
group by masv, mamh;
/*
hiển thị thông tin kết quả điểm thi của sinh viên,
lấy điểm của lần thi cuối cùng

*/
select max(lanthi) lanthicuoi, masv, mamh from diemthi
group by  masv, mamh;
select dt.* from diemthi dt
inner join (
	select max(lanthi) lanthicuoi, masv, mamh from diemthi
	group by  masv, mamh
) dtcn on dt.masv  = dtcn.masv and dt.mamh = dtcn.mamh and dt.lanthi = dtcn.lanthicuoi;

select dt1.* from diemthi dt1
left outer join diemthi dt2 on dt1.masv = dt2.masv and dt1.mamh = dt2.mamh and dt1.lanthi<dt2.lanthi
where dt2.lanthi is null;

/*
-	(5) Hiển thị số lượng sinh viên theo từng khoa 

*/
select count(masv) soluong, kh.makhoa
from sinhvien sv inner join lop lp on sv.malop = lp.malop--- sinhvien-lop
inner join khoa kh on lp.makhoa = kh.makhoa --- lop-khoa
group by kh.makhoa;
/*
-	(6) Hiển thị mã sinh viên, tên sinh viên, mã lớp, tên lớp của những sinh viên lớp T0001
*/
select sv.masv, sv.tensv, lp.malop, lp.tenlop
from sinhvien sv inner join lop lp on sv.malop = lp.malop
where lp.malop like 'T0001';
/*
-	(7) Hiển thị thông tin giảng viên, khoa, lớp, sinh viên*/
select gv.*, kh.tenkhoa, lp.tenlop, sv.*
from sinhvien sv inner join lop lp on sv.malop = lp.malop
inner join khoa kh on lp.makhoa = kh.makhoa
inner join giangvien gv on kh.makhoa = gv.makhoa;
/*
-	(8) Hiển thị thông tin giảng viên, điểm thi, môn học

*/
select gv.*, dt.*, mh.*
from monhoc mh inner join diemthi dt on mh.mamh = dt.mamh
inner join sinhvien sv on sv.masv = dt.masv
inner join lop lp on sv.malop = lp.malop
inner join khoa kh on lp.makhoa = kh.makhoa
inner join giangvien gv on kh.makhoa = gv.makhoa;
/*
-	(9) Hiển thị thông tin giảng viên, khoa, lớp, sinh viên, điểm thi, môn học
*/
select gv.*,kh.tenkhoa, lp.tenlop, sv.*,dt.lanthi,dt.diemthi, mh.*
from monhoc mh inner join diemthi dt on mh.mamh = dt.mamh
inner join sinhvien sv on sv.masv = dt.masv
inner join lop lp on sv.malop = lp.malop
inner join khoa kh on lp.makhoa = kh.makhoa
inner join giangvien gv on kh.makhoa = gv.makhoa;
/*
10 Hiển thị mã sinh viên, tên sinh viên, mã môn học, tên môn học và điểm thi của sinh viên có mã SV003301, thi lần 1.

*/
select sv.masv, sv.tensv, mh.mamh, mh.tenmh, dt.diemthi
from monhoc mh inner join diemthi dt on mh.mamh = dt.mamh
inner join sinhvien sv on sv.masv = dt.masv
where sv.masv like 'SV003301' and dt.lanthi = '1';

/*
-	(11) Hiển thị mã môn học, tên môn học của những môn có sinh viên thi lần 2. Hiển thị tăng dần theo mã môn học. 
*/
select mh.mamh, mh.tenmh, dt.lanthi
from monhoc mh inner join diemthi dt on mh.mamh = dt.mamh
where dt.lanthi = '2'
order by mh.mamh;
/*
 12 Hiển thị mã sinh viên, tên sinh viên có điểm trung bình cao nhất. 
*/

select top (1) sv.masv, sv.tensv, avg(dt.diemthi) diemtb
from diemthi dt inner join sinhvien sv on dt.masv = sv.masv
group by sv.masv, sv.tensv
order by avg(dt.diemthi) desc ;

/*
-	(13) Hiển thị sinh viên đã có điểm và chưa có điểm thi.
*/
select sv.*, dt.diemthi
from diemthi dt inner join sinhvien sv on dt.masv = sv.masv
where dt.diemthi is not null;
/*
-	(14) Hiển thị sinh viên nữ đã có lớp và chưa có lớp ở khoa CNTT
*/
select sv.*
from sinhvien sv inner join lop lp on sv.malop = lp.malop
inner join khoa kh on lp.makhoa = kh.makhoa
where kh.makhoa = 'CNTT' and sv.gioitinh = 1 ;
/*
-	(15) Hiển thị điểm thi lần đầu của các sinh viên khoa CNTT 
*/
select sv.*, dt.diemthi, dt.lanthi
from diemthi dt inner join sinhvien sv on dt.masv = sv.masv
inner join lop lp on sv.malop = lp.malop
where dt.lanthi = 1 and lp.makhoa = 'CNTT';
/*
 16 Hiển thị mã sinh viên, tên sinh viên, tên lớp, tên khoa có điểm thi trung bình lớn nhất.
*/
select top (1) sv.masv, sv.tensv, lp.tenlop, lp.makhoa,  avg(dt.diemthi) dtb
from diemthi dt inner join sinhvien sv on dt.masv = sv.masv
inner join lop lp on sv.malop = lp.malop
group by sv.masv, sv.tensv, lp.tenlop, lp.makhoa
order by avg(dt.diemthi) desc;
/*
17 Hiển thị mã sinh viên, tên sinh viên, lớp, tên khoa, tên môn học, số giờ mà đã thi 2 lần cùng môn. 
*/
select sv.masv, sv.tensv, lp.tenlop, lp.makhoa, mh.tenmh, count(dt.lanthi) solanthi
from monhoc mh inner join diemthi dt on mh.mamh = dt.mamh
inner join sinhvien sv on sv.masv = dt.masv
inner join lop lp on sv.malop = lp.malop
group by sv.masv, sv.tensv, lp.tenlop, lp.makhoa, mh.tenmh
having count(dt.lanthi) = 2 and mh.tenmh = mh.tenmh;

/*
	18 Hiển thị mã sinh viên, tên sinh viên, lớp, khoa, tên môn học, số giờ, điểm thi trung bình 2 lần thi cùng môn
*/
select sv.masv, sv.tensv, lp.tenlop, lp.makhoa, mh.tenmh, count(dt.lanthi) solanthi, avg(dt.diemthi) dtb
from monhoc mh inner join diemthi dt on mh.mamh = dt.mamh
inner join sinhvien sv on sv.masv = dt.masv
inner join lop lp on sv.malop = lp.malop
group by sv.masv, sv.tensv, lp.tenlop, lp.makhoa, mh.tenmh
having count(dt.lanthi) = 2 and mh.tenmh = mh.tenmh;

/*
 19 Hiển thị môn học và số lượng sinh viên có lần thi lần 2, sắp xếp theo thứ tự giảm dần số lượng sinh viên 
*/
select mh.tenmh, count(sv.masv) sosv,dt.lanthi
from monhoc mh inner join diemthi dt on mh.mamh = dt.mamh
inner join sinhvien sv on sv.masv = dt.masv
inner join lop lp on sv.malop = lp.malop
group by mh.tenmh,dt.lanthi
having dt.lanthi = 2 ;
/*
 20 Hiển thị mã sinh viên, tên sinh viên, ngày sinh, lớp, khoa của các sinh viên >18 tuổi, sắp xếp giảm dần ngày sinh 
*/
select sv.masv, sv.tensv, sv.ngaysinh, lp.tenlop, kh.tenkhoa, tuoi=year(getdate())-year(sv.ngaysinh)
from sinhvien sv inner join lop lp on sv.malop = lp.malop
inner join khoa kh on lp.makhoa = kh.makhoa
where year(getdate())-year(sv.ngaysinh) >18
order by sv.ngaysinh desc;
/*
-	(21) Hiển thị mã sinh viên, tên sinh viên, ngày sinh, lớp, khoa của các sinh viên sinh năm 2001
*/
select sv.masv, sv.tensv, sv.ngaysinh, lp.tenlop, kh.tenkhoa
from sinhvien sv inner join lop lp on sv.malop = lp.malop
inner join khoa kh on lp.makhoa = kh.makhoa
where sv.ngaysinh BETWEEN '2001-01-01'AND'2001-12-31';
/*
-	(22) Tìm tìm sinh viên sinh năm 2001 và khoa CNTT, giới tính nữ có điểm trung bình cao nhất
*/
select top (1)sv.masv, sv.tensv, sv.ngaysinh, lp.tenlop, kh.tenkhoa, avg(dt.diemthi) dtb, sv.gioitinh 
from diemthi dt inner join sinhvien sv on dt.masv = sv.masv
inner join lop lp on sv.malop = lp.malop
inner join khoa kh on lp.makhoa = kh.makhoa
group by sv.masv, sv.tensv, sv.ngaysinh, lp.tenlop, kh.tenkhoa, kh.makhoa, sv.gioitinh
having sv.ngaysinh BETWEEN '2001-01-01'AND'2001-12-31' and kh.makhoa = 'CNTT' and sv.gioitinh = 1 
order by  avg(dt.diemthi)desc;
/*
-	(23) Hiển thị danh sách sinh viên: mã sinh vien, tên sinh viên, ngày sinh, lớp khoa mà chưa có giáo viên
*/