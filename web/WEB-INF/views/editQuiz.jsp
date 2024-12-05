<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<jsp:useBean id="detailData" class="bean.DetailData" scope="request"/>
<jsp:useBean id="playData" class="bean.PlayData" scope="request"/>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>퀴즈 편집</title>
  <link rel="icon" href="<%= request.getContextPath() %>/static/icons/favicon.ico">
  <link rel="stylesheet" href="<%= request.getContextPath() %>/static/css/styles.css">

  <!-- Bootstrap CSS -->
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">

  <!-- FontAwesome CSS 추가 -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

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
    .add-button {
      margin-bottom: 10px;
    }
    .correct-answers-list {
      list-style-type: none;
      padding-left: 0;
      max-height: 125px;
      overflow-y: scroll;
      scrollbar-width: none; /* Firefox */
      -ms-overflow-style: none; /* IE and Edge */
    }
    .correct-answers-list::-webkit-scrollbar {
      display: none; /* Chrome, Safari, Opera */
    }
    .correct-answers-list li {
      display: flex;
      align-items: center;
      padding: 8px;
      margin-bottom: 5px;
      background-color: #f9f9f9;
      border: 1px solid #ccc;
      border-radius: 8px;
    }
    .form-control-file {
      width: 100%;
    }
    /* 정답 추가 버튼 가운데 정렬 */
    .add-answer-button-container {
      text-align: center;
      margin-top: 10px;
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
    #addItemModal .option-input,
    #editItemModal .option-input {
      width: 100%;
      padding: 6px 12px;
      border: 1px solid #ccc;
      border-radius: 4px;
    }

    #thumbnailPreviewEdit{
      height: 200px;
      width: 300px;
      object-fit: cover;
      border: 1px solid darkgray;
    }

    .quizPreview, .correctPreview{
      height: 100px;
      width: 150px;
      object-fit: cover;
      border: 1px solid darkgray;
    }

    /* 헤더의 h1과 삭제 버튼을 수평 정렬 */
    .header-title {
      display: flex;
      justify-content: space-between;
      align-items: center;
    }
  </style>
</head>
<body>
<%@ include file="/WEB-INF/components/header.jsp" %>

