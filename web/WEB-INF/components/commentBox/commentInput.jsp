<%@ page import="java.util.Map" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    // quizResult가 request에 존재할 경우 세션에 저장할 준비
    Map<String, Object> quizResultData = (Map<String, Object>) request.getAttribute("quizResult");
%>

<script>
    function saveToSession() {
        <%
            if (quizResultData != null) {
                // 세션에 quizResult를 저장
                session.setAttribute("quizResult", quizResultData);
            }
        %>
        return true; // 폼 제출 진행
    }
</script>

<form id="commentForm" action="<%= request.getContextPath() %>/views/addComment" method="post" class="comment-input" onsubmit="return saveToSession()">
    <input type="hidden" name="quizId" value="${quizId}"/>
    <input type="hidden" name="redirectUrl" value="${redirectUrl}"/>
    <textarea name="comment" placeholder="댓글 내용" required></textarea>
    <div class="input-row">
        <input name="writer" type="text" placeholder="닉네임" required autocomplete="off">
        <input name="password" type="password" placeholder="비밀번호" required autocomplete="off">
        <button type="submit">작성</button>
    </div>
</form>
