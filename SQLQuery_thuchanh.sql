-- tạo csdl mới
create database t2202e_practice;
use t2202e_practice;

-- Tạo bảng:
-- bảng danh mục sách: 
create table category(
	id int identity, -- identity: trường tự tăng khi insert
	name nvarchar(50),
	primary key (id)
);
-- bảng dữ liệu sách:
create table book (
	id int identity,
	name nvarchar(100),
	title nvarchar(100),
	author nvarchar(50),
	price money,
	publish date,
	category_id int foreign key references category(id),
	primary key (id)
);
-- Thêm 3 bản ghi dữ liệu danh mục
insert into category(name) 
	values (N'Tiểu thuyết'),
			(N'Trinh thám'),
			(N'Văn học');
select * from category;

-- Thêm 5 bản ghi sách
insert into book(name, title, author, price, publish, category_id)
values (N'Cuốn theo chiều gió',N'Cuốn theo chiều gió',N'Peter', 120000, '19810215', 1),
		(N'Conan Tập 1',N'Conan',N'Fujio',55000,'20001205',2),
		(N'Conan Tập 2',N'Conan',N'Fujio',55000,'20001205',2),
		(N'Conan Tập 3',N'Conan',N'Fujio',55000,'20001205',2),
		(N'Người lái đò sông Đà',N'Văn học đương đại',N'Nguyễn Tuân', 79000,'19650405',3);
select * from book;
-- + Lấy thông tin danh sách sách và danh mục của nó
-- book, category -> JOIN -> lấy tất cả sách -> LEFT JOIN
select b.*, c.name from book b 
left join category c on b.category_id = c.id;
-- + Lấy thông tin sách có giá  > 100000
select b.*, c.name from book b 
left join category c on b.category_id = c.id
where b.price > 100000;
-- Tính số lượng sách theo danh mục: 
-- danh mục: category_id, name, số lượng: count
-- group by
select b.category_id, c.name category_name, count(b.id) book_count 
from book b 
left join category c on b.category_id = c.id
group by b.category_id, c.name;

-- + Viết 1 thủ tục để cập nhật 1 quyển sách 
--( validate thông tin đầu vào và update khi dữ liệu đúng)
create procedure pr_update_book(
-- thông tin input/ output
	@id int, -- mã sách cần update
	@name nvarchar(100),
	@title nvarchar(100),
	@author nvarchar(50),
	@price money,
	@publish date,
	@category_id int,
	@rescode int out, -- mã kết quả
	@resdesc nvarchar(200) out -- mô tả kết quả
) as
begin
-- khối lệnh
-- check input
	-- check id sách có tồn tại hay không?
	if (select count(*) from book where id =@id) = 0
	begin
		set @rescode = -1;
		set @resdesc = N'Sách không tồn tại.';
		return;
	end; -- đóng khối if
	-- check tên sách rỗng
	if @name is null or len(@name) = 0
	begin
		set @rescode = -1;
		set @resdesc = N'Tên sách đang trống';
		return;
	end; -- đóng khối if
	-- check tiêu đề sách rỗng
	if @title is null or len(@title) = 0
	begin
		set @rescode = -1;
		set @resdesc = N'Tiêu đề sách đang trống';
		return;
	end; -- đóng khối if
	-- check tác giả rỗng
	if @author is null or len(@author) = 0
	begin
		set @rescode = -1;
		set @resdesc = N'Tác giả sách đang trống';
		return;
	end; -- đóng khối if
	-- check giá > 0
	if @price <=0 
	begin
		set @rescode = -1;
		set @resdesc = N'Giá sách phải > 0';
		return;
	end; -- đóng khối if
	-- check danh mục sách phải tồn tại:
	if (select count(*) from category where id=@category_id) = 0
	begin
		set @rescode = -1;
		set @resdesc = N'Danh mục sách không tồn tại';
		return;
	end; -- đóng khối if
-- update
	update book set name=@name, title=@title, author=@author,
	price=@price, publish=@publish, category_id=@category_id
	where id =@id;
	set @rescode = 1;
	set @resdesc = 'success';
end;

--- gọi thủ tục để cập nhật dữ liệu sách
begin -- bắt đầu gọi thủ tục
	-- định nghĩa các tham số out
	-- khởi tạo biến @rescode
	declare @rescode int; -- mã kết quả
	-- khởi tạo biến @resdesc
	declare @resdesc nvarchar(200); -- mô tả kết quả
	-- thực thi procedure cho việc cập nhật
	/*
	-- lệnh đúng
	exec pr_update_book 4, N'Conan tập 99', N'Tiểu thuyết nổi tiếng Conan', 'Fujio', 65000, '19950601', 2, 
						@rescode out, @resdesc out;
						*/
	-- input sai:
	exec pr_update_book 4, N'Conan tập 99', N'Tiểu thuyết nổi tiếng Conan', 'Fujio', 100000, '19950601', 6, 
						@rescode out, @resdesc out;
	-- in ra kết quả trả về
	print concat(N'Mã kết quả', @rescode,N'; mô tả kết quả:',@resdesc);
end; -- kết thúc gọi thủ tục

select * from book where name='Conan' or title like '%conan%';

-- Tạo chỉ mục index cho cột name, title, author cho việc tìm kiếm sách.
-- hỗ trợ tìm kiếm nhanh trên các cột chỉ mục
-- các cột không phải khóa chính -> nonclustered index
create index idx_book_searchtext on book(name, title, author);