<div class="container">
  <br><br>

  <!-- 헤더에 삭제 버튼 추가 -->
  <div class="header-title mb-4">
    <h1>퀴즈 편집</h1>
    <button type="button" class="btn btn-danger" onclick="openDeleteQuizModal()">
      <i class="fas fa-trash-alt"></i> 삭제
    </button>
  </div>

  <form id="editQuizForm" action="<%= request.getContextPath() %>/editQuiz" method="post" enctype="multipart/form-data" autocomplete="off">
    <ul class="list-unstyled">
      <li class="mb-3">
        <b>퀴즈 제목</b>
        <input type="text" name="detailData.title" value="${detailData.title}" required class="form-control" autocomplete="off">
      </li>
      <li class="mb-3">
        <b>공개여부</b>
        <div class="custom-control custom-switch">
          <!-- 스위치가 체크되면 Y, 체크 해제되면 N을 전송 -->
          <input type="checkbox" class="custom-control-input" id="releaseSwitch" name="detailData.release" value="Y" <c:if test="${detailData.release == 'Y'}">checked</c:if> autocomplete="off">
          <label class="custom-control-label" for="releaseSwitch">Release</label>
        </div>
        <input type="hidden" name="detailData.release" value="N" autocomplete="off"/>
      </li>
      <li class="mb-3">
        <b>옵션</b>
        <table class="option-table table table-bordered">
          <thead>
          <tr>
            <th>옵션 1</th>
            <th>옵션 2</th>
            <th>옵션 3</th>
            <th>옵션 4</th>
          </tr>
          </thead>
          <tbody>
          <tr>
            <td>
              <input type="number" name="detailData.n1" value="${detailData.n1}" class="form-control option-input" min="0" autocomplete="off">
            </td>
            <td>
              <input type="number" name="detailData.n2" value="${detailData.n2}" class="form-control option-input" min="0" autocomplete="off">
            </td>
            <td>
              <input type="number" name="detailData.n3" value="${detailData.n3}" class="form-control option-input" min="0" autocomplete="off">
            </td>
            <td>
              <input type="number" name="detailData.n4" value="${detailData.n4}" class="form-control option-input" min="0" autocomplete="off">
            </td>
          </tr>
          </tbody>
        </table>
      </li>
      <li class="mb-3">
        <b>설명</b>
        <textarea name="detailData.exp" rows="4" class="form-control" autocomplete="off">${detailData.exp}</textarea>
      </li>
      <li class="mb-3" id="thumbnailPreview">
        <b>썸네일 이미지</b><br>
        <img id="thumbnailPreviewEdit" src="${pageContext.request.contextPath}/images/${detailData.id}.T" alt="썸네일 미리보기" class="thumbnail-preview">
        <input type="file" class="form-control-file" id="quizThumbnailEdit" name="thumbnail" accept=".jpg,.jpeg,.png,.webp" onchange="validateImage(this)" autocomplete="off">
        <small class="form-text text-muted">이미지 파일만 업로드 가능합니다 (.jpg, .jpeg, .png, .webp).</small>
      </li>
    </ul>
    <br><br><br>
    <h2>퀴즈 세부 항목</h2>
    <button type="button" class="btn btn-primary add-button" onclick="openAddModal()">+ 추가</button>
    <table class="table table-bordered">
      <thead>
      <tr>
        <th>세부 항목 ID</th>
        <th>문제 이미지</th>
        <th>정답 이미지</th>
        <th>정답 목록</th>
        <th>수정</th>
        <th>삭제</th>
      </tr>
      </thead>
      <tbody id="itemsTableBody">
      <c:choose>
        <c:when test="${playData.items != null && fn:length(playData.items) > 0}">
          <c:forEach var="item" items="${playData.items}" varStatus="status">
            <tr>
              <td>
                  ${item.detailId}
              </td>
              <td>
                <!-- 문제 이미지 미리보기 -->
                <img class="quizPreview" src="${pageContext.request.contextPath}/images/${item.detailId}/${item.imageId}.Q" alt="퀴즈 이미지 미리보기">
              </td>
              <td>
                <!-- 정답 이미지 미리보기 -->
                <img class="correctPreview" src="${pageContext.request.contextPath}/images/${item.detailId}/${item.imageId}.C" alt="정답 이미지 미리보기">
              </td>
              <td>
                <ul class="correct-answers-list" id="correctAnswersList_${item.detailId}">
                  <c:forEach var="answer" items="${item.correctAnswerSet}">
                    <li>
                      <span>${answer}</span>
                      <input type="hidden" name="items[${item.detailId}].correctAnswerSet" value="${answer}" autocomplete="off">
                    </li>
                  </c:forEach>
                </ul>
              </td>
              <td>
                <button type="button" class="btn btn-sm btn-warning" onclick="openEditModal('${item.detailId}', '${item.imageId}')">
                  <i class="fas fa-edit"></i> 수정
                </button>
              </td>
              <td>
                <button type="button" class="btn btn-sm btn-danger" onclick="openDeleteQuizDetailModal(this)">
                  <i class="fas fa-trash-alt"></i> 삭제
                </button>
              </td>
            </tr>
          </c:forEach>
        </c:when>
        <c:otherwise>
          <tr>
            <td colspan="6" style="text-align: center;">퀴즈 세부 항목이 없습니다.</td>
          </tr>
        </c:otherwise>
      </c:choose>
      </tbody>
    </table>

    <br/>

    <!-- 저장 버튼을 type="button"으로 변경하고 클릭 시 모달 열기 -->
    <button type="button" class="btn btn-success" onclick="openSaveModal()">저장</button>
  </form>
</div>

