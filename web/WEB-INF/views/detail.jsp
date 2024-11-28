<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<jsp:useBean id="detailData" class="bean.DetailData" scope="request"/>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>상세 페이지</title>
    <link rel="icon" href="<%= request.getContextPath() %>/static/icons/favicon.ico">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/detail.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/styles.css">
</head>
<body>
<%@ include file="/WEB-INF/components/header.jsp" %>
<table class="layout-table">
    <tr>
        <td class="title-section" colspan="2">
            <h1>${detailData.title}</h1>
        </td>
    </tr>
    <tr>
        <td>
            <%@ include file="/WEB-INF/components/commentBox/commentBox.jsp" %>
        </td>
    </tr>
    <tr>
        <td class="image-section">
            <img src="${pageContext.request.contextPath}/static/images/${detailData.id}/Thumbnail.WebP" alt="썸네일">
        </td>
    </tr>
    <tr>
        <td class="description-section">
            ${detailData.exp}
        </td>
    </tr>
    <tr>
        <td class="buttons-section">
            <div class="footer-buttons">
                <button id="btn1">${detailData.n1}개 풀기</button>
                <button id="btn2">${detailData.n2}개 풀기</button>
                <button id="btn3">${detailData.n3}개 풀기</button>
                <button id="btn4">${detailData.n4}개 풀기</button>
            </div>
        </td>
    </tr>
</table>
<script>
    // n1, n2, n3, n4 데이터를 받아옵니다.
    const n1 = parseInt("${detailData.n1}");
    const n2 = parseInt("${detailData.n2}");
    const n3 = parseInt("${detailData.n3}");
    const n4 = parseInt("${detailData.n4}");

    const buttons = [
        {element: document.getElementById('btn1'), count: n1},
        {element: document.getElementById('btn2'), count: n2},
        {element: document.getElementById('btn3'), count: n3},
        {element: document.getElementById('btn4'), count: n4},
    ];

    // 첫 번째 버튼은 항상 표시
    buttons[0].element.style.display = "inline-block";

    // 나머지 버튼은 조건에 따라 표시
    let visibleButtonCount = 0;
    buttons.forEach((btn, index) => {
        if (index > 0) {
            if (btn.count > 0) {
                btn.element.style.display = "inline-block";
                visibleButtonCount++;
            } else {
                btn.element.style.display = "none";
            }
        }
    });

    // 버튼이 하나만 표시될 경우 텍스트 변경
    if (visibleButtonCount <= 1) {
        buttons.forEach(btn => {
            if (btn.element.style.display === "inline-block") {
                btn.element.textContent = "문제 풀기";
            }
        });
    }
    // 댓글 무한 스크롤 구현
    let offset = 0;
    const limit = 6; // 한 번에 가져올 댓글 수
    const quizId = parseInt("${detailData.id}");
    let isLoading = false; // 로딩 상태 플래그

    function loadComments() {
        if (isLoading) return; // 이미 로딩 중이면 실행하지 않음
        isLoading = true; // 로딩 중 상태 설정

        const xhr = new XMLHttpRequest();
        xhr.open('GET', '${pageContext.request.contextPath}/views/moreComments?quizId=' + quizId + '&offset=' + offset + '&limit=' + limit, true);

        xhr.onreadystatechange = function () {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                if (xhr.status === 200) {
                    const commentList = document.getElementById('comment-list');
                    const tempDiv = document.createElement('div');
                    tempDiv.innerHTML = xhr.responseText;

                    // 모든 자식 요소를 commentList에 추가
                    while (tempDiv.firstChild) {
                        commentList.appendChild(tempDiv.firstChild);
                    }

                    // 오프셋 증가
                    offset += limit;
                    isLoading = false; // 로딩 완료
                } else if (xhr.status === 204) {
                    console.log("No more comments.");
                    isLoading = false; // 로딩 상태 해제
                } else {
                    console.error("Error loading comments.");
                    isLoading = false; // 로딩 상태 해제
                }
            }
        };
        xhr.send();
    }

    // 댓글 리스트의 스크롤 이벤트 감지
    const commentList = document.getElementById('comment-list');
    commentList.addEventListener('scroll', function () {
        // 트리거 지점을 스크롤 끝에서 100px 근처로 설정
        if (commentList.scrollTop + commentList.clientHeight >= commentList.scrollHeight - 100) {
            loadComments();
        }
    });

    // 페이지 로드 시 초기 댓글 로드
    window.onload = function () {
        loadComments();
    };

    // 댓글 삭제 함수
    function deleteComment(commentId) {
        const password = prompt("비밀번호를 입력하세요:");
        if (password) {
            const xhr = new XMLHttpRequest();
            xhr.open('POST', '${pageContext.request.contextPath}/views/deleteComment', true);
            xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
            xhr.onreadystatechange = function () {
                if (xhr.readyState === XMLHttpRequest.DONE) {
                    if (xhr.status === 200) {
                        if (xhr.responseText === 'success') {
                            // 댓글 리스트 초기화하고 다시 로드
                            offset = 0;
                            commentList.innerHTML = '';
                            loadComments();
                        } else {
                            alert('비밀번호가 일치하지 않습니다.');
                        }
                    } else {
                        console.error('Error deleting comment.');
                    }
                }
            };
            xhr.send('commentId=' + encodeURIComponent(commentId) + '&password=' + encodeURIComponent(password));
        }
    }
</script>
</body>
</html>
