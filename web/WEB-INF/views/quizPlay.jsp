<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="bean.PlayData, type.PlayDataObj" %>
<html>
<head>
    <title>Quiz Play</title>
    <link rel="icon" href="<%= request.getContextPath() %>/static/icons/favicon.ico">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/static/css/styles.css">
</head>
<body>
<h1>퀴즈 데이터 확인</h1>

<%
    // PlayData 객체 가져오기
    PlayData playData = (PlayData) request.getAttribute("playData");

    if (playData == null) {
%>
<p>데이터를 불러오지 못했습니다.</p>
<%
} else {
%>
<h2>퀴즈 ID: <%= playData.getQuizId() %></h2>
<p>요청된 문제 개수: <%= playData.getCount() %></p>
<h3>문제 리스트:</h3>
<ul>
    <%
        PlayDataObj[] items = playData.getItems();
        if (items != null && items.length > 0) {
            for (PlayDataObj item : items) {
    %>
    <li>
        <strong>문제 ID:</strong> <%= item.getDetailId() %> <br>
        <strong>이미지 ID:</strong> <%= item.getImageId() %> <br>
        <strong>정답 목록:</strong>
        <%
            for (String answer : item.getCorrectAnswerSet()) {
                out.print(answer + " ");
            }
        %>
    </li>
    <%
        }
    } else {
    %>
    <li>문제가 없습니다.</li>
    <%
        }
    %>
</ul>
<%
    }
%>
</body>
</html>