<!-- 퀴즈 세부 항목 추가 모달 -->
<div class="modal fade" id="addItemModal" tabindex="-1" role="dialog" aria-labelledby="addItemModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <form id="addItemForm">
        <div class="modal-header">
          <h5 class="modal-title" id="addItemModalLabel">퀴즈 세부 항목 추가</h5>
          <button type="button" class="close" data-dismiss="modal" aria-label="닫기">
            <span aria-hidden="true">&times;</span>
          </button>
        </div>
        <div class="modal-body">
          <!-- 세부 항목 ID (자동 생성 및 수정 불가) -->
          <div class="form-group">
            <label for="newdetailId">세부 항목 ID</label>
            <input type="text" class="form-control" id="newdetailId" name="newdetailId" readonly autocomplete="off">
          </div>
          <div class="form-group">
            <label for="newProblemImage">문제 이미지</label>
            <input type="file" class="form-control-file" id="newProblemImage" name="newProblemImage" accept=".jpg,.jpeg,.png,.webp" required onchange="validateImage(this)" autocomplete="off">
          </div>
          <div class="form-group">
            <label for="newAnswerImage">정답 이미지</label>
            <input type="file" class="form-control-file" id="newAnswerImage" name="newAnswerImage" accept=".jpg,.jpeg,.png,.webp" required onchange="validateImage(this)" autocomplete="off">
          </div>
          <div class="form-group">
            <label>정답 목록</label>
            <div id="newAnswersContainer">
              <!-- 정답 입력 필드 초기화 (삭제 버튼 포함) -->
              <div class="input-group mb-2">
                <input type="text" class="form-control answer-input" placeholder="정답 입력" required autocomplete="off">
                <div class="input-group-append">
                  <button class="btn btn-danger remove-answer-btn" type="button" onclick="removeAnswerInput(this)">-</button>
                </div>
              </div>
            </div>
            <div class="add-answer-button-container">
              <button type="button" class="btn btn-sm btn-secondary" onclick="addAnswerInput()">+ 정답 추가</button>
            </div>
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
          <button type="submit" class="btn btn-primary">저장</button>
        </div>
      </form>
    </div>
  </div>
</div>

<!-- 퀴즈 세부 항목 수정 모달 -->
<div class="modal fade" id="editItemModal" tabindex="-1" role="dialog" aria-labelledby="editItemModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <form id="editItemForm" action="<%= request.getContextPath() %>/editQuizDetail" method="post" enctype="multipart/form-data" autocomplete="off">
        <div class="modal-header">
          <h5 class="modal-title" id="editItemModalLabel">퀴즈 세부 항목 수정</h5>
          <button type="button" class="close" data-dismiss="modal" aria-label="닫기">
            <span aria-hidden="true">&times;</span>
          </button>
        </div>
        <div class="modal-body">
          <!-- 세부 항목 ID (수정 불가) -->
          <div class="form-group">
            <label for="editDetailId">세부 항목 ID</label>
            <input type="text" class="form-control" id="editDetailId" name="detailId" readonly autocomplete="off">
          </div>
          <div class="form-group">
            <label for="editProblemImage">문제 이미지</label><br>
            <img id="editProblemImagePreview" src="" alt="문제 이미지 미리보기" class="quizPreview mb-2">
            <input type="file" class="form-control-file" id="editProblemImage" name="problemImage" accept=".jpg,.jpeg,.png,.webp" onchange="validateImage(this)" autocomplete="off">
            <small class="form-text text-muted">새로운 이미지로 교체하려면 파일을 선택하세요.</small>
          </div>
          <div class="form-group">
            <label for="editAnswerImage">정답 이미지</label><br>
            <img id="editAnswerImagePreview" src="" alt="정답 이미지 미리보기" class="correctPreview mb-2">
            <input type="file" class="form-control-file" id="editAnswerImage" name="answerImage" accept=".jpg,.jpeg,.png,.webp" onchange="validateImage(this)" autocomplete="off">
            <small class="form-text text-muted">새로운 이미지로 교체하려면 파일을 선택하세요.</small>
          </div>
          <div class="form-group">
            <label>정답 목록</label>
            <div id="editAnswersContainer">
              <!-- 기존 정답 목록이 동적으로 추가됩니다 (삭제 버튼 포함) -->
            </div>
            <div class="add-answer-button-container">
              <button type="button" class="btn btn-sm btn-secondary" onclick="addEditAnswerInput()">+ 정답 추가</button>
            </div>
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
          <button type="submit" class="btn btn-primary">수정</button>
        </div>
      </form>
    </div>
  </div>
