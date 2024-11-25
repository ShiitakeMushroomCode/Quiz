<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<jsp:useBean id="detailData" class="bean.DetailData" scope="request" />
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>상세 페이지</title>
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/static/css/detail.css">
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/static/css/styles.css">
</head>
<body>
<%@ include file="/WEB-INF/components/header.jsp" %>
<table class="layout-table">
    <tr>
        <td class="image-section">
            <img src="${pageContext.request.contextPath}/static/images/${detailData.id}/Thumbnail.WebP" alt="썸네일">
        </td>
        <%@ include file="/WEB-INF/components/commentBox/commentBox.jsp" %>
    </tr>
    <tr>
        <td class="description-section">
            설명: ${detailData.exp}
        </td>
    </tr>
    <tr>
        <td class="buttons-section">
            <div class="footer-buttons">
                <button>${detailData.n1}개 풀기</button>
                <button>${detailData.n2}개 풀기</button>
                <button>${detailData.n3}개 풀기</button>
                <button>${detailData.n4}개 풀기</button>
            </div>
        </td>
    </tr>
</table>
</body>
</html>
