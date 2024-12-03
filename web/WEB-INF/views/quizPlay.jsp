<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    response.setHeader("Cache-Control", "no-store, no-cache, must-revalidate, max-age=0");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
%>
<html>
<head>
    <title>퀴즈</title>
    <link rel="icon" href="<%= request.getContextPath() %>/static/icons/favicon.ico">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/static/css/styles.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/static/css/PlayQuiz.css">
</head>
<body>
<%@ include file="/WEB-INF/components/header.jsp" %>
<div class="quiz-section">
    <img id="questionImage" src="" alt="문제 이미지">
    <p id="feedbackMessage"></p>
    <h2 id="correctAnswer"></h2>

    <form id="quizForm" onsubmit="event.preventDefault(); submitAnswer();">
        <label for="answer"></label>
        <input type="text" id="answer" name="answer" required autocomplete="off">
        <button type="submit">제출</button>
    </form>
    <button id="nextButton" style="display: none;" onclick="handleNext()">다음으로</button>
</div>

<script>
    async function fetchQuestion() {
        try {
            const contextPath = '<%= request.getContextPath() %>';
            const response = await fetch(contextPath + '/views/PlayQuiz?action=getQuestion', {
                credentials: 'same-origin'
            });
            if (!response.ok) throw new Error(`HTTP error! status: ${response.status}`);
            const data = await response.json();

            if (data.status === "end") {
                window.location.href = contextPath + '/views/quizResult';
            } else {
                const detailId = data.detailId;
                const imageId = data.imageId;
                const imageUrl = contextPath + '/static/images/' + detailId + '/' + imageId + '/Quiz.WebP';
                setImageWithFallback(imageUrl);
            }
        } catch (error) {
            alert('문제를 불러오는 도중 오류가 발생했습니다. 다시 시도해주세요.');
        }
    }

    function setImageWithFallback(imageUrl) {
        const questionImage = document.getElementById("questionImage");
        const contextPath = '<%= request.getContextPath() %>';
        questionImage.src = imageUrl;
        questionImage.onerror = () => {
            questionImage.onerror = null;
            questionImage.src = contextPath + '/static/images/etc/empty.WebP';
        };
    }
    async function submitAnswer() {
        try {
            const answer = document.getElementById("answer").value.trim(); // 입력값 공백 제거
            if (!answer) {
                alert("답을 입력하세요.");
                return;
            }

            const contextPath = '<%= request.getContextPath() %>';
            const response = await fetch(contextPath + '/views/PlayQuiz?action=submitAnswer', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8' },
                body: 'answer=' + encodeURIComponent(answer),
                credentials: 'same-origin'
            });

            if (!response.ok) throw new Error(`HTTP error! status: ${response.status}`);
            const data = await response.json();

            // DOM 요소 가져오기
            const feedbackMessage = document.getElementById("feedbackMessage");
            const correctAnswer = document.getElementById("correctAnswer");
            const quizForm = document.getElementById("quizForm");
            const nextButton = document.getElementById("nextButton");

            // 결과 업데이트
            feedbackMessage.textContent = data.isCorrect ? "정답!" : "오답!";
            correctAnswer.textContent = "정답: " + (data.correctAnswer || "알 수 없음");

            // 입력 폼 숨기기, '다음' 버튼 표시
            quizForm.style.display = "none";
            nextButton.style.display = "block";
        } catch (error) {
            alert('정답 제출 도중 오류가 발생했습니다. 다시 시도해주세요.');
            console.error("Error submitting answer:", error);
        }
    }

    function handleNext() {
        // DOM 요소 가져오기
        const feedbackMessage = document.getElementById("feedbackMessage");
        const correctAnswer = document.getElementById("correctAnswer");
        const quizForm = document.getElementById("quizForm");
        const nextButton = document.getElementById("nextButton");
        const answerInput = document.getElementById("answer");

        // 초기화 및 UI 업데이트
        feedbackMessage.textContent = "";
        correctAnswer.textContent = "";
        answerInput.value = ""; // 입력 필드 초기화
        quizForm.style.display = "flex"; // 입력 폼 다시 표시
        nextButton.style.display = "none"; // '다음으로' 버튼 숨기기

        // 입력 필드에 포커스 설정
        answerInput.focus();

        // 다음 문제 가져오기
        fetchQuestion();
    }


    document.addEventListener("keydown", (event) => {
        const nextButton = document.getElementById("nextButton");
        if (event.key === "Enter" && nextButton.style.display === "block") {
            event.preventDefault();
            nextButton.click();
        }
    });

    // 새로고침 상태 관리
    window.addEventListener("load", () => {
        const contextPath = '<%= request.getContextPath() %>';
        const detailId = '<%= session.getAttribute("quizId") %>'; // 세션에서 quizId 가져오기

        // 새로고침 상태 확인
        if (performance.navigation.type === performance.navigation.TYPE_RELOAD) {
            // 새로고침일 경우 리다이렉트
            if (detailId) {
                window.location.href = contextPath + '/views/detail?id=' + detailId;
            }
        }
    });


    window.onload = () => {
        fetchQuestion();

        // 입력 필드 자동 포커스
        const answerInput = document.getElementById("answer");
        answerInput.focus();
    };

</script>
</body>
</html>
