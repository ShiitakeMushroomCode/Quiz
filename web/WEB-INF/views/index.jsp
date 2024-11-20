<%@ page import="model.Quiz" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>퀴즈 목록</title>
    <link rel="icon"
          href="${pageContext.request.contextPath}/static/icons/favicon.ico"
          type="image/x-icon">
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/static/css/styles.css">
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/static/css/index.css">
</head>
<body>
<%@ include file="/WEB-INF/components/header.jsp" %>
<%@ include file="/WEB-INF/components/search.jsp" %>

<div class="container">
    <!-- 퀴즈 목록 -->
    <div class="quizzes">
        <%
            List<Quiz> quizzes = (List<Quiz>) request.getAttribute("quizzes");
            for (Quiz quiz : quizzes) {
                request.setAttribute("imageSrc", "https://via.placeholder.com/300x200");
                request.setAttribute("title", quiz.getQuizName());
                request.setAttribute("description", quiz.getExp());
                request.setAttribute("id", quiz.getQuizId());
        %>
        <%@ include file="/WEB-INF/components/quizItem.jsp" %>
        <%
            }
        %>
    </div>
</div>

</body>
</html>