</div>

<!-- 퀴즈 삭제 확인 모달 (기존) -->
<div class="modal fade" id="deleteQuizModal" tabindex="-1" role="dialog" aria-labelledby="deleteQuizModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <form id="deleteQuizForm" action="<%= request.getContextPath() %>/deleteQuiz" method="post">
        <div class="modal-header">
          <h5 class="modal-title" id="deleteQuizModalLabel">퀴즈 삭제</h5>
          <button type="button" class="close" data-dismiss="modal" aria-label="닫기">
            <span aria-hidden="true">&times;</span>
          </button>
        </div>
        <div class="modal-body">
          정말로 이 퀴즈를 삭제하시겠습니까? 이 작업은 취소할 수 없습니다.
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
          <button type="submit" class="btn btn-danger">삭제</button>
        </div>
      </form>
    </div>
  </div>
</div>

<!-- 퀴즈 세부 항목 삭제 확인 모달 (기존) -->
<div class="modal fade" id="deleteQuizDetailModal" tabindex="-1" role="dialog" aria-labelledby="deleteQuizDetailModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="deleteQuizDetailModalLabel">세부 항목 삭제</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="닫기">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
        정말로 이 세부 항목을 삭제하시겠습니까?
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
        <button type="button" class="btn btn-danger" onclick="confirmDeleteQuizDetail()">삭제</button>
      </div>
    </div>
  </div>
</div>

<!-- 저장 확인 모달 (기존) -->
<div class="modal fade" id="saveQuizModal" tabindex="-1" role="dialog" aria-labelledby="saveQuizModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="saveQuizModalLabel">퀴즈 저장</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="닫기">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
        퀴즈를 저장하시겠습니까?
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
        <button type="button" class="btn btn-primary" onclick="submitEditQuizForm()">저장</button>
      </div>
    </div>
  </div>
</div>

<script>
  var contextPath = '<%= request.getContextPath() %>';
</script>

