Create database DETHISQL
Use DETHISQL
gsdsfsfeg
-- Tạo cơ sở dữ liệu như lược đồ đã cho ở trên. Học viên tự định nghĩa kiểu dữ liệu của các cột trong các bảng
GO
Create table THONGTIN_CHUXE
(
	MaChuXe varchar (10) primary key not null,
	HoTen varchar (100) not null,
	GioiTinh varchar (3) not null,
	SoCMND varchar (12) not null,
	NgaySinh date not null,
	SoDienThoai varchar (10) not null,
	DiaChi varchar (50) not null
)

Create table THONGTIN_XE
( 
	BienSoXe varchar (15) primary key not null,
	HangXe varchar (30) not null,
	LoaiXe varchar (30) not null,
	SoChoNgoi int not null,
	MaChuXe varchar (10) not null foreign key (MaChuXe) references THONGTIN_CHUXE
)
Alter table THONGTIN_XE
Add MoTa varchar (100)

Create table NHAN_VIEN
(
	MaNhanVien varchar (10) primary key not null,
	HoTen varchar (100) not null,
	DienThoai varchar (10) not null,
	ViTri nvarchar (50) not null
)

Create table VI_TRI
(
	MaChoDauXe varchar (10) primary key not null,
	DienTichViTriDo int not null,
	PhiTraTrenThang numeric (15,0) not null
)

Create table HOP_DONG_KY_Goi
(
	SoHopDong varchar (10) primary key not null,
	BienSoXe varchar (15) not null foreign key (BienSoXe) references THONGTIN_XE,
	MaChoDauXe varchar (10) not null foreign key (MaChoDauXe) references VI_TRI,
	ThoiGianBatDau date not null,
	ThoiGianKetThuc date not null,
	TienCoc numeric (15,0) not null,
	TinhTrangKhiGoi varchar (14) not null,
	MucGiaTroBan numeric (15,0) not null,
	MaNhanVienLapHopDong varchar (10) not null,
	MucDichKyGoi varchar (3) not null,
	CONSTRAINT FK_MaNV FOREIGN KEY (MaNhanVienLapHopDong) REFERENCES NHAN_VIEN(MaNhanVien) 
)

-- 3. Liệt kê thông tin của tất cả các xe có số chỗ ngồi lớn hơn 5.
GO
Select *
From	THONGTIN_XE
Where	SoChoNgoi > 5

-- 4. Liệt kê thông tin của tất cả các chủ xe có họ tên bắt đầu là một trong các ký tự ‘T’, ‘H’ hoặc ‘M’ và có độ dài ít nhất 10 ký tự.
GO 
Select *
From	THONGTIN_CHUXE
Where	HoTen like 'T%' or HoTen like 'H%' or HoTen like 'M%' and LEN(HoTen) >= 10
--Thực tế đối với độ dài của biến thì nên lưu độ dài sẵn chứ không xài hàm


-- 5. Liệt kê MaChuXe, HoTen, BienSoXe, SoHopDong, ThoiGianBatDau, ThoiGianKetThuc, MucDichKyGoi của tất cả các xe có ThoiGianBatDau và ThoiGianKetThuc ký gởi nằm trong quý 1 năm 2020 và có MucDichKyGoi la ‘Ban’.
GO
Select	THONGTIN_CHUXE.MaChuXe, HoTen, THONGTIN_XE.BienSoXe, SoHopDong, ThoiGianBatDau, ThoiGianKetThuc, MucDichKyGoi
From	HOP_DONG_KY_Goi JOIN THONGTIN_XE ON HOP_DONG_KY_Goi.BienSoXe = THONGTIN_XE.BienSoXe
						JOIN THONGTIN_CHUXE ON THONGTIN_XE.MaChuXe = THONGTIN_CHUXE.MaChuXe
Where	MONTH(ThoiGianBatDau) between 1 and 3 AND YEAR(ThoiGianBatDau) = 2020 AND MONTH(ThoiGianKetThuc) between 1 and 3 AND YEAR(ThoiGianKetThuc) = 2020 AND MucDichKyGoi = 'Ban'
-- Thường người dùng mong muốn sẽ lấy hết trong 1 quý (kể cả khi thời gian kết thúc nằm ngoài quý) -> dùng or

-- 6. Liệt kê MaChuXe, HoTen, SoDienThoai, SoCMND, NgaySinh, GioiTinh, MucDichKyGoi, SoLuongXeSoHuu (được tính tương ứng với mỗi chủ xe sở hữu bao nhiêu Xe), có mục đích ký gởi xe là ‘Ban’. Kết quả phải được sắp xếp tăng dần theo SoLuongXeSoHuu.
GO
Select	THONGTIN_XE.MaChuXe, HoTen, SoDienThoai, SoCMND, NgaySinh, GioiTinh, MucDichKyGoi,
		count(THONGTIN_XE.MaChuXe) as SoLuongXeSoHuu
From	HOP_DONG_KY_Goi JOIN THONGTIN_XE ON HOP_DONG_KY_Goi.BienSoXe = THONGTIN_XE.BienSoXe
						JOIN THONGTIN_CHUXE ON THONGTIN_XE.MaChuXe = THONGTIN_CHUXE.MaChuXe
Where	MucDichKyGoi = 'Ban'
Group by THONGTIN_XE.MaChuXe, HoTen, SoDienThoai, SoCMND, NgaySinh, GioiTinh, MucDichKyGoi
Order by SoLuongXeSoHuu ASC

