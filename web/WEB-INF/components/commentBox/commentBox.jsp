<%@ page contentType="text/html; charset=UTF-8"
		 pageEncoding="UTF-8"%>
<td rowspan="3">
	<!-- 댓글 섹션 -->
	<div class="comment-box">
		<h2>댓글 (n)</h2>
		<%@ include file="/WEB-INF/components/commentBox/commentInput.jsp" %>
		<div class="comment-list">
			<%@ include file="/WEB-INF/components/commentBox/commentItem.jsp" %>
			<%@ include file="/WEB-INF/components/commentBox/commentItem.jsp" %>
		</div>
	</div>
</td>