<!-- JavaScript 코드 -->
<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
<script>
  // 현재 최대 세부 항목 ID 저장
  let currentMaxId = 0;

  // 삭제할 세부 항목의 행을 저장할 변수
  let rowToDelete = null;

  // 퀴즈 세부 항목을 수정할 때 사용할 변수
  let editRowIndex = null;

  // 페이지 로드 시 현재 최대 세부 항목 ID 초기화 및 공개여부 스위치 상태 설정
  document.addEventListener('DOMContentLoaded', function() {
    const tableBody = document.getElementById('itemsTableBody');
    const rows = tableBody.getElementsByTagName('tr');
    let maxId = 0;
    for (let row of rows) {
      const detailId = row.cells[0].innerText;
      const idValue = parseInt(detailId);
      if (!isNaN(idValue) && idValue > maxId) {
        maxId = idValue;
      }
    }
    currentMaxId = maxId;
    updateOptionLimits();
    updateReleaseSwitch();
    enforceOptionLimits();
  });

  // 모달 열기 함수 (퀴즈 삭제)
  function openDeleteQuizModal() {
    $('#deleteQuizModal').modal('show');
  }

  // 모달 열기 함수 (퀴즈 세부 항목 삭제)
  function openDeleteQuizDetailModal(button) {
    rowToDelete = button.closest('tr');
    $('#deleteQuizDetailModal').modal('show');
  }

  // 퀴즈 세부 항목 삭제 확인 함수
  function confirmDeleteQuizDetail() {
    if (rowToDelete) {
      rowToDelete.remove();
      rowToDelete = null;
      $('#deleteQuizDetailModal').modal('hide');
      updateOptionLimits();
      updateReleaseSwitch();
    }
  }

  // 모달 열기 함수 (세부 항목 추가)
  function openAddModal() {
    // 세부 항목 ID 자동 생성
    currentMaxId += 1;
    document.getElementById('newdetailId').value = currentMaxId;

    // 기존 정답 입력 필드 초기화 (삭제 버튼 포함)
    const answersContainer = document.getElementById('newAnswersContainer');
    answersContainer.innerHTML =
            '<div class="input-group mb-2">' +
            '<input type="text" class="form-control answer-input" placeholder="정답 입력" required autocomplete="off">' +
            '<div class="input-group-append">' +
            '<button class="btn btn-danger remove-answer-btn" type="button" onclick="removeAnswerInput(this)">-</button>' +
            '</div>' +
            '</div>';
    $('#addItemModal').modal('show');
  }

  // 정답 입력 필드 추가 함수 (추가 모달)
  function addAnswerInput() {
    const answersContainer = document.getElementById('newAnswersContainer');
    const newInputGroup = document.createElement('div');
    newInputGroup.className = 'input-group mb-2';
    newInputGroup.innerHTML =
            '<input type="text" class="form-control answer-input" placeholder="정답 입력" required autocomplete="off">' +
            '<div class="input-group-append">' +
            '<button class="btn btn-danger remove-answer-btn" type="button" onclick="removeAnswerInput(this)">-</button>' +
            '</div>';
    answersContainer.appendChild(newInputGroup);
  }

  // 정답 입력 필드 삭제 함수 (추가 모달)
  function removeAnswerInput(button) {
    const inputGroup = button.closest('.input-group');
    inputGroup.remove();
  }

  // 퀴즈 세부 항목 추가 모달 폼 제출 함수
  document.getElementById('addItemForm').addEventListener('submit', function(event) {
    event.preventDefault();

    const detailId = document.getElementById('newdetailId').value.trim();
    const problemImage = document.getElementById('newProblemImage').files[0];
    const answerImage = document.getElementById('newAnswerImage').files[0];
    const answerInputs = document.querySelectorAll('.answer-input');
    const answers = [];

    answerInputs.forEach(input => {
      const answer = input.value.trim();
      if (answer !== '') {
        answers.push(answer);
      }
    });

    if (detailId === '' || !problemImage || !answerImage || answers.length === 0) {
      alert('모든 필드를 채워주세요. (정답은 최소 1개)');
      return;
    }

    // imageId는 detailId와 동일하게 설정 (필요에 따라 별도로 생성 가능)
    const imageId = detailId;

    // 테이블에 새로운 행 추가
    const tableBody = document.getElementById('itemsTableBody');
    const newIndex = detailId; // detailId를 인덱스로 사용

    const newRow = document.createElement('tr');

    // 세부 항목 ID
    const detailIdCell = document.createElement('td');
    detailIdCell.innerText = detailId;
    newRow.appendChild(detailIdCell);

    // 문제 이미지 미리보기
    const problemImageCell = document.createElement('td');
    const problemImg = document.createElement('img');
    problemImg.className = 'quizPreview';
    problemImg.src = contextPath + "/images/" + detailId + "/" + imageId + ".Q";
    problemImageCell.appendChild(problemImg);
    newRow.appendChild(problemImageCell);

    // 정답 이미지 미리보기
    const answerImageCell = document.createElement('td');
    const answerImg = document.createElement('img');
    answerImg.className = 'correctPreview';
    answerImg.src = contextPath + "/images/" + detailId + "/" + imageId + ".C";
    answerImageCell.appendChild(answerImg);
    newRow.appendChild(answerImageCell);

    // 정답 목록 (삭제 버튼 없음)
    const correctAnswersCell = document.createElement('td');
    const answersList = document.createElement('ul');
    answersList.className = 'correct-answers-list';
    answersList.id = 'correctAnswersList_' + detailId;
    correctAnswersCell.appendChild(answersList);

    answers.forEach(answer => {
      const listItem = document.createElement('li');
      listItem.innerHTML =
              '<span>' + answer + '</span>' +
              '<input type="hidden" name="items[' + detailId + '].correctAnswerSet" value="' + answer + '" autocomplete="off">';
      answersList.appendChild(listItem);
    });

    // 정답 추가 버튼 제거
    // 주석 처리 또는 삭제
    /*
    const addAnswerButtonContainer = document.createElement('div');
    addAnswerButtonContainer.className = 'add-answer-button-container';
    const addAnswerButton = document.createElement('button');
    addAnswerButton.type = 'button';
    addAnswerButton.className = 'btn btn-sm btn-secondary';
    addAnswerButton.textContent = '정답 추가';
    addAnswerButton.onclick = function() {
      openModal(detailId);
    };
    addAnswerButtonContainer.appendChild(addAnswerButton);
    correctAnswersCell.appendChild(addAnswerButtonContainer);
    */

    newRow.appendChild(correctAnswersCell);

    // 수정 버튼 추가
    const editCell = document.createElement('td');
    const editButton = document.createElement('button');
    editButton.type = 'button';
    editButton.className = 'btn btn-sm btn-warning';
    editButton.innerHTML = '<i class="fas fa-edit"></i> 수정';
    editButton.onclick = function() {
      openEditModal(detailId, imageId);
    };
    editCell.appendChild(editButton);
    newRow.appendChild(editCell);

    // 삭제 버튼 추가
    const deleteCell = document.createElement('td');
    const deleteButton = document.createElement('button');
    deleteButton.type = 'button';
    deleteButton.className = 'btn btn-sm btn-danger';
    deleteButton.innerHTML = '<i class="fas fa-trash-alt"></i> 삭제';
    deleteButton.onclick = function() {
      openDeleteQuizDetailModal(deleteButton);
    };
    deleteCell.appendChild(deleteButton);
    newRow.appendChild(deleteCell);

    // 새 행을 테이블 하단에 추가
    tableBody.appendChild(newRow);
    updateOptionLimits();
    updateReleaseSwitch();

    // 모달 닫기 및 폼 초기화
    $('#addItemModal').modal('hide');
    document.getElementById('addItemForm').reset();
    // 정답 입력 필드 초기화 (삭제 버튼 포함)
    document.getElementById('newAnswersContainer').innerHTML =
            '<div class="input-group mb-2">' +
            '<input type="text" class="form-control answer-input" placeholder="정답 입력" required autocomplete="off">' +
            '<div class="input-group-append">' +
            '<button class="btn btn-danger remove-answer-btn" type="button" onclick="removeAnswerInput(this)">-</button>' +
            '</div>' +
            '</div>';
  });

  // 이미지 파일 유효성 검사 함수 (기존)
  function validateImage(input) {
    const file = input.files[0];
    if (file) {
      const validImageExtensions = ['jpg', 'jpeg', 'png', 'webp'];
      const fileExtension = file.name.split('.').pop().toLowerCase();
      if (!validImageExtensions.includes(fileExtension)) {
        alert('이미지 파일만 업로드할 수 있습니다 (.jpg, .jpeg, .png, .webp).');
        input.value = ''; // 선택된 파일 초기화
      }
    }
  }

  // 옵션 입력 필드의 최대값을 퀴즈 세부 항목 개수로 제한 (기존)
  function updateOptionLimits() {
    const optionInputs = document.querySelectorAll('.option-input');
    const itemsTableBody = document.getElementById('itemsTableBody');
    const numberOfDetails = itemsTableBody.getElementsByTagName('tr').length;

    optionInputs.forEach(input => {
      input.max = numberOfDetails;
    });
  }

  // 공개여부 스위치 활성화/비활성화 함수 (기존)
  function updateReleaseSwitch() {
    const itemsTableBody = document.getElementById('itemsTableBody');
    const rowCount = itemsTableBody.getElementsByTagName('tr').length;
    const releaseSwitch = document.getElementById('releaseSwitch');

    if (rowCount > 0) {
      releaseSwitch.disabled = false;
    } else {
      releaseSwitch.disabled = true;
      releaseSwitch.checked = false;
    }
  }

  // 옵션 입력 필드의 값 변경 시 제한을 확인 (기존)
  function enforceOptionLimits() {
    const optionInputs = document.querySelectorAll('.option-input');
    optionInputs.forEach(input => {
      input.addEventListener('input', function() {
        const max = parseInt(this.max);
        const value = parseInt(this.value);
        if (value > max) {
          this.value = max;
          alert('옵션 값은 최대 ' + max + '까지 가능합니다.');
        } else if (value < 0) {
          this.value = 0;
          alert('옵션 값은 0 이상이어야 합니다.');
        }
      });
    });
  }

  // 저장 버튼 클릭 시 모달 열기 (기존)
  function openSaveModal() {
    $('#saveQuizModal').modal('show');
  }

  // 저장 확인 시 폼 제출 (기존)
  function submitEditQuizForm() {
    document.getElementById('editQuizForm').submit();
  }

  // 초기 옵션 제한 설정 (기존)
  document.addEventListener('DOMContentLoaded', function() {
    enforceOptionLimits();
  });

  // 테이블에 행이 추가되거나 제거될 때 옵션 제한을 업데이트 (기존)
  const observer = new MutationObserver(function(mutationsList, observer) {
    updateOptionLimits();
    updateReleaseSwitch();
  });

  const tableBody = document.getElementById('itemsTableBody');
  observer.observe(tableBody, { childList: true });

  // 퀴즈 세부 항목 수정 모달 열기 함수
  function openEditModal(detailId, imageId) {
    // editRowIndex를 detailId로 설정
    editRowIndex = detailId;

    // 세부 항목 ID 설정
    document.getElementById('editDetailId').value = detailId;
    // 문제 이미지 미리보기 설정
    document.getElementById('editProblemImagePreview').src = contextPath + "/images/" + detailId + "/" + imageId + ".Q";
    // 정답 이미지 미리보기 설정
    document.getElementById('editAnswerImagePreview').src = contextPath + "/images/" + detailId + "/" + imageId + ".C";

    // 기존 정답 목록 가져오기
    const answersList = document.getElementById('correctAnswersList_' + detailId);
    const editAnswersContainer = document.getElementById('editAnswersContainer');
    editAnswersContainer.innerHTML = ''; // 초기화

    if (answersList) {
      const answers = answersList.querySelectorAll('li');
      answers.forEach((li) => {
        const answerValue = li.querySelector('span').innerText;
        const inputGroup = document.createElement('div');
        inputGroup.className = 'input-group mb-2';
        inputGroup.innerHTML =
                '<input type="hidden" name="items[' + detailId + '].originalCorrectAnswerSet" value="' + answerValue + '" autocomplete="off">' +
                '<input type="text" class="form-control answer-input" name="items[' + detailId + '].correctAnswerSet" value="' + answerValue + '" required autocomplete="off">' +
                '<div class="input-group-append">' +
                '<button class="btn btn-danger remove-answer-btn" type="button" onclick="removeEditAnswerInput(this)">-</button>' +
                '</div>';
        editAnswersContainer.appendChild(inputGroup);
      });
    }

    $('#editItemModal').modal('show');
  }

  // 정답 입력 필드 추가 함수 (수정 모달)
  function addEditAnswerInput() {
    const editAnswersContainer = document.getElementById('editAnswersContainer');
    const newInputGroup = document.createElement('div');
    newInputGroup.className = 'input-group mb-2';
    newInputGroup.innerHTML =
            '<input type="text" class="form-control answer-input" name="items[' + editRowIndex + '].correctAnswerSet" placeholder="정답 입력" required autocomplete="off">' +
            '<div class="input-group-append">' +
            '<button class="btn btn-danger remove-answer-btn" type="button" onclick="removeEditAnswerInput(this)">-</button>' +
            '</div>';
    editAnswersContainer.appendChild(newInputGroup);
  }

  // 정답 입력 필드 삭제 함수 (수정 모달)
  function removeEditAnswerInput(button) {
    const inputGroup = button.closest('.input-group');
    inputGroup.remove();
  }

  // 퀴즈 세부 항목 수정 모달 폼 제출 함수
  document.getElementById('editItemForm').addEventListener('submit', function(event) {
    event.preventDefault();

    const form = this;
    const formData = new FormData(form);

    // AJAX를 사용하여 수정 요청을 보냅니다.
    $.ajax({
      url: form.action,
      type: form.method,
      data: formData,
      processData: false,
      contentType: false,
      success: function(response) {
        // 성공 시 페이지를 새로 고침하거나 필요한 작업을 수행합니다.
        location.reload();
      },
      error: function(xhr, status, error) {
        alert('수정 중 오류가 발생했습니다.');
      }
    });
  });
</script>
</body>
</html>
