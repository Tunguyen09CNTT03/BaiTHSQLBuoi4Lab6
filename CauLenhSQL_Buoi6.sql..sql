--- 1. Cho biết danh sách các nhân viên có ít nhất một thân nhân
SELECT (NHANVIEN.HONV + ' ' + NHANVIEN.TENLOT + ' '+ NHANVIEN.TENNV) AS 'Họ tên nhân viên có ít nhất 1 thân nhân'
	FROM NHANVIEN, THANNHAN
	WHERE NHANVIEN.MANV= THANNHAN.MA_NVIEN
	GROUP BY (NHANVIEN.HONV + ' ' + NHANVIEN.TENLOT + ' '+ NHANVIEN.TENNV)
	HAVING COUNT(THANNHAN.MA_NVIEN) >= 1
--2. Cho biết danh sách các nhân viên không có thân nhân nào
	SELECT (NHANVIEN.HONV + ' ' + NHANVIEN.TENLOT + ' '+ NHANVIEN.TENNV) AS 'Họ tên nhân viên không có thân nhân'
	FROM NHANVIEN
	WHERE NHANVIEN.MANV NOT IN (SELECT THANNHAN.MA_NVIEN
								FROM NHANVIEN, THANNHAN
								WHERE NHANVIEN.MANV = THANNHAN.MA_NVIEN
								)
--3. Cho biết họ tên các nhân viên có trên 2 thân nhân.
	SELECT (NHANVIEN.HONV + ' ' + NHANVIEN.TENLOT + ' '+ NHANVIEN.TENNV) AS 'Họ tên nhân viên có trên 2 thân nhân'
	FROM NHANVIEN, THANNHAN
	WHERE NHANVIEN.MANV= THANNHAN.MA_NVIEN
	GROUP BY (NHANVIEN.HONV + ' ' + NHANVIEN.TENLOT + ' '+ NHANVIEN.TENNV)
	HAVING COUNT(THANNHAN.MA_NVIEN) > 2
--4. Danh  sách  những  trưởng  phòng   có  ít nhất một thân nhân.
	SELECT (NHANVIEN.HONV + ' ' + NHANVIEN.TENLOT + ' '+ NHANVIEN.TENNV) AS 'Họ tên trưởng phòng có ít nhất 1 thân nhân'
	FROM NHANVIEN, PHONGBAN
	WHERE NHANVIEN.MANV = PHONGBAN.TRPHG AND
		  PHONGBAN.TRPHG IN (SELECT THANNHAN.MA_NVIEN
							 FROM NHANVIEN, THANNHAN
							 WHERE NHANVIEN.MANV = THANNHAN.MA_NVIEN

							 )
--5. Cho biết họ tên nhân viên có mức lương trên mức lương trung bình của phòng "Quản lý".
SELECT (NHANVIEN.HONV + ' ' + NHANVIEN.TENLOT + ' ' + NHANVIEN.TENNV) AS 'Họ tên nhân viên có lương trung bình trên mức lương trung bình của phòng "Quản lý"'
FROM NHANVIEN
WHERE NHANVIEN.LUONG > (
	SELECT AVG(NHANVIEN.LUONG)
	FROM NHANVIEN, PHONGBAN
	WHERE NHANVIEN.PHG = PHONGBAN.MAPHG AND PHONGBAN.TENPHG = N'Quản lý'
) AND NHANVIEN.PHG = (
	SELECT MAPHG
	FROM PHONGBAN
	WHERE TENPHG = N'Quản lý'
)
--7. Cho biết họ tên nhân viên có mức lương trên mức lương trung bình của phòng mà nhân viên đó đang làm việc
SELECT (NHANVIEN.HONV + ' ' + NHANVIEN.TENLOT + ' ' + NHANVIEN.TENNV) AS 'Họ tên nhân viên có lương trung bình trên mức lương trung bình của phòng'
FROM NHANVIEN
INNER JOIN PHONGBAN ON NHANVIEN.PHG = PHONGBAN.MAPHG
WHERE NHANVIEN.LUONG > (
	SELECT AVG(NHANVIEN.LUONG)
	FROM NHANVIEN
	WHERE NHANVIEN.PHG = PHONGBAN.MAPHG
) 
--8. Cho biết tên phòng ban và họ tên trưởng phòng của phòng ban có đông nhân viên nhất.
SELECT PHONGBAN.TENPHG, (NHANVIEN.HONV + ' ' + NHANVIEN.TENLOT + ' ' + NHANVIEN.TENNV) AS 'Họ tên trưởng phòng của phòng ban đông nhân viên nhất'
	FROM NHANVIEN, PHONGBAN
	WHERE NHANVIEN.MANV = PHONGBAN.TRPHG AND
		  PHONGBAN.MAPHG = (SELECT TOP 1 PHONGBAN.MAPHG
							FROM NHANVIEN, PHONGBAN
							WHERE NHANVIEN.PHG = PHONGBAN.MAPHG
							GROUP BY PHONGBAN.MAPHG
							ORDER BY COUNT (NHANVIEN.PHG) DESC
							)
