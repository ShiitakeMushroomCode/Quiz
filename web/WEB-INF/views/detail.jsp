<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>상세 페이지</title>
    <style>

    </style>
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/static/css/detail.css">
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/static/css/styles.css">
</head>
<body>
<%@ include file="/WEB-INF/components/header.jsp" %>
<table class="layout-table">
    <tr>
        <td class="image-section">그림</td>
        <%@ include file="/WEB-INF/components/commentBox/commentBox.jsp" %>
    </tr>
    <tr>
        <td class="description-section">설명</td>
    </tr>
    <tr>
        <td class="buttons-section">
            <div class="footer-buttons">
                <button>N개 풀기</button>
                <button>N개 풀기</button>
                <button>N개 풀기</button>
                <button>N개 풀기</button>
            </div>
        </td>
    </tr>
</table>
</body>
</html>
