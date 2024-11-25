<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Quiz" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>퀴즈 목록</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/static/css/styles.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/static/css/index.css">
</head>
<body>
<%@ include file="/WEB-INF/components/header.jsp" %>
<%@ include file="/WEB-INF/components/search.jsp" %>

<div class="container">
    <!-- 퀴즈 목록 -->
    <div class="quizzes">
        <%
            int offset = 0;
            int size = 12;

            // QuizDAO를 통해 데이터 가져오기
            dao.QuizDAO quizDAO = new dao.QuizDAO();
            List<model.Quiz> quizzes = quizDAO.getQuizzesByOffset(offset, size);

            // 데이터를 출력
            for (Quiz quiz : quizzes) {
                String imageSrc = request.getContextPath() + "/static/images/" + quiz.getQuizId() + "/Thumbnail.WebP";
        %>
        <div class="quiz-item" onclick="location.href='detail?id=<%=quiz.getQuizId()%>'">
            <img src="<%= imageSrc %>" alt="Quiz Image" onerror="this.onerror=null; this.src='https://via.placeholder.com/300x200';">
            <h3><%= quiz.getQuizName() %></h3>
            <p><%= quiz.getExp() %></p>
        </div>
        <%
            }
        %>
    </div>

    <!-- 더 보기 버튼 -->
    <div class="load-more">
        <button id="loadMoreBtn" style="width: 100%; padding: 15px; background-color: #5cb1ff; color: white; border: none; cursor: pointer; font-size: 16px;">
            <span>더 보기 ↓</span>
        </button>
    </div>
</div>
<script>
    let totalLoaded = 12; // 처음 로드된 항목 수
    let itemsToLoadNext = 24; // 다음에 로드할 항목 수

    const loadMoreBtn = document.getElementById("loadMoreBtn");

    loadMoreBtn.addEventListener("click", function () {
        loadMoreQuizzes();
    });

    function loadMoreQuizzes() {
        const currentOffset = totalLoaded;
        const url = '<%= request.getContextPath() %>/views/loadMoreQuizzes?offset=' + currentOffset + '&size=' + itemsToLoadNext;

        fetch(url, {
            method: 'GET',
            headers: {
                'X-Requested-With': 'XMLHttpRequest' // AJAX 요청임을 명시
            }
        })
            .then(response => {
                if (!response.ok) {
                    throw new Error('네트워크 응답이 올바르지 않습니다.');
                }
                return response.text();
            })
            .then(html => {
                if (html.trim() === '') {
                    // 더 이상 로드할 퀴즈가 없음
                    alert('더 이상 항목이 없습니다!');
                    loadMoreBtn.disabled = true;
                    loadMoreBtn.innerText = "더 이상 항목이 없습니다.";
                    return;
                }
                const quizzesContainer = document.querySelector('.quizzes');
                quizzesContainer.insertAdjacentHTML('beforeend', html);
                totalLoaded += itemsToLoadNext;
            })
            .catch(error => {
                console.error('데이터 로드 중 오류 발생:', error);
                alert('데이터를 로드하는 중 오류가 발생했습니다.');
            });
    }
</script>

</body>
</html>
