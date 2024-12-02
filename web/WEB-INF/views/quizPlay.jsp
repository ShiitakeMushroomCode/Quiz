<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<html>
<head>
    <title>퀴즈</title>
    <link rel="icon" href="${pageContext.request.contextPath}/static/icons/favicon.ico">
</head>
<body>
<h1>퀴즈</h1>
<img id="questionImage" src="" alt="문제 이미지">

<p id="feedbackMessage"></p>
<h2 id="correctAnswer"></h2>
<form id="quizForm" onsubmit="event.preventDefault(); submitAnswer();">
    <label for="answer">정답 입력:</label>
    <input type="text" id="answer" name="answer" required autocomplete="off">
    <button type="submit">제출</button>
</form>
<button id="nextButton" style="display: none;" onclick="handleNext()">다음으로</button>

<script>
    async function fetchQuestion() {
        try {
            const response = await fetch('${pageContext.request.contextPath}/views/PlayQuiz?action=getQuestion', {
                credentials: 'same-origin'
            });
            if (!response.ok) throw new Error(`HTTP error! status: ${response.status}`);
            const data = await response.json();

            if (data.status === "end") {
                window.location.href = '${pageContext.request.contextPath}/views/detail?id=${quizId}';
            } else {
                const detailId = data.detailId;
                const imageId = data.imageId;
                const imageUrl = `${pageContext.request.contextPath}/static/images/` + detailId + `/` + imageId + `/Quiz.WebP`;
                setImageWithFallback(imageUrl);
            }
        } catch (error) {
            alert('문제를 불러오는 도중 오류가 발생했습니다. 다시 시도해주세요.');
        }
    }

    function setImageWithFallback(imageUrl) {
        const questionImage = document.getElementById("questionImage");
        questionImage.src = imageUrl;
        questionImage.onerror = () => {
            questionImage.onerror = null;
            questionImage.src = "https://via.placeholder.com/300x200";
        };
    }

    async function submitAnswer() {
        try {
            const answer = document.getElementById("answer").value;
            const response = await fetch('${pageContext.request.contextPath}/views/PlayQuiz?action=submitAnswer', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8' },
                body: 'answer=' + encodeURIComponent(answer),
                credentials: 'same-origin'
            });
            if (!response.ok) throw new Error(`HTTP error! status: ${response.status}`);
            const data = await response.json();

            const feedbackMessage = document.getElementById("feedbackMessage");
            const correctAnswer = document.getElementById("correctAnswer");
            const quizForm = document.getElementById("quizForm");
            const nextButton = document.getElementById("nextButton");
            const questionImage = document.getElementById("questionImage");

            const isCorrect = data.isCorrect;
            const correctAnswerData = data.correctAnswer

            feedbackMessage.textContent = isCorrect ? "정답!" : "오답!";
            correctAnswer.textContent = "정답: " + (correctAnswerData || "알 수 없음");
            quizForm.style.display = "none";
            nextButton.style.display = "block";

            // 이미지 변경
            const detailId = data.detailId;
            const imageId = data.imageId;
            const correctImageUrl = `${pageContext.request.contextPath}/static/images/` + detailId + `/` + imageId + `/Correct.WebP`;
            setImageWithFallback(correctImageUrl);
        } catch (error) {
            alert('정답을 제출하는 도중 오류가 발생했습니다. 다시 시도해주세요.');
        }
    }

    function handleNext() {
        const feedbackMessage = document.getElementById("feedbackMessage");
        const correctAnswer = document.getElementById("correctAnswer");
        const quizForm = document.getElementById("quizForm");
        const nextButton = document.getElementById("nextButton");

        feedbackMessage.textContent = "";
        correctAnswer.textContent = "";
        quizForm.textContent = "";
        quizForm.style.display = "block";
        nextButton.style.display = "none";

        fetchQuestion();
    }

    window.onload = fetchQuestion;
</script>
</body>
</html>
