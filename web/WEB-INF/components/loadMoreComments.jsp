<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<c:choose>
    <c:when test="${empty comments}">
        <c:set var="status" value="${pageContext.response}" />
        <c:set target="${status}" property="status" value="204" />
    </c:when>
    <c:otherwise>
        <c:forEach var="comment" items="${comments}">
            <div class="comment-item">
                <p>
                    <strong>${comment.writer}</strong> (${comment.createdAt})<br>
                        ${comment.comment}
                </p>
                <button class="delete-btn" onclick="deleteComment('${comment.commentId}')">❌</button>
            </div>
        </c:forEach>
    </c:otherwise>
</c:choose>