--9. Cho biết danh sách các đề án mà nhân viên có mã là 456 chưa tham gia.
SELECT DEAN.MADA
	FROM DEAN
	WHERE DEAN.MADA NOT IN (SELECT PHANCONG.MADA
							FROM PHANCONG
							WHERE PHANCONG.MA_NVIEN = '456'
							)
--10. Danh sách nhân viên gồm mã nhân viên, họ tên và địa chỉ của những nhân viên không sống tại TP Quảng Ngãi nhưng làm việc cho một đề án ở TP Quảng Ngãi.
SELECT DISTINCT NHANVIEN.MANV, (NHANVIEN.HONV + ' ' + NHANVIEN.TENLOT + ' ' + NHANVIEN.TENNV) AS 'Họ tên nhân viên', NHANVIEN.DCHI
	FROM NHANVIEN, DEAN, DIADIEM_PHG
	WHERE NHANVIEN.PHG = DEAN.PHONG AND
		  NHANVIEN.PHG = DIADIEM_PHG.MAPHG AND
		  DIADIEM_PHG.DIADIEM LIKE '%Quảng Ngãi' AND
		  NHANVIEN.DCHI NOT LIKE '%Quảng Ngãi' 
--11. Tìm họ tên và địa chỉ của các nhân viên làm việc cho một đề án ở một địa điểm nhưng lại không sống tại địa điểm đó.
SELECT DISTINCT (NHANVIEN.HONV + ' ' + NHANVIEN.TENLOT + ' ' + NHANVIEN.TENNV) AS 'Họ tên nhân viên', NHANVIEN.DCHI
FROM NHANVIEN, DEAN, DIADIEM_PHG
WHERE NHANVIEN.PHG = DEAN.PHONG 
      AND NHANVIEN.PHG = DIADIEM_PHG.MAPHG 
      AND DIADIEM_PHG.DIADIEM = 'địa điểm cần tìm' 
      AND NHANVIEN.DCHI <> 'địa chỉ cần loại trừ'
--12. Cho biết danh sách các mã đề án có: nhân công với họ là Lê hoặc có người trưởng phòng chủ trì đề án với họ là Lê.
SELECT PHANCONG.MADA
	FROM NHANVIEN, PHANCONG
	WHERE NHANVIEN.MANV = PHANCONG.MA_NVIEN AND
		  NHANVIEN.HONV = N'Lê'
	UNION --phép kết
	SELECT DEAN.MADA
	FROM NHANVIEN, PHONGBAN, DEAN
	WHERE NHANVIEN.MANV = PHONGBAN.TRPHG AND
		  PHONGBAN.MAPHG = DEAN.PHONG AND
		  NHANVIEN.HONV = N'Lê'
--13. Liệt kê danh sách các đề án mà cả hai nhân viên có mã số 123 và 789 cùng làm.
SELECT *
FROM DEAN
WHERE EXISTS (
  SELECT *
  FROM PHANCONG
  WHERE DeAn.MADA = PhanCong.MADA AND PhanCong.MA_NVIEN = 123
) AND EXISTS (
  SELECT *
  FROM PHANCONG
  WHERE DEAN.MADA = PhanCong.MADA AND PhanCong.MA_NVIEN = 789
);
--14. Liệt kê danh sách các đề án mà cả hai nhân viên Đinh Bá Tiến và Trần Thanh Tâm cùng làm
SELECT MANV
FROM NhanVien
WHERE HONV = 'Đinh Bá Tiến' OR HONV = 'Trần Thanh Tâm';

----- Liệt kê các đề án mà hai nhân viên này cùng làm
SELECT DEAN.MADA, DEAN.MADA
FROM DEAN
JOIN PHANCONG ON DEAN.MADA = PHANCONG.MADA
WHERE PHANCONG.MA_NVIEN IN (009, 003) AND DEAN.MADA IN (
  SELECT PHANCONG.MADA
  FROM PHANCONG
  WHERE PHANCONG.MA_NVIEN = 009
  INTERSECT
  SELECT PHANCONG.MADA
  FROM PHANCONG
  WHERE PHANCONG.MA_NVIEN = 003
);
--15. Danh sách những nhân viên (bao gồm mã nhân viên, họ tên, phái) làm việc trong mọi đề án của công ty
SELECT NHANVIEN.MANV, NHANVIEN.HONV + ' ' + NHANVIEN.TENLOT + ' ' + NHANVIEN.TENNV AS 'Họ tên', NHANVIEN.PHAI
FROM NHANVIEN
WHERE NOT EXISTS (
  SELECT *
  FROM DEAN
  WHERE NOT EXISTS (
    SELECT *
    FROM PHANCONG
    WHERE DEAN.MADA = PHANCONG.MADA AND PHANCONG.MA_NVIEN = NHANVIEN.MANV
  )
);
select *from nhanvien
select *from DEAN
