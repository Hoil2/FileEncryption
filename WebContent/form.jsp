<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>20224004 김홍일</title>
</head>
<body>
	<h3>파일을 암호화, 복호화해서 다운로드하는 서비스를 제공합니다.</h3>
	<p>암호는 16 byte까지만 설정되고 나머지는 짤리게 됩니다.</p>
	<form action="proc.jsp" method="post" enctype="multipart/form-data">
		<input type="file" name="file"/><br>
		<input type="radio" name="category" value="encrypt" checked /> 암호화 <br>
		<input type="radio" name="category" value="decrypt"/> 복호화 <br> 
		암호 : <input type="password" name="password" size="8"/><br><br>
		<input type="submit" value="변환"/>
	</form>
</body>
</html>