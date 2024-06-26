use quanlysinhvien;

create table khoa(
	makhoa char(6) not null,
	tenkhoa nvarchar(100)
);
alter table khoa add constraint pk_khoa primary key(makhoa);

create table lop(
	malop char(6) not null,
	tenlop nvarchar(100),
	makhoa char(6)
);
alter table lop add constraint pk_lop primary key(malop);
alter table lop add constraint fk_lop_khoa foreign key (makhoa) references khoa(makhoa);

create table sinhvien(
	masv char(8) not null,
	tensv nvarchar(100),
	gioitinh int,
	ngaysinh datetime,
	malop char(6)
);
alter table sinhvien add constraint pk_sinhvien primary key(masv);
alter table sinhvien add constraint fk_sinhvien_lop foreign key (malop) references lop(malop);
alter table sinhvien add constraint ck_sinhvien_gtinh check (gioitinh in(0,1,2));

create table giangvien(
	magv char(6) not null,
	tengv nvarchar(100),
	chuyennganh nvarchar(100),
	makhoa char(6)
);
alter table giangvien add constraint pk_giangvien primary key(magv);
alter table giangvien add constraint fk_giangvien_khoa foreign key (makhoa) references khoa(makhoa);

create table monhoc(
	mamh char(6) not null,
	tenmh nvarchar(100),
	sogio int
);
alter table monhoc add constraint pk_monhoc primary key(mamh);

create table diemthi(
	masv char(8) not null,
	mamh char(6) not null,
	lanthi int not null,
	diemthi float
);
alter table diemthi add constraint pk_diemthi primary key(masv, mamh, lanthi);
alter table diemthi add constraint fk_diemthi_sinhvien foreign key (masv) references sinhvien(masv);
alter table diemthi add constraint fk_diemthi_monhoc foreign key (mamh) references monhoc(mamh);

insert into khoa values('CNTT',N'Công nghệ thông tin');
insert into khoa values('DTVT',N'Điện tử viễn thông');
insert into khoa values('KHMT',N'Khoa học máy tính');
insert into khoa values('MMT',N'Mạng máy tính');
insert into khoa values('VLKT',N'Vật lý kỹ thuật');
insert into khoa values('CNVT',N'Công nghệ vũ trụ');

insert into lop values ('T0001',N'CNTT_T0001','CNTT');
insert into lop values ('T0002',N'CNTT_T0002','CNTT');
insert into lop values ('T0003',N'CNTT_T0003','CNTT');
insert into lop values ('D0001',N'DTVT_D0001','DTVT');
insert into lop values ('D0002',N'DTVT_D0002','DTVT');
insert into lop values ('K0001',N'KHMT_K0001','KHMT');
insert into lop values ('M0001',N'MMT_M0001','MMT');
insert into lop values ('M0002',N'MMT_M0001','MMT');

insert into sinhvien values ('SV000001',N'Nguyễn Thị A', 1, '20011020','T0001');
insert into sinhvien values ('SV000002',N'Nguyễn Thị B', 1, '20030101','T0001');
insert into sinhvien values ('SV000003',N'Nguyễn Văn C', 0, '20000708','T0001');
insert into sinhvien values ('SV000004',N'Lê Thị D', 1, '20010902','T0001');
insert into sinhvien values ('SV000005',N'Hoàng Thị E', 1, '20010102','T0001');
insert into sinhvien values ('SV000006',N'Lò Huy F', 0, '20011112','T0001');
insert into sinhvien values ('SV000007',N'Mai Thị G', 1, '20011127','T0001');
insert into sinhvien values ('SV000008',N'Nguyễn Thị H', 1, '20011025','T0001');
insert into sinhvien values ('SV000009',N'Hà Mạnh I', 0, '20010506','T0001');
insert into sinhvien values ('SV000010',N'Phạm Thị K', 1, '20010607','T0001');

