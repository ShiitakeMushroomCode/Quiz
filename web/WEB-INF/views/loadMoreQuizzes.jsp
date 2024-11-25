<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Quiz" %>

<%
  int offset = request.getParameter("offset") != null ? Integer.parseInt(request.getParameter("offset")) : 0;
  int size = request.getParameter("size") != null ? Integer.parseInt(request.getParameter("size")) : 24;

  // QuizDAO를 통해 데이터 가져오기
  dao.QuizDAO quizDAO = new dao.QuizDAO();
  List<model.Quiz> quizzes = quizDAO.getQuizzesByOffset(offset, size);

  // 데이터를 출력
  for (Quiz quiz : quizzes) {
    String imageSrc = request.getContextPath() + "/static/images/" + quiz.getQuizId() + "/Thumbnail.WebP";
%>
<div class="quiz-item">
  <img src="<%= imageSrc %>" alt="Quiz Image">
  <h3><%= quiz.getQuizName() %></h3>
  <p><%= quiz.getExp() %></p>
</div>
<%
  }
%>
