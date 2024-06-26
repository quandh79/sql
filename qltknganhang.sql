create database qltknganhang;
use qltknganhang;
create table khachhang(
	makh char(3) primary key,
	tenkh nvarchar(50) not null,
	diachi nvarchar(100) null,
	sdt char(10)


);
create table taikhoan(
	sotk char(4) primary key,
	makh char(3),
	kieutk varchar(50),
	ngaymotk date,
	foreign key (makh)
	references khachhang(makh)



);

insert into khachhang (makh, tenkh, diachi, sdt)
values
('1', N'Đỗ Hồng Quân', N'Nam Từ Liêm, Hà Nội', '0354429977'),
('2', N'Nguyễn Ngọc Minh', N'Cầu Giấy, Hà Nội', '0111111111'),
('3', N'Lê Thị Hương', N'Hà Đông, Hà Nội', '0222222222'),
('4', N'Trần Ngọc Mai', N'Quận1, HCM', '0333333333'),
('5', N'Phạm Đình Thành', N'TP Nam Định', '0444444444'),
('6', N'Đỗ Tuấn Hưng', N'Hải Phòng', '0555555555');


insert into taikhoan(sotk, makh, kieutk, ngaymotk)
values
('11', '1', N'Checking', '20160102'),
('22', '2', N'Tài khoản cá nhân trong nước', '20170102'),
('33', '3', N'Tài khoản doanh nghiệp trong nước', '20180102'),
('44', '4', N'Checking', '20160102'),
('55', '5', N'Tài khoản cá nhân trong nước', '20190102'),
('66', '6', N'Checking', '20200102');

select * from khachhang;
select * from taikhoan;
select * from taikhoan where kieutk in ('checking');
select makh, sotk, kieutk, ngaymotk from taikhoan
where kieutk in ('Tài khoản cá nhân trong nước') order by ngaymotk DESC;
select tenkh, diachi from khachhang where diachi in (' , Hà Nội') order by tenkh ASC;
