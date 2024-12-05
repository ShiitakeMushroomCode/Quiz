<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Quiz" %>
<%@ page import="util.FileSystem" %>

<%
    List<Quiz> quizzes = (List<Quiz>) request.getAttribute("quizzes");

    if (quizzes == null || quizzes.isEmpty()) {
        // 더 이상 로드할 퀴즈가 없음
        response.setStatus(204); // HTTP 204 No Content
        return;
    }

    // Referer 헤더를 통해 요청한 페이지 확인
    String referer = request.getHeader("Referer");
    String onclickUrlPrefix = "detail?id="; // 기본값

    if (referer != null && referer.contains("myquiz")) {
        onclickUrlPrefix = "quizEdit?id=";
    }

    for (Quiz quiz : quizzes) {
        String onclickUrl = onclickUrlPrefix + quiz.getQuizId();
        String imageSrc = request.getContextPath() + "/images/" + quiz.getQuizId() + ".T";
%>
<div class="quiz-item" onclick="location.href='<%= onclickUrl %>'">
    <img src="<%= imageSrc %>" alt="Quiz Image"
         onerror="this.onerror=null; this.src='<%= request.getContextPath() %>/static/images/etc/empty.WebP';">
    <h3><%= quiz.getQuizName() %></h3>
    <p><%= quiz.getExp() %></p>
</div>
<%
    }
%>
