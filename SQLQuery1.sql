-- lấy danh sách thông tin sinh viên kem thông tin lớp, khoa của sinh viên ấy
select sv.masv, sv.tensv, sv.gioitinh, sv.ngaysinh, sv.malop, l.tenlop, l.makhoa, k.tenkhoa from sinhvien sv 
inner join lop l on sv.malop = l.malop
inner join khoa k on l.makhoa = k.makhoa;
-- tạo view: khung nhìn, đại diện cho 1 sql (phức tạp và dùng nhiều lần )
create view v_ttsinhvien as 
select sv.masv, sv.tensv, sv.gioitinh, sv.ngaysinh, sv.malop, l.tenlop, l.makhoa, k.tenkhoa from sinhvien sv 
inner join lop l on sv.malop = l.malop
inner join khoa k on l.makhoa = k.makhoa;
-- truy vấn view
select * from v_ttsinhvien;
-- lấy thông tin sinh viên, lớp thuộc khoa cntt
select * from v_ttsinhvien where makhoa = 'CNTT';
-- hiển thị số lớp, số sinh viên của mỗi khoa
select count(masv) sosv, count( distinct malop) solop, makhoa, tenkhoa from v_ttsinhvien
group by makhoa, tenkhoa;
-- hiển thị số lượng sinh viên theo lớp, theo khoa
select count(masv) slsinhvien, malop, tenlop, makhoa, tenkhoa from v_ttsinhvien
group by malop, tenlop, makhoa, tenkhoa;
-- tạo view hiển thị thông tin điểm thi, môn học, sinh viên, lớp khoa

select sv.masv, sv.tensv,sv.gioitinh, l.malop, l.tenlop, 
kh.makhoa, kh.tenkhoa, 
dt.diemthi, dt.lanthi, 
mh.mamh, mh.tenmh, mh.sogio  from sinhvien sv full outer join lop l on sv.malop = l.malop
full outer join khoa kh on l.makhoa = kh.makhoa
full outer join diemthi dt on sv.masv = dt.masv
full outer join monhoc mh on dt.mamh = mh.mamh;

create view v_ttht as 
select sv.masv, sv.tensv,sv.gioitinh, l.malop, l.tenlop, 
kh.makhoa, kh.tenkhoa, 
dt.diemthi, dt.lanthi, 
mh.mamh, mh.tenmh, mh.sogio  from sinhvien sv full outer join lop l on sv.malop = l.malop
full outer join khoa kh on l.makhoa = kh.makhoa
full outer join diemthi dt on sv.masv = dt.masv
full outer join monhoc mh on dt.mamh = mh.mamh;

select * from v_ttsv;
select * from v_ttsinhvien vsv inner join giangvien gv on vsv.makhoa = gv.makhoa;
-- hiển thi kết quả học tập cuối cùng của học sinh và thông tin liên quan của học sinh (hv thi 2 lần thì môn học đó lấy điên lần 2)
-- c1: sub query
select * from v_ttht vht where exists (
	select 1 from (
	select max(lanthi) lanthi, mamh, masv from diemthi group by mamh, masv

	) a where a.lanthi = vht.lanthi and a.mamh = vht.mamh and a.masv = vht.masv
) ;
--and vht.masv = 'SV000001' and vht.mamh = 'MH0001';
-- tìm ra lần thi cao nhất
select max(lanthi) lanthi, mamh, masv from diemthi group by mamh, masv;

select * from v_ttht vht inner join (
	select max(lanthi) lanthi, mamh, masv from diemthi group by mamh, masv
) b on b.lanthi = vht.lanthi and b.mamh = vht.mamh and b.masv = vht.masv;
-- nếu view v_tthoctap_new mà tồn tại thì xóa
drop view  [dbo].v_tthoctap_new; -- v_tthoctap_new không tồn tại
-- tạo view -> ok 
create view dbo.v_tthoctap as 
select sv.masv, sv.tensv,sv.gioitinh, l.malop, l.tenlop, 
kh.makhoa, kh.tenkhoa, 
dt.diemthi, dt.lanthi, 
mh.mamh, mh.tenmh, mh.sogio  from sinhvien sv full outer join lop l on sv.malop = l.malop
full outer join khoa kh on l.makhoa = kh.makhoa
full outer join diemthi dt on sv.masv = dt.masv
full outer join monhoc mh on dt.mamh = mh.mamh;


---hàm: tổ hợp lệnh có kết quả trả về, được lưu cấu trúc để sử dụng nhiều lần trong DB
-- hàm trả về dữ liêu (query) -> table hoặc trả về kiểu dữ liệu đơn
-- hàm trả về danh sách kết quả thi của học viên theo môn học


create function fn_getKetQuaByMonHoc(
-- danh sách tham số: tham số @<tên tham số> kiểu tham số,....
@mamh varchar(6)) returns table -- return <kiểu trả về> (table: tập dữ liệu)
-- thân hàm
as
--begin -- mở thân hàm
	return(
		-- sql truy vấn
		select vht.* from v_ttht vht inner join (
		select max(lanthi) lanthi, mamh, masv from diemthi group by mamh, masv
)		b on b.lanthi = vht.lanthi and b.mamh = vht.mamh and b.masv = vht.masv
		where vht.mamh like @mamh
	);
--end; -- kết thân hàm
-- gọi hàm
select * from fn_getKetQuaByMonHoc('MH0008');


-- hàm xếp loại học lực của 1 sinh viên

/*
mục đích: trả về học lực của 1 sv
input: 
điểm -> number
output:
học lực -> nvarchar


*/

create function fn_getHocLuc(
-- ds input
@diem float


)
-- khai báo trả về
begin 
-- khối lệnh thân hàm
-- khai báo biến local
	declare @result nvarchar(30);
-- thực thi
 if @diem < 4 
	begin
	-- gán giá trị cho biến
	set @result = N'yếu'
	end;
	else if @diem < 7 
	set @result = N'Trung bình'
	else if @diem < 8.5 
	set @result = N'Khá'
	else
	set @result = N'Giỏi'
	return @result;
	end;
end;
select dbo.fn_getHocLuc(9);
-- hiển thị kết quả học tập cuối cùng của các học viên, và học lực xếp loại
select vht.*,dbo.fn_getHocLuc(vht.diemthi) hocluc  from v_ttht vht inner join (
		select max(lanthi) lanthi, mamh, masv from diemthi group by mamh, masv
)		b on b.lanthi = vht.lanthi and b.mamh = vht.mamh and b.masv = vht.masv;
		