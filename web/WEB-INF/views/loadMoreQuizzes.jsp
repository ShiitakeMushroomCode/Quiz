<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Quiz" %>

<%
  List<Quiz> quizzes = (List<Quiz>) request.getAttribute("quizzes");

  if (quizzes == null || quizzes.isEmpty()) {
    // 더 이상 로드할 퀴즈가 없음
    out.print("");
    return;
  }

  for (Quiz quiz : quizzes) {
    String imageSrc = request.getContextPath() + "/static/images/" + quiz.getQuizId() + "/Thumbnail.WebP";
%>
<div class="quiz-item">
  <img src="<%= imageSrc %>" alt="Quiz Image" onerror="this.onerror=null; this.src='https://via.placeholder.com/300x200';">
  <h3><%= quiz.getQuizName() %></h3>
  <p><%= quiz.getExp() %></p>
</div>
<%
  }
%>