insert into sinhvien values ('SV000101',N'Nguyễn Thị A3', 1, '20011020','D0001');
insert into sinhvien values ('SV000102',N'Nguyễn Thị B3', 1, '20030101','D0001');
insert into sinhvien values ('SV000103',N'Nguyễn Văn C3', 0, '20000708','D0001');
insert into sinhvien values ('SV000104',N'Lê Thị D3', 1, '20010902','D0001');
insert into sinhvien values ('SV000105',N'Hoàng Thị E3', 1, '20010102','D0001');
insert into sinhvien values ('SV000106',N'Lò Huy F3', 0, '20011112','D0001');
insert into sinhvien values ('SV000107',N'Mai Thị G3', 1, '20011127','D0001');
insert into sinhvien values ('SV000108',N'Nguyễn Thị H3', 1, '20011025','D0001');
insert into sinhvien values ('SV000109',N'Hà Mạnh I3', 0, '20010506','D0001');
insert into sinhvien values ('SV000110',N'Phạm Thị K3', 1, '20010607','D0001');

insert into sinhvien values ('SV001103',N'Nguyễn Văn C115', 0, '20000708','K0001');
insert into sinhvien values ('SV001104',N'Lê Thị D115', 1, '20010902','K0001');
insert into sinhvien values ('SV001105',N'Hoàng Thị E115', 1, '20010102','K0001');
insert into sinhvien values ('SV001106',N'Lò Huy F115', 0, '20011112','K0001');
insert into sinhvien values ('SV001107',N'Mai Thị G115', 1, '20011127','K0001');
insert into sinhvien values ('SV001108',N'Nguyễn Thị H115', 1, '20011025','K0001');
insert into sinhvien values ('SV001109',N'Hà Mạnh I115', 0, '20010506','K0001');
insert into sinhvien values ('SV001110',N'Phạm Thị K115', 1, '20010607','K0001');

insert into sinhvien values ('SV003301',N'Nguyễn Thị A333', 1, '20011020','M0001');
insert into sinhvien values ('SV003302',N'Nguyễn Thị B333', 1, '20030101','M0001');
insert into sinhvien values ('SV003303',N'Nguyễn Văn C333', 0, '20000708','M0001');
insert into sinhvien values ('SV003304',N'Lê Thị D333', 1, '20010902','M0001');
insert into sinhvien values ('SV003305',N'Hoàng Thị E333', 1, '20010102','M0001');
insert into sinhvien values ('SV003306',N'Lò Huy F333', 0, '20011112','M0001');
insert into sinhvien values ('SV003307',N'Mai Thị G333', 1, '20011127','M0001');

insert into giangvien values ('GV0001',N'Võ Đình Hiếu','KTPM','CNTT');
insert into giangvien values ('GV0002',N'Nguyễn Đức Thành','KTPM','CNTT');
insert into giangvien values ('GV0003',N'Lê Thị Thanh','MKT','MMT');

insert into monhoc values ('MH0001',N'Công nghệ phần mềm',5);
insert into monhoc values ('MH0002',N'Toán rời rạc',5);
insert into monhoc values ('MH0003',N'Tiếng anh cơ bản',4);
insert into monhoc values ('MH0004',N'Tiếng anh chuyên ngành',5);
insert into monhoc values ('MH0005',N'Triết học Mác LêNin',3);
insert into monhoc values ('MH0006',N'Tư tưởng Hồ Chí Minh',3);
insert into monhoc values ('MH0007',N'Trí tuệ nhân tạo',2);
insert into monhoc values ('MH0008',N'Khai phá dữ liệu',3);


--This generates a random number between 0-9
-- SELECT ABS(CHECKSUM(NEWID()) % 10)

--This generates a random number between 0-10
-- SELECT ABS(CHECKSUM(NEWID()) % 10)+1

insert into diemthi(masv, mamh, lanthi, diemthi)
select a.masv, b.mamh, 1, CAST((SELECT ABS(CHECKSUM(NEWID()) % 10)+1) AS NUMERIC(18,2)) 
from sinhvien a cross join monhoc b;

insert into diemthi(masv, mamh, lanthi, diemthi)
select a.masv, b.mamh, 2, CAST((SELECT ABS(CHECKSUM(NEWID()) % 10)+1) AS NUMERIC(18,2)) from sinhvien a cross join monhoc b
where b.mamh in ('MH0001','MH0004');

select * from diemthi;






