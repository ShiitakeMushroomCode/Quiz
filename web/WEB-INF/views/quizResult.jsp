<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<html>
<head>
    <title>결과</title>
</head>
<body>
<h1>퀴즈 완료</h1>
<p>최종 점수: ${score} / ${total}</p>
<a href="${pageContext.request.contextPath}/views/detail?id=1">다시 시작하기</a>
</body>
</html>
