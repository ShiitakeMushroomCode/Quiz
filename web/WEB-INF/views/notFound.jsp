<%@ page contentType="text/html; charset=UTF-8"
		 pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>페이지를 찾을 수 없습니다</title>
<link rel="icon"
	href="${pageContext.request.contextPath}/static/icons/favicon.ico"
	type="image/x-icon">
<style>
body {
	font-family: Arial, sans-serif;
	background-color: #f9f9f9;
	margin: 0;
	padding: 0;
	display: flex;
	flex-direction: column;
	align-items: center;
	justify-content: center;
	height: 100vh;
}

.container {
	text-align: center;
	padding: 20px;
	max-width: 600px;
	background: #ffffff;
	border-radius: 10px;
	box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}

.container h1 {
	font-size: 2.5rem;
	color: #333333;
	margin-bottom: 10px;
}

.container p {
	font-size: 1.2rem;
	color: #666666;
	margin-bottom: 20px;
}

.container a {
	display: inline-block;
	padding: 10px 20px;
	font-size: 1rem;
	text-decoration: none;
	color: #ffffff;
	background-color: #007bff;
	border-radius: 5px;
	transition: background-color 0.3s ease;
}

.container a:hover {
	background-color: #0056b3;
}
</style>
</head>
<body>
	<div class="container">
		<h1>페이지를 찾을 수 없습니다</h1>
		<p>요청하신 페이지가 존재하지 않습니다.</p>
		<p>URL을 확인하거나 아래 버튼을 클릭하여 홈으로 돌아가세요.</p>
		<a href="${pageContext.request.contextPath}/views/">홈으로 돌아가기</a>
	</div>
</body>
</html>
