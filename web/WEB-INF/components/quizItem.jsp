<%@ page contentType="text/html; charset=UTF-8"
		 pageEncoding="UTF-8"%>
<div class="quiz-item" onclick="location.href='detail/${id}'">
	<img src="<%=request.getAttribute("imageSrc")%>" alt="퀴즈 썸네일">
	<h3><%=request.getAttribute("title")%></h3>
	<p><%=request.getAttribute("description")%></p>
</div>
