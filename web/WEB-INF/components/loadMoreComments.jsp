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
    <p><strong><%= comment.getWriter() %></strong> (<%= comment.getCreatedAt() %>)<br>
        <%= comment.getComment() %>
    </p>
    <button class="delete-btn" onclick="deleteComment('<%= comment.getCommentId() %>')">❌</button>
</div>
<%
    }
%>
