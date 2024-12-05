<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Quiz" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>마이 퀴즈</title>
    <link rel="icon" href="<%= request.getContextPath() %>/static/icons/favicon.ico">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/static/css/styles.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/static/css/index.css">
    <!-- Bootstrap CSS -->
    <style>
        /* 기존 스타일 유지 */
        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
        }
        th, td {
            padding: 8px 12px;
            border: 1px solid #ddd;
            vertical-align: top;
        }
        th {
            background-color: #f2f2f2;
            text-align: center;
        }
        .correct-answers-list li {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 8px;
            margin-bottom: 5px;
            background-color: #f9f9f9;
            border: 1px solid #ccc;
            border-radius: 8px;
        }
        .correct-answers-list li button {
            margin-left: 10px;
        }
        /* 옵션 입력 필드 스타일 */
        .option-table th, .option-table td {
            text-align: center;
        }
        .option-input {
            width: 100%;
            padding: 6px 12px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }
        /* 모달 내 옵션 입력 필드 스타일 */
        #createQuizModal .option-input {
            width: 100%;
            padding: 6px 12px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }
    </style>
</head>
<body>
<%@ include file="/WEB-INF/components/header.jsp" %>
<%@ include file="/WEB-INF/components/search.jsp" %>

<div class="container">
    <!-- 퀴즈 목록 -->
    <div class="quizzes">
        <!-- 첫 번째 quiz-item 수정: 클릭 시 모달 열기 -->
        <div class="quiz-item" data-toggle="modal" data-target="#createQuizModal" style="cursor: pointer;">
            <img src="<%= request.getContextPath() %>/static/images/etc/add.WebP" alt="비어있는 이미지" style="width: 100px; height: 100px;">
            <h3>새로운 퀴즈를 만들어보세요!</h3>
            <p>나만의 문제를 만들어보세요.</p>
        </div>
        <%
            String searchValue = request.getParameter("searchInput");
            String filter = request.getParameter("filter");

            List<Quiz> quizzes = (List<Quiz>) request.getAttribute("quizzes");
            if (quizzes != null) {
                for (Quiz quiz : quizzes) {
                    String imageSrc = request.getContextPath() + "/images/" + quiz.getQuizId() + ".T";
        %>
        <div class="quiz-item" onclick="location.href='quizEdit?id=<%=quiz.getQuizId()%>'" style="cursor: pointer;">
            <img src="<%= imageSrc %>" alt="Quiz Image"
                 onerror="this.onerror=null; this.src='<%= request.getContextPath() %>/static/images/etc/empty.WebP';" style="width: 100px; height: 100px;">
            <h3><%= quiz.getQuizName() %></h3>
            <p><%= quiz.getExp() %></p>
        </div>
        <%
                }
            }
        %>
    </div>
</div>


<!-- 퀴즈 생성 모달 추가 -->
<div class="modal fade" id="createQuizModal" tabindex="-1" role="dialog" aria-labelledby="createQuizModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <form action="<%= request.getContextPath() %>/createQuiz" method="post" enctype="multipart/form-data" autocomplete="off">
                <div class="modal-header">
                    <h5 class="modal-title" id="createQuizModalLabel">새 퀴즈 생성</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="닫기">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <!-- 퀴즈 제목 -->
                    <div class="form-group">
                        <label for="quizTitle">퀴즈 제목</label>
                        <input type="text" class="form-control" id="quizTitle" name="quizName" required>
                    </div>
                    <!-- 썸네일 추가 -->
                    <div class="form-group">
                        <label for="quizThumbnail">썸네일 이미지</label>
                        <input type="file" class="form-control-file" id="quizThumbnail" name="thumbnail" accept=".jpg,.jpeg,.png,.webp" required onchange="validateImage(this)">
                        <small class="form-text text-muted">이미지 파일만 업로드 가능합니다 (.jpg, .jpeg, .png, .webp).</small>
                        <img id="thumbnailPreview" src="#" alt="썸네일 미리보기" style="display: none; width: 100px; height: 100px; object-fit: cover; margin-top: 10px; border-radius: 8px;">
                    </div>
                    <!-- 설명 -->
                    <div class="form-group">
                        <label for="quizDescription">설명</label>
                        <textarea class="form-control" id="quizDescription" name="exp" rows="4" required></textarea>
                    </div>
                    <!-- 공개여부 -->
                    <div class="form-group">
                        <label for="quizRelease">공개 여부</label>
                        <div class="custom-control custom-switch">
                            <input type="checkbox" class="custom-control-input" id="quizRelease" name="releaseSwitch" onclick="toggleRelease()" value="Y">
                            <label class="custom-control-label" for="quizRelease">공개</label>
                        </div>
                        <!-- 실제로 전송할 release 값을 위한 hidden input -->
                        <input type="hidden" id="release" name="release" value="N">
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
                    <button type="submit" class="btn btn-primary">생성</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Bootstrap JS 및 의존성 스크립트 추가 -->
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
<script>
    let totalLoaded = <%= quizzes != null ? quizzes.size() : 0 %>; // 처음 로드된 항목 수
    const itemsToLoadNext = 24; // 다음에 로드할 항목 수
    let isLoading = false; // 데이터 로드 중인지 여부
    const totalQuizzes = <%= request.getAttribute("totalQuizzes") != null ? request.getAttribute("totalQuizzes") : 0 %>; // 총 퀴즈 수

    // 검색 값과 필터 값을 JavaScript 변수로 저장
    let searchValue = '<%= searchValue != null ? searchValue : "" %>';
    let filter = '<%= filter != null ? filter : "" %>';

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

    function debounce(func, delay) {
        let timeoutId;
        return function (...args) {
            clearTimeout(timeoutId);
            timeoutId = setTimeout(() => {
                func.apply(this, args);
            }, delay);
        };
    }

    // 이미지 파일 유효성 검사 함수
    function validateImage(input) {
        const file = input.files[0];
        if (file) {
            const validImageExtensions = ['jpg', 'jpeg', 'png', 'webp'];
            const fileExtension = file.name.split('.').pop().toLowerCase();
            if (!validImageExtensions.includes(fileExtension)) {
                alert('이미지 파일만 업로드할 수 있습니다 (.jpg, .jpeg, .png, .webp).');
                input.value = ''; // 선택된 파일 초기화
            } else {
                // 이미지 미리보기 표시
                const reader = new FileReader();
                reader.onload = function(e) {
                    const preview = document.getElementById('thumbnailPreview');
                    preview.src = e.target.result;
                    preview.style.display = 'block';
                }
                reader.readAsDataURL(file);
            }
        }
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
        const url = '<%= request.getContextPath() %>/views/loadMoreQuizzes?offset=' + currentOffset + '&size=' + itemsToLoadNext + '&searchInput=' + encodeURIComponent(searchValue) + '&filter=' + encodeURIComponent(filter);

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

    // release 스위치의 상태에 따라 hidden input의 값을 설정하는 함수
    function toggleRelease() {
        const releaseCheckbox = document.getElementById('quizRelease');
        const releaseHidden = document.getElementById('release');
        if (releaseCheckbox.checked) {
            releaseHidden.value = 'Y';
        } else {
            releaseHidden.value = 'N';
        }
    }

    // 폼 제출 시 현재 체크 상태를 반영하도록 함
    document.querySelector('#createQuizModal form').addEventListener('submit', function() {
        toggleRelease();
    });
</script>

</body>
</html>
