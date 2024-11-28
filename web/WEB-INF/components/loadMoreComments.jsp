<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Comment" %>

<%
    List<Comment> comments = (List<Comment>) request.getAttribute("comments");

    if (comments == null || comments.isEmpty()) {
        response.setStatus(HttpServletResponse.SC_NO_CONTENT);
        return;
    }

    for (Comment comment : comments) {
%>
<div class="comment-item">
    <p>${comment.author}:</p>
    <p>${comment.text}</p>
    <button onclick="deleteComment(${comment.id})">삭제</button>
</div>
<%
    }
%>
