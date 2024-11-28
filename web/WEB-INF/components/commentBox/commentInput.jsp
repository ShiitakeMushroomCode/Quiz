<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<form action="<%= request.getContextPath() %>/views/addComment" method="post" class="comment-input">
    <input type="hidden" name="quizId" value="${detailData.id}"/>
    <textarea name="comment" placeholder="댓글 내용" required></textarea>
    <div class="input-row">
        <input name="writer" type="text" placeholder="닉네임" required autocomplete="off">
        <input name="password" type="password" placeholder="비밀번호" required autocomplete="off">
        <button type="submit">작성</button>
    </div>
</form>
