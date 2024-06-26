-- lấy danh sách thông tin sinh viên kèm thông lớp, khoa của sinh viên ấy
select sv.masv, sv.tensv, sv.gioitinh, sv.ngaysinh, sv.malop,
l.tenlop, l.makhoa, k.tenkhoa
 from sinhvien sv inner join lop l on sv.malop = l.malop
inner join khoa k on l.makhoa = k.makhoa;

 -- TẠO VIEW: KHUNG NHÌN, đại diện cho 1 lệnh sql ( phức tạp và dùng nhiều lần )
 create VIEW v_ttsinhvien AS
 select sv.masv, sv.tensv, sv.gioitinh, sv.ngaysinh, sv.malop,
l.tenlop, l.makhoa, k.tenkhoa
 from sinhvien sv inner join lop l on sv.malop = l.malop
inner join khoa k on l.makhoa = k.makhoa;
-- TRUY VẤN VIEW: 
SELECT * FROM v_ttsinhvien;

-- LẤY thông tin sinh viên, lớp thuộc khoa CNTT
select * from v_ttsinhvien where makhoa = 'CNTT';
-- hiển thị số lớp, số sinh viên của mỗi khoa
select count(distinct malop) solop,count(masv) slsinhvien, makhoa, tenkhoa from v_ttsinhvien
group by makhoa, tenkhoa;

-- hiển thị số lượng sinh viên theo lớp, theo khoa
select count(masv) slsinhvien, malop, tenlop, makhoa, tenkhoa from v_ttsinhvien
group by malop, tenlop, makhoa, tenkhoa;

-- tạo view hiển thị thông tin điểm thi, môn học, sinh viên, lớp, khoa
select sv.masv, sv.tensv, sv.gioitinh, sv.ngaysinh,
l.malop, l.tenlop, k.makhoa, k.tenkhoa, dt.lanthi, dt.diemthi, mh.mamh, mh.tenmh, mh.sogio
from sinhvien sv full outer join lop l on sv.malop = l.malop
full outer join khoa k on l.makhoa = k.makhoa
full outer join diemthi dt on sv.masv = dt.masv
full outer join monhoc mh on dt.mamh = mh.mamh;

-- nếu view v_tthoctap_new mà tồn tại thì xóa đi 
DROP view [dbo].[v_tthoctap]--v_tthoctap_new không tồn tại
go
-- tạo view -> ok
create view dbo.v_tthoctap as
select sv.masv, sv.tensv, sv.gioitinh, sv.ngaysinh,
l.malop, l.tenlop, k.makhoa, k.tenkhoa, dt.lanthi, dt.diemthi, mh.mamh, mh.tenmh, mh.sogio
from sinhvien sv full outer join lop l on sv.malop = l.malop
full outer join khoa k on l.makhoa = k.makhoa
full outer join diemthi dt on sv.masv = dt.masv
full outer join monhoc mh on dt.mamh = mh.mamh;

select GETDATE();

select * from v_tthoctap;
select * from v_ttsinhvien vsv inner join giangvien gv on vsv.makhoa = gv.makhoa;
-- hiển thị kết quả học tập cuối cùng và thông tin liên quan của học sinh 
-- ( hv mà thi 2 lần, thì môn học đó lấy điểm lần 2)
-- sub query
select * from v_tthoctap vht where exists (
	select 1 from (
		select max(lanthi) lanthi, mamh, masv from diemthi group by mamh, masv
	)a where a.lanthi = vht.lanthi and a.mamh = vht.mamh and a.masv = vht.masv
);
--and vht.masv = 'SV000001' and vht.mamh = 'MH0001';
select vht.* from v_tthoctap vht inner join 
(select max(lanthi) lanthi, mamh, masv from diemthi group by mamh, masv) b 
on vht.lanthi = b.lanthi and vht.mamh = b.mamh and vht.masv = b.masv;


select * from v_tthoctap vht where vht.masv = 'SV000001' and vht.mamh = 'MH0001';

-- tìm ra lần thi cao nhất
select max(lanthi) lanthi, mamh, masv from diemthi group by mamh, masv;

-- hàm: tổ hợp lệnh có kết trả về, được lưu cấu trúc để sử dụng nhiều lần trong DB
-- hàm trả về dữ liệu ( query ) -> table hoặc trả về kiểu dữ liệu đơn
-- hàm: trả về danh sách kết quả thi của học viên theo môn học
create function fn_getKetQuaByMonHoc(
-- ds tham số: tham số @<tên tham số> kiểu tham số, ....
	@mamh varchar(6)
) returns table -- return <kiểu trả về> ( table: tập dữ liệu >
as
-- thân hàm
--begin -- mở thân hàm
	return (
		-- sql truy vấn
		select vht.* from v_tthoctap vht inner join 
		(select max(lanthi) lanthi, mamh, masv from diemthi group by mamh, masv) b 
		on vht.lanthi = b.lanthi and vht.mamh = b.mamh and vht.masv = b.masv
		where vht.mamh like @mamh
	);
--end; -- kết thân hàm
-- gọi hàm
select * from fn_getKetQuaByMonHoc('MH0008');

--- hàm xếp loại học lực của 1 sinh viên 
/*
 Mục đích: trả về học lực của 1 sinh viên
 Input:
	điểm -> number
 Output: 
	Học lực -> nvarchar
*/
create function fn_getHocLuc(
	-- ds input
	@diem float
) 
-- khai báo trả về
returns nvarchar(30)
as
-- mở thân hàm
begin
	-- khối lệnh thân hàm
	-- khai báo biến local
	declare @result nvarchar(30);
	-- thực thi
	if @diem < 4 
	begin
		-- gán giá trị cho biến
		set @result = N'Yếu';
	end;
	else if @diem < 7
		set @result = N'Trung bình';
	else if @diem < 8.5
		set @result = N'Khá';	
	else
		set @result = N'Xuất sắc';
	return @result;
end;
-- đóng thân hàm
-- gọi hàm
select dbo.fn_getHocLuc(9);
-- hiển thị kết quả học tập cuối cùng của các học viên, và học lực xếp loại
select vht.*, dbo.fn_getHocLuc(vht.diemthi) hocluc from v_tthoctap vht inner join 
		(select max(lanthi) lanthi, mamh, masv from diemthi group by mamh, masv) b 
		on vht.lanthi = b.lanthi and vht.mamh = b.mamh and vht.masv = b.masv;


/*
	Hàm: khối lệnh thực hiện 1 nhiện vụ nào đó có trả về kết quả
	Hàm dùng được tại các vị trí trong câu lênh select
	select <các cột dữ liệu> from <nguồn chứa> where <điều kiện>
	group by <các cột>
	having<điều kiện của nhóm>
	order by <các cột> asc;

*/


