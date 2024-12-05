<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<jsp:useBean id="detailData" class="bean.DetailData" scope="request"/>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${detailData.title} - 퀴즈 페이지</title>
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
        <%
            request.setAttribute("quizId", detailData.getId());
            request.setAttribute("redirectUrl",  request.getContextPath() + "/views/detail?id=" + detailData.getId());
        %>
        <td>
            <td rowspan="5">
                <%@ include file="/WEB-INF/components/commentBox/commentBox.jsp" %>
            </td>
        </td>
    </tr>
    <tr>
        <td class="image-section">
            <img src="${pageContext.request.contextPath}/images/${detailData.id}.T" alt="썸네일"
                 onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/static/images/etc/empty.WebP';" />
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
                <button id="btn1" class="hidden">${detailData.n1}개 풀기</button>
                <button id="btn2" class="hidden">${detailData.n2}개 풀기</button>
                <button id="btn3" class="hidden">${detailData.n3}개 풀기</button>
                <button id="btn4" class="hidden">${detailData.n4}개 풀기</button>
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
    const detailId = "${detailData.id}";

    const buttons = [
        {element: document.getElementById('btn1'), count: n1},
        {element: document.getElementById('btn2'), count: n2},
        {element: document.getElementById('btn3'), count: n3},
        {element: document.getElementById('btn4'), count: n4},
    ];

    // 버튼 표시/숨기기
    let visibleButtonCount = 0;
    buttons.forEach((btn) => {
        if (btn.count > 0) {
            btn.element.classList.remove('hidden');
            visibleButtonCount++;

            // 클릭 이벤트 설정
            btn.element.onclick = function () {
                submitForm(btn.count, detailId);
            };
        } else {
            btn.element.classList.add('hidden');
        }
    });

    // 버튼이 모두 숨겨진 경우 첫 번째 버튼 강제로 표시
    if (visibleButtonCount === 0) {
        const firstButton = buttons[0];
        firstButton.element.classList.remove('hidden');
        firstButton.element.textContent = "문제 풀기";
        firstButton.count = 0;
        firstButton.element.onclick = function () {
            submitForm(firstButton.count, detailId);
        };
    }

    // 동적 폼 생성 함수
    function submitForm(count, id) {
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = `${pageContext.request.contextPath}/views/PlayQuiz`;

        const inputCount = document.createElement('input');
        inputCount.type = 'hidden';
        inputCount.name = 'count';
        inputCount.value = count;

        const inputId = document.createElement('input');
        inputId.type = 'hidden';
        inputId.name = 'id';
        inputId.value = id;

        form.appendChild(inputCount);
        form.appendChild(inputId);

        document.body.appendChild(form);

        console.log("Form submitted with count:", count, "and id:", id);
        form.submit(); // 폼 제출
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
    window.addEventListener('load', () => {
        const currentUrl = location.href; // 현재 URL 가져오기

        // 현재 URL로 히스토리 덮어쓰기
        history.replaceState(null, null, currentUrl);
    });

</script>
</body>
</html>
