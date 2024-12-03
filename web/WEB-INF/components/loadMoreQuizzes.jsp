<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Quiz" %>

<%
    List<Quiz> quizzes = (List<Quiz>) request.getAttribute("quizzes");

    if (quizzes == null || quizzes.isEmpty()) {
        // 더 이상 로드할 퀴즈가 없음
        response.setStatus(204); // HTTP 204 No Content
        return;
    }

    for (Quiz quiz : quizzes) {
        String imageSrc = request.getContextPath() + "/static/images/" + quiz.getQuizId() + "/Thumbnail.WebP";
%>
<div class="quiz-item" onclick="location.href='detail?id=<%=quiz.getQuizId()%>'">
    <img src="<%= imageSrc %>" alt="Quiz Image"
         onerror="this.onerror=null; this.src='<%= request.getContextPath() %>/static/images/etc/empty.WebP';">
    <h3><%= quiz.getQuizName() %>
    </h3>
    <p><%= quiz.getExp() %>
    </p>
</div>
<%
    }
%>