-- 7. Liệt kê tất cả các Xe thuộc Hãng xe là ‘Kia’ và đã từng được thực hiện ký gởi tại Chợ xe trong khoảng thời gian từ tháng 1 năm 2020 đến tháng 12 năm 2020 (mốc thời gian sử dụng ThoiGianBatDau để tính).
GO
Select THONGTIN_XE.BienSoXe, ThoiGianBatDau, HangXe
From HOP_DONG_KY_Goi JOIN THONGTIN_XE ON HOP_DONG_KY_Goi.BienSoXe = THONGTIN_XE.BienSoXe
Where MONTH(ThoiGianBatDau) between 1 and 12 AND YEAR(ThoiGianBatDau) = 2020 AND HangXe = 'Kia'
--Nếu có giờ thì lấy 00:00 của ngày 1 năm sau hoặc nếu không có giờ thì lấy ngày 1 tháng sau trừ đi 1 ngày

-- 8. Liệt kê thông tin Họ tên của tất cả các Nhân viên có trong hệ thống, Nhân viên nào có Họ tên trùng nhau thì chỉ liệt kê 1 lần.
GO
Select DISTINCT HoTen
From NHAN_VIEN
Order by HoTen


-- 9. Liệt kê MaChuXe, SoDienThoai, BienSoXe, LoaiXe, MaChoDauXe, ThoiGianBatDau, ThoiGianKetThuc, PhiTraTrenThang của tất cả các chủ xe đã từng thực hiện ký gởi ít nhất 2 loại xe ô tô khác nhau và thời gian ký gởi (sử dụng ThoiGianBatDau) nhỏ hơn thời gian hiện tại (sử dụng ngày của hệ thống) là 6 tháng.
GO 
Select	THONGTIN_XE.MaChuXe, THONGTIN_CHUXE.SoDienThoai, THONGTIN_XE.BienSoXe, LoaiXe, HOP_DONG_KY_Goi.MaChoDauXe, ThoiGianBatDau, ThoiGianKetThuc, PhiTraTrenThang
From	HOP_DONG_KY_Goi JOIN VI_TRI ON HOP_DONG_KY_Goi.MaChoDauXe = VI_TRI.MaChoDauXe
						JOIN THONGTIN_XE ON HOP_DONG_KY_Goi.BienSoXe = THONGTIN_XE.BienSoXe
						JOIN THONGTIN_CHUXE ON THONGTIN_XE.MaChuXe = THONGTIN_CHUXE.MaChuXe
Where	ThoiGianBatDau between DATEADD(mm,-6,getdate()) and GETDATE() 
Group by THONGTIN_XE.MaChuXe, THONGTIN_CHUXE.SoDienThoai, THONGTIN_XE.BienSoXe, LoaiXe, HOP_DONG_KY_Goi.MaChoDauXe, ThoiGianBatDau, ThoiGianKetThuc, PhiTraTrenThang
Having LoaiXe in (Select LoaiXe from THONGTIN_XE Group by MaChuXe, LoaiXe Having count(LoaiXe) >= 2)
--Having là điều kiện của group by

-- 10. Liệt kê BienSoXe, LoaiXe, SoChoNgoi của những Xe ô tô đã từng thực hiện 
--đăng ký ký gởi tại Chợ xe trong năm 2020 (sử dụng ThoiGianBatDau để tính) 
--có số chỗ ngồi nhỏ hơn 24 chỗ và những Xe ô tô chưa từng thực hiện đăng ký ký gởi với 
--mục đích ký gởi là “Giu’ lần nào.
--Mở rộng đề: Thêm một cột thể hiện TH thỏa mãn điều kiện nào, Sắp xếp số chỗ ngồi theo số lẻ ở trên chẵn ở dưới
GO
Select THONGTIN_XE.BienSoXe, LoaiXe, SoChoNgoi, ThoiGianBatDau, MucDichKyGoi,
		MoTa =	Case When YEAR(ThoiGianBatDau) = '2020' AND SoChoNgoi < 24 then N'TH1'
					When MucDichKyGoi not like 'Giu' then 'TH2'
				End 
From HOP_DONG_KY_Goi JOIN THONGTIN_XE ON HOP_DONG_KY_Goi.BienSoXe = THONGTIN_XE.BienSoXe
Where (YEAR(ThoiGianBatDau) = '2020' AND SoChoNgoi < 24) OR MucDichKyGoi not like 'Giu' 
Order by Case When SoChoNgoi %2 = 1 Then 0 
				Else 1
		End ASC

-- 11. Liệt kê thông tin của tất cả các Xe ô tô chưa từng được ký gởi trong năm 2019 
--mà đã từng được ký gởi trong năm 2020.
GO
Select THONGTIN_XE.BienSoXe, LoaiXe, SoChoNgoi, ThoiGianBatDau, MucDichKyGoi
From HOP_DONG_KY_Goi JOIN THONGTIN_XE ON HOP_DONG_KY_Goi.BienSoXe = THONGTIN_XE.BienSoXe
Where YEAR(ThoiGianBatDau) = 2020 
	AND HOP_DONG_KY_Goi.BienSoXe not in (Select BienSoXe From HOP_DONG_KY_Goi 
											Where YEAR(ThoiGianBatDau) = 2019)  

-- 12. Cập nhật thông tin trên cột TienCoc của bảng HOP_DONG_KY_GOI giảm bớt 20% so với 
--TienCoc hiện tại đối với những Xe được đăng ký ký gởi sau năm 2021.
GO
Update HOP_DONG_KY_Goi
Set TienCoc = TienCoc - (TienCoc * 0.2)
Where ThoiGianBatDau > '2021-01-01'

--13. Lấy danh sách hợp đồng mới nhất của các xe
Select * 
From	(Select SoHopDong, BienSoXe, ThoiGianBatDau,
		ROW_NUMBER() Over(Partition by BienSoXe Order by ThoiGianBatDau DESC) as Num
		From HOP_DONG_KY_Goi) as Bang
Where	Num = 1



