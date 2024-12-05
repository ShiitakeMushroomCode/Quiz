<%@ page import="java.util.Map" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<html>
<head>
    <title>퀴즈 결과</title>
    <link rel="icon" href="<%= request.getContextPath() %>/static/icons/favicon.ico">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/static/css/styles.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/static/css/QuizResult.css">
</head>
<body>
<%@ include file="/WEB-INF/components/header.jsp" %>
<div class="result-container">
    <!-- 왼쪽 결과 섹션 -->
    <div class="result-left">
        <div class="result-image">
            <img src="${pageContext.request.contextPath}/images/${quizResult.quizId}.T" alt="썸네일"
                 onerror="this.onerror=null; this.src='<%= request.getContextPath() %>/static/images/etc/empty.WebP';">
        </div>
        <h2 class="correct-count">
            ${quizResult.correctAnswers}개 맞히셨습니다
        </h2>
        <div class="result-graph">
            <div class="bar-graph"></div>
            <p>당신은 상위 ${quizResult.percentile}%입니다</p>
        </div>
        <div class="result-buttons">
            <button class="btn-share" onclick="shareLink()">공유 링크</button>
            <button class="btn-retry" onclick="retryQuiz()">다시하기</button>
            <button class="btn-home" onclick="goHome()">홈으로</button>
        </div>
    </div>

    <!-- 오른쪽 댓글 섹션 -->
    <%
        Map<String, Object> quizResult = (Map<String, Object>) request.getAttribute("quizResult");
        Integer quizId = quizResult != null ? (Integer) quizResult.get("quizId") : null;
        request.setAttribute("quizId", quizId);
        request.setAttribute("redirectUrl",  request.getContextPath() + "/views/quizResult");
        request.setAttribute("quizResult", quizResult);
    %>
    <div class="result-right">
        <%@ include file="/WEB-INF/components/commentBox/commentBox.jsp" %>
    </div>
</div>

<script>
    const quizResult = {
        quizId: "${quizResult['quizId']}",
        correctAnswers: "${quizResult['correctAnswers']}",
        percentile: "${quizResult['percentile']}"
    };

    // 문자열로 전달된 값을 숫자로 변환
    quizResult.quizId = parseInt(quizResult.quizId);
    quizResult.correctAnswers = parseInt(quizResult.correctAnswers);
    quizResult.percentile = parseFloat(quizResult.percentile);

    // 공유 링크 함수
    function shareLink() {
        const baseUrl = window.location.origin;
        const contextPath = '<%= request.getContextPath() %>';
        const fullUrl =  baseUrl+contextPath+`/views/detail?id=${quizResult.quizId}`;
        navigator.clipboard.writeText(fullUrl).then(() => {
            alert("공유 링크가 복사되었습니다!\n" + fullUrl);
        }).catch(err => {
            console.error("링크 복사 중 오류 발생:", err);
            alert("링크 복사에 실패했습니다.");
        });
    }

    // 다시하기 함수
    function retryQuiz() {
        const contextPath = '<%= request.getContextPath() %>';
        window.location.href =  contextPath+`/views/detail?id=${quizResult.quizId}`;
    }

    // 홈으로 함수
    function goHome() {
        const contextPath = '<%= request.getContextPath() %>';
        window.location.href = contextPath+`/views/index`;
    }

    // 댓글 삭제
    function deleteComment(commentId) {
        const password = prompt("비밀번호를 입력하세요:");
        if (!password) return;

        const contextPath = '<%= request.getContextPath() %>';
        fetch(contextPath +`/views/deleteComment`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: `commentId=`+encodeURIComponent(commentId)+`&password=`+encodeURIComponent(password)
        })
            .then(response => {
                if (response.ok) {
                    alert('댓글이 삭제되었습니다.');
                    location.reload();
                } else {
                    alert('비밀번호가 일치하지 않습니다.');
                }
            })
            .catch(error => console.error('Error:', error));
    }

    // 댓글 무한 스크롤
    let offset = 0;
    const limit = 6; // 한 번에 가져올 댓글 수
    let isLoading = false;

    function loadComments() {
        if (isLoading) return;
        isLoading = true;

        const contextPath = '<%= request.getContextPath() %>';
        fetch(contextPath+`/views/moreComments?quizId=${quizResult.quizId}&offset=`+offset+`&limit=`+limit)
            .then(response => {
                if (response.ok) {
                    return response.text();
                } else if (response.status === 204) {
                    console.log("더 이상 댓글이 없습니다.");
                    return null;
                } else {
                    throw new Error('댓글을 가져오는 도중 오류가 발생했습니다.');
                }
            })
            .then(data => {
                if (data) {
                    const commentList = document.getElementById('comment-list');
                    const tempDiv = document.createElement('div');
                    tempDiv.innerHTML = data;

                    while (tempDiv.firstChild) {
                        commentList.appendChild(tempDiv.firstChild);
                    }

                    offset += limit;
                }
            })
            .catch(error => console.error('Error:', error))
            .finally(() => {
                isLoading = false;
            });
    }

    // 초기 댓글 로드
    document.addEventListener('DOMContentLoaded', () => {
        loadComments();

        const commentList = document.getElementById('comment-list');
        commentList.addEventListener('scroll', () => {
            if (commentList.scrollTop + commentList.clientHeight >= commentList.scrollHeight - 100) {
                loadComments();
            }
        });
    });

    document.addEventListener('DOMContentLoaded', () => {
        // 퍼센트 값 가져오기
        const percentile = quizResult.percentile;

        const rP = 101 - percentile;

        // bar-graph 요소 선택
        const barGraph = document.querySelector('.bar-graph');
        if (barGraph) {
            barGraph.style.setProperty('--bar-width', '0%');
            // 사용자 지정 프로퍼티 설정
            setTimeout(() => {
                barGraph.style.setProperty('--bar-width', rP+`%`);
            }, 100);
        }
    });


    // 새로고침 상태 관리
    window.addEventListener("load", () => {
        const contextPath = '<%= request.getContextPath() %>';

        // 새로고침 상태 확인
        if (performance.navigation.type === performance.navigation.TYPE_RELOAD) {
            // 새로고침일 경우 리다이렉트
            if (quizResult.quizId) {
                window.location.href = contextPath + '/views/detail?id=' + quizResult.quizId;
            }
        }
    });

</script>
</body>
</html>

