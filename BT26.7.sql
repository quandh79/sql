-- tao csdl moi
create database t2202e_practice;
use t2202e_practice;
-- tao bang
-- bang danh muc sach:
create table category(
	id int identity, -- identity: truong tu tang
	name nvarchar(50),
	primary key (id)

);
-- bang du lieu sach:
create table book(
	id int identity,
	name nvarchar(50),
	title nvarchar(100),
	author nvarchar(50),
	price money,
	pushlish date,
	category_id int foreign key references category(id),
	primary key (id)

);

--Thêm 3 bản ghi dữ liệu danh mục
insert into category(name) 
	values (N'Tieu Thuyet'),
			(N'Trinh Tham'),
			(N'Van Hoc');
select * from category;
--Thêm 5 bản ghi sách
insert into book(name, title,author, price, pushlish, category_id )
values	(N' cuon theo chieu gio', N' cuon theo chieu gio', N'Peter', 120000, '19810101', 1 ),
	(N' Conan tap1', N' Conan', N'Fuijo', 55000, '20001205', 2 ),
	(N' Conan tap2', N' Conan', N'Fuijo', 55000, '20001205', 2 ),
	(N' Conan tap3', N' Conan', N'Fuijo', 55000, '20001205', 2 ),
	(N' nguoi lai do song da', N' Van hoc duong dai', N'nguyen Tuan', 79000, '19650405', 3 );
-- Lấy thông tin danh sách sách và danh mục của nó
-- book, category -> JOIN, -> lay tat ca sach -> left join
select b.*, c.name from book b left join category c on b.category_id = c.id;
	
--+ Lấy thông tin sách có giá  > 100000
select b.*, c.name from book b left join category c on b.category_id = c.id
where price > 100000;
-- + Tính số lượng sách theo danh mục
-- danh muc: category_id, name, so luong: count
select b.category_id, c.name category_name, count(b.id) book_count 
from book b 
left join category c on b.category_id = c.id
group by b.category_id,c.name ;
	
--Viết 1 thủ tục để cập nhật 1 quyển sách
-- validate thong tin dau vao va update khi du lieu dung
create procedure pr_update_book(

-- thong tin input/ output
	@id int, --- ma sach can update
	@name nvarchar(50),
	@title nvarchar(100),
	@author nvarchar(50),
	@price money,
	@pushlish date,
	@category_id int,
	@rescode int out, -- ma ket qua
	@resdesc nvarchar(200) out -- mo ta ket qua
)as 
begin
-- khoi lenh
-- check xem id co ton tai khong ?
if (select count(*) from category where id = @id)=0
begin
			set @rescode = -1;
			Set @resdesc = N' sach khong tin tai ';
			return;
		end;-- dong khoi if

-- b1: check input

-- check ten sach rong
	if @name is null or len(@name) = 0
		begin
			set @rescode = -1;
			Set @resdesc = N'Ten sach dang trong';
			return;
		end;-- dong khoi if
-- titlle sach rong
if @title is null or len(@title) = 0
		begin
			set @rescode = -1;
			Set @resdesc = N'Tieu de sach dang trong';
			return;
		end;-- dong khoi if
-- author rong
if @author is null or len(@author) = 0
		begin
			set @rescode = -1;
			Set @resdesc = N'Tac gia sach dang trong';
			return;
		end;-- dong khoi if
-- price >0
if @price <=0
		begin
			set @rescode = -1;
			Set @resdesc = N'Gia sach phai lon hon 0 ';
			return;
		end;-- dong khoi if
		-- check danh muc phai ton tai
if (select count(*) from category where id = @category_id)=0
begin
			set @rescode = -1;
			Set @resdesc = N'Danh muc sach khong tin tai ';
			return;
		end;-- dong khoi if
-- b2: update
update book set name = @name, title = @title, author = @author,
price = @price, pushlish = @pushlish, category_id = @category_id
where id = @id
set @rescode = 1;
set @resdesc = ' success';
end;
-- goi thu tuc de cap nhat du lieu
begin -- bat dau goi thu tuc
-- dinh nghia cac tham so out
	declare @rescode int;  -- ma ket qua
	declare @resdesc nvarchar(200) ; -- mo ta ket qua
	-- thuc thi procedure cho viec cap nhat
	exec pr_update_book 4, N' Conan tap99', N' Conan', N'Fuijo', 55000, '20001205', 2,
		@rescode out , @resdesc out;
	-- in ra ket qua tra ve
	print concat(N'ma ket qua', @rescode, N'; mo ta ket qua', @resdesc);
end;-- ket thuc goi thu tuc

select * from book;

-- tao chi muc index cho cot name, title, author cho viec tim kiem sach
-- ho tro tim kiem nha nhanh tren cac cot chi muc
-- cac cot khong phai khoa chinh -> nonclustered index
create index idx_book_searchtext on book(name, title, author);