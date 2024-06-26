--Tạo bảng: create table
/*
conment nhiều dòng 
*/
create table NhaCC(
	-- định nghĩa từng cột trong bảng(tên cột, kiểu dữ liệu,thuộc tính...)
	MaNhaCC char(3) not null, 
	TenNhaCC nvarchar(100) not null,
	DiaChi nvarchar(200) null,
	DienThoai nvarchar(20) not null,
	-- định nghĩa khóa chính:
	primary key(MaNhaCC)
);
-- xóa đối tượng:drop -> thực thể tồn tại thì xóa đi
-- drop table: xóa cấu trúc 1 bảng
drop table NhaCC; -- xóa tất cả liên quan đến NhaCC (table, ràng buộc, và tất cả dữ liệu bảng đang chứa)
truncate table NhaCC;--xóa tất cả dữ liệu đang chứa trong bảng NhaCC
delete from NhaCC;-- xóa tất cả dữ liệu đang chứa trong NhaCC, nhưng lệnh DELETE có thể xóa theo điều kiện
delete from NhaCC where DienThoai is not null;
-- cập nhật cấu trúc 1 thực thể -> tồn tại rồi và bổ sung, sửa: alter
-- bảng NhaCC đã tồn tại nhưng chưa có cột email -> thêm  add table ... add column <thông tin cột: <tên cột> <loại cột> <thuộc tính>>

alter table NhaCC add EMAIL varchar(50) null;
-- xóa 1 cột đã tồn tại trong 1 bảng:
-- alter table <tên bảng> drop <tên cột cần xóa>
alter table NhaCC drop column EMAIL;
-- lệnh truy vấn: lấy dữ liệu đang có trong bảng
select * from NhaCC;
-- cập nhật lại kiểu/ thuộc tính của 1 cột đã tồn tại trong bảng: alter column
alter table NhaCC alter column DienThoai numeric(10, 0) null;

----- các kiểu dữ liệu cơ bản trong SQL Server----
/*
1.Nhóm kiểu số: kiểu số nguyên(int, smallint, bigint), số thực(float)
				số(numeric(<số phần nguyện>, <số phần thập phân>)
VD: 1, 1.1, 1000.333
2. nhóm chuỗi:
char(<số ký tự>): chuỗi có độ dài tối thiểu và tối đa là số ký tự ASCII
nchar(<số ký tự>): chuỗi có độ dài tối thiểu và tối đa là số ký tự Unicode(có dấu)
varchar(<số ký tự>): chuỗi có độ dài tối đa là số ký tự tối thiểu(null/0) Unicode(có dấu)
text: chuỗi cực lớn
VD:  'quandh', N'quân', 1.111
3. kiểu dữ liệu đặc biệt
datetime: thời gian ( ngày, giờ, ...)
date:ngày

*/
--Tạo bảng DonDH
create table DonDH (
	SoDH char(4) primary key,
	NgayDH datetime not null,
	MaNhaCC char(3),
-- tạo khóa ngoài : contrains
-- foreign key (<tên cột khóa ngoài>) references <tên bảng tham chiếu> (cột chính)
	foreign key(MaNhaCC) references NhaCC(MaNhaCC)
);
create table CTDonDH(
	SoDH char(4),
	MaVTu char(4),
	SLDat int check(SLDat>0), -- ràng buộc dữ liệu cột SLDat là số nguyên dương
	primary key(SoDH, MaVTu), -- 1 bảng chỉ có duy nhất 1 khóa chính (khóa chính có thể là tổ hợp 1 hoặc nhiều cột)
	foreign key (MaVTu) references VatTu(MaVTu),
	foreign key (SoDH) references DonDH(SoDH)

);
create table Pxuat(
	SoPX char(4) primary key,
	NgayXuat datetime not null,
	TenKH nvarchar(100)
);
create table CTPXuat(
	SoPX char(4) ,
	MaVTu char(4) ,
	SLXuat int not null,
	DGXuat money not null,
	primary key(SoPX,MaVTu),
	foreign key (MaVTu) references VatTu(MaVTu),
	foreign key (SoPX) references Pxuat(SoPX)
);

create table Pnhap(
	SoPN char(4) primary key not null,
	NgayNhap datetime not null,
	SoDH char(4) not null,

	-- tạo constrain
	foreign key (SoDH) references DonDH(SoDH)	
);

-- tạo bảng CTPnhap
create table CTPnhap(
	SoPN char(4) not null,
	MaVTu char(4) not null,
	SLNhap int check(SLNhap > 0) 
	primary key (SoPN,MaVTu),

	foreign key (SoPN) references Pnhap(SoPN),
	foreign key (MaVTu) references VatTu(MaVTu)
);

create table Pnhap(
	SoPN char(4) primary key not null,
	NgayNhap datetime not null,
	SoDH char(4) not null,

	-- tạo constrain
	foreign key (SoDH) references DonDH(SoDH)	
);

create table TonKho(
	NamThang char(4),
	MaVTu char(4),
	primary key (NamThang, MaVtu),
	foreign key (MaVTu) references VatTu(MaVTu),
	SLDau int not null,
	TongSLN int check (TongSLN > 0),
	TongSLX int check (TongSLX > 0),
	SLCuoi int check (SLCuoi > 0)

);


/*
Câu 1: Tạo các ràng buộc cho bảng VATTU
•	Tên vật tư phải duy nhất
•	0 <= PhanTram <= 100
•	Giá trị mặc định cho cột đơn vị tính là ‘Tấn’

*/
alter table VatTu add constraint UQ_VatTu_TenVtu unique(TenVTu);
alter table VatTu add constraint CK_VatTu_PhanTram_0_100 check( PhanTram>=0 and PhanTram <=100);
alter table VatTu add constraint DF_VatTu_DVTinh default N'Tấn' for DVTinh;

alter table drop constraint UQ_VatTu_TenVtu;
/*
Câu 2: Tạo các ràng buộc cho bảng NHACC
•	Tên nhà cung cấp và địa chỉ nhà cung cấp phải duy nhất
•	Giá trị mặc định cho cột điện thoại là ‘Chưa có’
Câu 3: Tạo các ràng buộc cho bảng DONDH
•	Giá trị mặc định cho cột ngày đặt hàng là ngày hiện hành


*/
alter table NhaCC add constraint UQ_NhaCC_TenNhaCC_DiaChi unique(TenNhaCC, DiaChi);
alter table NhaCC add constraint DF_NhaCC_DienThoai default N'Chưa có' for DienThoai;
alter table DonDH add constraint DF_DonDH_NgayDH default GETDATE() for NgayDH;
--GETDATE(): lấy thời gian hiện tại
