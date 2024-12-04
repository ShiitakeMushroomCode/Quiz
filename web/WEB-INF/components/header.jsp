<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.User" %>
<%
    response.setHeader("Cache-Control", "no-store, no-cache, must-revalidate, max-age=0");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
%>
<header>
    <div class="container">
        <img src="${pageContext.request.contextPath}/static/icons/favicon.ico"
             alt="로고"
             onclick="location.href='${pageContext.request.contextPath}/views/index'"/>

        <div class="button-group">
            <%
                // 세션에서 사용자 정보 가져오기
                User user = (User) session.getAttribute("user");
                if (user != null) {
            %>
            <!-- 로그인 상태: 내 퀴즈 & 로그아웃 버튼 -->
            <button
                    onclick="location.href='<%=request.getContextPath()%>/views/myquiz'">내
                퀴즈
            </button>
            <button
                    onclick="location.href='<%=request.getContextPath()%>/views/logout'">로그아웃
            </button>
            <%
            } else {
            %>
            <!-- 비로그인 상태: 로그인 버튼 -->
            <button
                    onclick="location.href='<%=request.getContextPath()%>/views/login'">로그인
            </button>
            <%
                }
            %>
        </div>
    </div>
</header>
