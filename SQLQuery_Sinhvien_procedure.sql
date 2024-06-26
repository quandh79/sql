use t2202e_qlsv;
/*
Thủ tục - procedure/ store: khối lệnh thực hiện 1 nhiệm vụ chung cho việc thao tác dữ liệu ( thêm mới, thay đổi, xóa dữ liệu )
mà không cần return kết quả trả về.
Thủ tục vẫn trả về nhiều kết quả ( nhiều biến )
*/
-- tạo thủ tục: tính học lực của 1 sinh viên ( thông qua mã sinh viên và mã môn học ) trả về: điểm cao nhất và học lực cao nhất trong các lần thi
drop proc pr_xepLoaiHocLuc
go
create proc pr_xepLoaiHocLuc(
	@masv varchar(10), -- tham số vào input ( truyền vào khi gọi thủ tục )
	@mamh varchar(6), -- tham số vào input
	@diem float out, -- tham số ra output ( trả ra khi thủ tục thực thi xong )
	@hocluc nvarchar(50) out -- tham số ra output ( trả ra khi thủ tục thực thi xong )
) as
-- mở đầu thân thủ tục
begin
	-- khối lệnh thực hiện tính học lực của 1 sinh viên ( gán giá trị cho các tham số out )
	-- b1: lấy thông tin điểm của sinh viên theo mã mh
	set @diem = (select max(diemthi) diemthi from diemthi where masv =@masv  and mamh = @mamh);
	if @diem is null 
		print N'Không tìm được điểm thi của sinh viên và môn học tương ứng.';
	else
		set @hocluc = dbo.fn_getHocLuc(@diem);
	-- b2: xét học lực
end; -- kết thúc khối lệnh thân thủ tục

-- sử dụng/ gọi thủ tục có tham số out ( lấy dữ liệu khi thủ tục chạy xong
begin
-- b1: tạo các biến out
	declare @diem float;
	declare @hocluc nvarchar(50);
-- b2: thực thi gọi thủ tục
--exec pr_xepLoaiHocLuc 'SV000001', 'MH0001', @diem out, @hocluc out;
exec pr_xepLoaiHocLuc '1122', 'MH0001', @diem out, @hocluc out;
-- b3: hiển thị kết quả
print concat(N'Điểm:', @diem, N'; Học lực:', @hocluc); 
end;
--- kết thúc gọi khối lênh

select * from diemthi;

-- Tạo thủ tục: thêm mới 1 thông tin giảng viên ( magv tự tăng )
create proc pr_createNewGiangVien (
	-- ds cac tham so ( truyền vào và biến trả về kết quả )
	@tengv nvarchar(100),
	@chuyennganh nvarchar(200),
	@makhoa varchar(10),
	@magv varchar(10) out,
	@result nvarchar(200) out
) as
begin
	-- validate du lieu
		-- neu ma khoa khong ton tai thi thong bao:
	if @makhoa is not null and (select count(*) from khoa where makhoa = @makhoa) = 0 
	begin
		set @result = N'Fail: Ma khoan không tồn tại';
		return; -- dung thu tuc khi đang thực thi tại đây
	end; -- ket thuc cua khoi lenh if
	-- thuc thi
	-- tính magv tự tăng mới nhất ( vừa khai báo vừa gán giá trị cho biến )
	declare @max_magv varchar(6) = (select max(magv) from giangvien);
	print concat('Max_gv:', @max_magv);
	-- tạo biến số đếm mới nhất của mã gv
	declare @next_number_magv int = (substring(@max_magv, 3,4) + 1);
	print concat('next_number_magv:', @next_number_magv);
	-- gán mã gv mới ( nối chuỗi 'GV' và chuỗi của format 4 ký tự của 1 số )
	set @magv = concat('GV', format(@next_number_magv,'0000'));
	print concat('Magv:', @magv);
	-- thêm 1 bản ghi giảng viên vào bảng
	insert into giangvien (magv, tengv, chuyennganh, makhoa) values (@magv, @tengv, @chuyennganh, @makhoa);
	-- gan ket qua
	set @result = 'success';
end; -- ket thuc tao thu tuc

-- dùng thủ tục/ thực thi thủ tục
begin
	-- b1: tạo các biến out
	declare @magv varchar(10);
	declare @result nvarchar(200);
	-- b2: thực thi gọi thủ tục
	exec pr_createNewGiangVien N'Hoàng Kim Thi', 'LT',null, @magv out, @result out;
	-- b3: hiển thị kết quả
	print concat('Ket qua: magv: ', @magv, '; kq:', @result);
end;
-- kết thúc dùng thủ tục/ thực thi thủ tục

select * from giangvien;
select FORMAT(4,'0000');


