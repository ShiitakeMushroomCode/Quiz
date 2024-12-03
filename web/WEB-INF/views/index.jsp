<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Quiz" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>퀴즈 목록</title>
    <link rel="icon" href="<%= request.getContextPath() %>/static/icons/favicon.ico">
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

            // 총 퀴즈 수 가져오기
            int totalQuizzes = quizDAO.getTotalQuizCount();

            // 데이터를 출력
            for (Quiz quiz : quizzes) {
                String imageSrc = request.getContextPath() + "/static/images/" + quiz.getQuizId() + "/Thumbnail.WebP";
        %>
        <div class="quiz-item" onclick="location.href='detail?id=<%=quiz.getQuizId()%>'">
            <img src="<%= imageSrc %>" alt="Quiz Image"
                 onerror="this.onerror=null; this.src='<%= request.getContextPath() %>/static/images/etc/empty.WebP';">
            <h3><%= quiz.getQuizName() %>
            </h3>
            <p><%= quiz.getExp() %>
            </p>
        </div>
        <%
            }
        %>
    </div>
</div>

<script>
    let totalLoaded = <%= size %>; // 처음 로드된 항목 수
    const itemsToLoadNext = 24; // 다음에 로드할 항목 수
    let isLoading = false; // 데이터 로드 중인지 여부
    const totalQuizzes = <%= totalQuizzes %>; // 총 퀴즈 수

    // 스크롤 이벤트 핸들러
    function onScrollLoad() {
        if (isLoading) return;

        const scrollTop = window.pageYOffset || document.documentElement.scrollTop;
        const windowHeight = window.innerHeight;
        const documentHeight = document.documentElement.scrollHeight;

        // 페이지 하단 100px 근처에 도달하면 데이터 로드
        if (scrollTop + windowHeight >= documentHeight - 100) {
            loadMoreQuizzes();
        }
    }

    // 스크롤 이벤트에 디바운스 적용 (선택 사항)
    function debounce(func, delay) {
        let debounceTimer;
        return function () {
            const context = this;
            const args = arguments;
            clearTimeout(debounceTimer);
            debounceTimer = setTimeout(() => func.apply(context, args), delay);
        };
    }

    // 디바운스된 스크롤 이벤트 핸들러 등록
    window.addEventListener('scroll', debounce(onScrollLoad, 200));

    function loadMoreQuizzes() {
        // 더 이상 로드할 퀴즈가 없으면 함수 종료
        if (totalLoaded >= totalQuizzes) {
            window.removeEventListener('scroll', onScrollLoad);
            return;
        }

        isLoading = true; // 로딩 시작
        const currentOffset = totalLoaded;
        const url = '<%= request.getContextPath() %>/views/loadMoreQuizzes?offset=' + currentOffset + '&size=' + itemsToLoadNext;

        fetch(url, {
            method: 'GET',
            headers: {
                'X-Requested-With': 'XMLHttpRequest'
            }
        })
            .then(response => {
                isLoading = false; // 로딩 종료

                if (!response.ok) {
                    if (response.status === 204) {
                        // 더 이상 로드할 퀴즈가 없음
                        window.removeEventListener('scroll', onScrollLoad);
                        return '';
                    } else {
                        throw new Error('네트워크 응답이 올바르지 않습니다.');
                    }
                }
                return response.text();
            })
            .then(html => {
                if (!html) return; // 빈 응답이면 처리 종료

                const quizzesContainer = document.querySelector('.quizzes');
                quizzesContainer.insertAdjacentHTML('beforeend', html);

                // 로드된 항목 수 업데이트
                const parser = new DOMParser();
                const doc = parser.parseFromString(html, 'text/html');
                const newItemsCount = doc.querySelectorAll('.quiz-item').length;
                totalLoaded += newItemsCount;

                // 만약 로드된 항목이 적으면 더 이상 로드할 퀴즈가 없을 수 있음
                if (newItemsCount < itemsToLoadNext) {
                    window.removeEventListener('scroll', onScrollLoad);
                }
            })
            .catch(error => {
                isLoading = false; // 로딩 종료
                console.error('데이터 로드 중 오류 발생:', error);
                alert('데이터를 로드하는 중 오류가 발생했습니다.');
            });
    }
</script>

</body>
</html>
