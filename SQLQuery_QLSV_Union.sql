----UNION/ UNION ALL------------
--gộp kết quả từ 2 hoặc nhiều truy vấn (select ) có cùng cấu trúc cột với nhau
/*
<select 1>
union/ union all
<select 2>
*/
use t2202e_qlsv;
-- lấy tất cả danh sách của sinh viên và giảng viên trong trường
-- lấy danh sách sinh viên:
select * from sinhvien;
-- lấy danh sách giảng viên
select * from giangvien;
-- gộp
select masv as ma, tensv as ten, N'Sinh viên' as vaitro from sinhvien
union all
select magv as ma, tengv as ten, N'Giảng viên' as vaitro from giangvien;

-- lấy ds sinh viên và giảng viên họ Nguyễn
-- lay sinh viên họ Nguyễn
select masv as ma, tensv as ten, N'Sinh viên' as vaitro from sinhvien
where tensv like N'Nguyễn%'
union all
-- lấy giảng viên họ nguyễn
select magv as ma, tengv as ten, N'Giảng viên' as vaitro from giangvien
where tengv like N'Nguyễn%'
union all
select 'bva' as ma, N'Nguyễn Văn A' ten, N'Bảo vệ' as vaitro
order by ten;

select 'bva' as ma, N'Nguyễn Văn A' ten, N'Bảo vệ' as vaitro;

select * from (
	select masv as ma, tensv as ten, N'Sinh viên' as vaitro from sinhvien
	union all
	select magv as ma, tengv as ten, N'Giảng viên' as vaitro from giangvien
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
select 3 cot1, 3 cot2
;
-- lấy ra các hàng dữ liệu trùng nhau trong tập dữ liệu
select * from (
	select 1 cot1, 1 cot2
	union
	select 2 cot1, 2 cot2
) a1
INTERSECT 
select * from (
	select 1 cot1, 1 cot2
	union 
	select 2 cot1, 2 cot2
	union
	select 3 cot1, 3 cot2
) a2;

	select cot1, cot2 /*, count(cot1) slcot1, count(cot2) slcot2 */
	from
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
	) a group by cot1, cot2 having count(cot1) > 1 and count(cot2) > 1
	;

	-- liệt kê các Lớp học chưa có sinh viên
	-- tất cả các lớp
	select * from lop;
	-- các lớp đã có sinh viên:
	select distinct malop from sinhvien;

	select malop from lop
	except
	select distinct malop from sinhvien;
-- Thêm cột từ các bảng khác => JOIN
	select a.* from lop a inner join (
		select malop from lop
		except
		select distinct malop from sinhvien
	) b on a.malop = b.malop;

	select malop, tenlop, makhoa from lop
	except
	select distinct b.malop, b.tenlop, b.makhoa from sinhvien a 
	inner join lop b on a.malop = b.malop;

	select distinct b.malop, b.tenlop, b.makhoa from sinhvien a 
	right join lop b on a.malop = b.malop
	where a.malop is null;

-- Hiển thị bảng điểm chi tiết và điểm trung bình của học viên lần thi = 1 theo từng môn
-- bảng điểm chi tiết của lần 1
select masv, mamh, lanthi, diemthi from diemthi where lanthi = 1;
-- điểm trung bình theo môn của lần 1 thi
select avg(diemthi), mamh from diemthi where lanthi = 1 group by mamh;

select masv, mamh, lanthi, diemthi, 1 danhdau from diemthi where lanthi = 1
union all
select '' masv, mamh, 1 lanthi, avg(diemthi) diemthi, 2 danhdau from diemthi where lanthi = 1 
group by mamh
order by mamh, danhdau;






