<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<td rowspan="5">
    <!-- 댓글 섹션 -->
    <div class="comment-box">
        <h2>댓글</h2>
        <%@ include file="/WEB-INF/components/commentBox/commentInput.jsp" %>
        <div class="comment-list" id="comment-list">
            <!-- 댓글 아이템이 동적으로 추가됩니다 -->
        </div>
    </div>
</td>
