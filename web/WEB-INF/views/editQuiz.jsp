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
  <style>
    /* 추가적인 스타일링 */
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
    #addItemModal .option-input {
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
  </style>
</head>
<body>
<%@ include file="/WEB-INF/components/header.jsp" %>

<div class="container">
  <br><br>
  <h1>퀴즈 편집</h1>

  <form action="yourBackendEndpoint" method="post" enctype="multipart/form-data" autocomplete="off">
    <ul class="list-unstyled">
      <li class="mb-3">
        <b>퀴즈 제목</b>
        <input type="text" name="detailData.title" value="${detailData.title}" required class="form-control" autocomplete="off">
      </li>
      <li class="mb-3">
        <b>공개여부:</b>
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
    <button type="button" class="btn btn-primary add-button" onclick="openAddModal()">+</button>
    <table class="table table-bordered">
      <thead>
      <tr>
        <th>세부 항목 ID</th>
        <th>문제 이미지</th>
        <th>정답 이미지</th>
        <th>정답 목록</th>
        <th>삭제</th>
      </tr>
      </thead>
      <tbody id="itemsTableBody">
      <c:choose>
        <c:when test="${playData.items != null && fn:length(playData.items) > 0}">
          <c:forEach var="item" items="${playData.items}" varStatus="status">
            <tr>
              <td>
                <input type="text" name="items[${status.index}].imageId" value="${item.imageId}" readonly class="form-control" autocomplete="off">
              </td>
              <td>
                <!-- 문제 이미지 업로드 -->
                <img class="quizPreview" src="${pageContext.request.contextPath}/images/${item.detailId}/${item.imageId}.Q" alt="퀴즈 이미지 미리보기">
                <input type="file" name="items[${status.index}].problemImage" accept=".jpg,.jpeg,.png,.webp" class="form-control-file" onchange="validateImage(this)" autocomplete="off">
              </td>
              <td>
                <!-- 정답 이미지 업로드 -->
                <img class="correctPreview" src="${pageContext.request.contextPath}/images/${item.detailId}/${item.imageId}.C" alt="퀴즈 이미지 미리보기">
                <input type="file" name="items[${status.index}].answerImage" accept=".jpg,.jpeg,.png,.webp" class="form-control-file" onchange="validateImage(this)" autocomplete="off">
              </td>
              <td>
                <ul class="correct-answers-list" id="correctAnswersList_${status.index}">
                  <c:forEach var="answer" items="${item.correctAnswerSet}">
                    <li>
                      <span>${answer}</span>
                      <button type="button" class="btn btn-sm btn-danger" onclick="removeAnswer(this)">삭제</button>
                      <input type="hidden" name="items[${status.index}].correctAnswerSet" value="${answer}" autocomplete="off">
                    </li>
                  </c:forEach>
                </ul>
                <div class="add-answer-button-container">
                  <button type="button" class="btn btn-sm btn-secondary" onclick="openModal(${status.index})">정답 추가</button>
                </div>
              </td>
              <td>
                <button type="button" class="btn btn-sm btn-danger" onclick="removeRow(this)">삭제</button>
              </td>
            </tr>
          </c:forEach>
        </c:when>
        <c:otherwise>
          <tr>
            <td colspan="5" style="text-align: center;">퀴즈 세부 항목이 없습니다.</td>
          </tr>
        </c:otherwise>
      </c:choose>
      </tbody>
    </table>

    <br/>
    <button type="submit" class="btn btn-success">저장</button>
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

<!-- 정답 추가 모달 -->
<div class="modal fade" id="answerModal" tabindex="-1" role="dialog" aria-labelledby="answerModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <form id="answerForm">
        <div class="modal-header">
          <h5 class="modal-title" id="answerModalLabel">정답 추가</h5>
          <button type="button" class="close" data-dismiss="modal" aria-label="닫기">
            <span aria-hidden="true">&times;</span>
          </button>
        </div>
        <div class="modal-body">
          <div class="form-group">
            <label for="newAnswer">정답</label>
            <input type="text" class="form-control" id="newAnswer" required autocomplete="off">
          </div>
          <input type="hidden" id="currentRowIndex" value="">
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
          <button type="submit" class="btn btn-primary">추가</button>
        </div>
      </form>
    </div>
  </div>
</div>

<!-- Bootstrap JS 및 의존성 스크립트 -->
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
<script>
  // 현재 최대 세부 항목 ID 저장
  let currentMaxId = 0;

  // 페이지 로드 시 현재 최대 세부 항목 ID 초기화
  document.addEventListener('DOMContentLoaded', function() {
    const tableBody = document.getElementById('itemsTableBody');
    const rows = tableBody.getElementsByTagName('tr');
    let maxId = 0;
    for (let row of rows) {
      const idInput = row.querySelector('input[name$=".detailId"]');
      if (idInput) {
        const idValue = parseInt(idInput.value);
        if (!isNaN(idValue) && idValue > maxId) {
          maxId = idValue;
        }
      }
    }
    currentMaxId = maxId;
    updateOptionLimits();
  });

  // 모달 열기 함수 (세부 항목 추가)
  function openAddModal() {
    // 세부 항목 ID 자동 생성
    currentMaxId += 1;
    document.getElementById('newdetailId').value = currentMaxId;

    // 기존 정답 입력 필드 초기화
    const answersContainer = document.getElementById('newAnswersContainer');
    answersContainer.innerHTML = `
      <div class="input-group mb-2">
        <input type="text" class="form-control answer-input" placeholder="정답 입력" required autocomplete="off">
        <div class="input-group-append">
          <button class="btn btn-danger remove-answer-btn" type="button" onclick="removeAnswerInput(this)">-</button>
        </div>
      </div>
    `;
    $('#addItemModal').modal('show');
  }

  // 정답 입력 필드 추가 함수
  function addAnswerInput() {
    const answersContainer = document.getElementById('newAnswersContainer');
    const newInputGroup = document.createElement('div');
    newInputGroup.className = 'input-group mb-2';
    newInputGroup.innerHTML = `
      <input type="text" class="form-control answer-input" placeholder="정답 입력" required autocomplete="off">
      <div class="input-group-append">
        <button class="btn btn-danger remove-answer-btn" type="button" onclick="removeAnswerInput(this)">-</button>
      </div>
    `;
    answersContainer.appendChild(newInputGroup);
  }

  // 정답 입력 필드 삭제 함수
  function removeAnswerInput(button) {
    const inputGroup = button.closest('.input-group');
    inputGroup.remove();
  }

  // 정답 추가 모달 열기 함수
  function openModal(index) {
    currentRowIndex = index;
    document.getElementById('currentRowIndex').value = index;
    document.getElementById('newAnswer').value = '';
    $('#answerModal').modal('show');
  }

  // 정답 추가 함수
  document.getElementById('answerForm').addEventListener('submit', function(event) {
    event.preventDefault();
    const answerInput = document.getElementById('newAnswer');
    const answer = answerInput.value.trim();
    const rowIndex = document.getElementById('currentRowIndex').value;

    if (answer === '') {
      alert('정답을 입력해주세요.');
      return;
    }

    // 정답 목록에 추가
    const answersList = document.getElementById(`correctAnswersList_${rowIndex}`);
    const listItem = document.createElement('li');
    listItem.innerHTML = `
      <span>${answer}</span>
      <button type="button" class="btn btn-sm btn-danger" onclick="removeAnswer(this)">삭제</button>
      <input type="hidden" name="items[${rowIndex}].correctAnswerSet" value="${answer}" autocomplete="off">
    `;
    answersList.appendChild(listItem);

    // 모달 닫기
    $('#answerModal').modal('hide');
  });

  // 행 삭제 함수
  function removeRow(button) {
    const row = button.closest('tr');
    row.remove();
    updateOptionLimits();
  }

  // 정답 삭제 함수
  function removeAnswer(button) {
    const listItem = button.closest('li');
    listItem.remove();
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

    // 테이블에 새로운 행 추가
    const tableBody = document.getElementById('itemsTableBody');
    const rowCount = tableBody.getElementsByTagName('tr').length;
    const newIndex = rowCount;

    const newRow = document.createElement('tr');

    // 세부 항목 ID - 읽기 전용으로 설정
    const detailIdCell = document.createElement('td');
    const detailIdInput = document.createElement('input');
    detailIdInput.type = 'text';
    detailIdInput.name = `items[${newIndex}].detailId`;
    detailIdInput.value = detailId;
    detailIdInput.readOnly = true;
    detailIdInput.className = "form-control";
    detailIdInput.setAttribute('autocomplete', 'off');
    detailIdCell.appendChild(detailIdInput);
    newRow.appendChild(detailIdCell);

    // 문제 이미지 업로드
    const problemImageCell = document.createElement('td');
    const problemImageInput = document.createElement('input');
    problemImageInput.type = 'file';
    problemImageInput.name = `items[${newIndex}].problemImage`;
    problemImageInput.accept = '.jpg,.jpeg,.png,.webp';
    problemImageInput.className = 'form-control-file';
    problemImageInput.onchange = function() { validateImage(this); };
    problemImageInput.setAttribute('autocomplete', 'off');
    problemImageCell.appendChild(problemImageInput);
    newRow.appendChild(problemImageCell);

    // 정답 이미지 업로드
    const answerImageCell = document.createElement('td');
    const answerImageInput = document.createElement('input');
    answerImageInput.type = 'file';
    answerImageInput.name = `items[${newIndex}].answerImage`;
    answerImageInput.accept = '.jpg,.jpeg,.png,.webp';
    answerImageInput.className = 'form-control-file';
    answerImageInput.onchange = function() { validateImage(this); };
    answerImageInput.setAttribute('autocomplete', 'off');
    answerImageCell.appendChild(answerImageInput);
    newRow.appendChild(answerImageCell);

    // 정답 목록
    const correctAnswersCell = document.createElement('td');
    const answersList = document.createElement('ul');
    answersList.className = 'correct-answers-list';
    answersList.id = `correctAnswersList_${newIndex}`;
    correctAnswersCell.appendChild(answersList);

    answers.forEach(answer => {
      const listItem = document.createElement('li');
      listItem.innerHTML = `
        <span>${answer}</span>
        <button type="button" class="btn btn-sm btn-danger" onclick="removeAnswer(this)">삭제</button>
        <input type="hidden" name="items[${newIndex}].correctAnswerSet" value="${answer}" autocomplete="off">
      `;
      answersList.appendChild(listItem);
    });

    // 정답 추가 버튼 가운데 정렬
    const addAnswerButtonContainer = document.createElement('div');
    addAnswerButtonContainer.className = 'add-answer-button-container';
    const addAnswerButton = document.createElement('button');
    addAnswerButton.type = 'button';
    addAnswerButton.className = 'btn btn-sm btn-secondary';
    addAnswerButton.textContent = '정답 추가';
    addAnswerButton.onclick = function() {
      openModal(newIndex);
    };
    addAnswerButtonContainer.appendChild(addAnswerButton);
    correctAnswersCell.appendChild(addAnswerButtonContainer);
    newRow.appendChild(correctAnswersCell);

    // 삭제 버튼 추가
    const deleteCell = document.createElement('td');
    const deleteButton = document.createElement('button');
    deleteButton.type = 'button';
    deleteButton.className = 'btn btn-sm btn-danger';
    deleteButton.textContent = '삭제';
    deleteButton.onclick = function() {
      removeRow(deleteButton);
    };
    deleteCell.appendChild(deleteButton);
    newRow.appendChild(deleteCell);

    // 새 행을 테이블 하단에 추가
    tableBody.appendChild(newRow);
    updateOptionLimits();

    // 모달 닫기 및 폼 초기화
    $('#addItemModal').modal('hide');
    document.getElementById('addItemForm').reset();
    // 정답 입력 필드 초기화
    document.getElementById('newAnswersContainer').innerHTML = `
      <div class="input-group mb-2">
        <input type="text" class="form-control answer-input" placeholder="정답 입력" required autocomplete="off">
        <div class="input-group-append">
          <button class="btn btn-danger remove-answer-btn" type="button" onclick="removeAnswerInput(this)">-</button>
        </div>
      </div>
    `;
  });

  // 이미지 파일 유효성 검사 함수
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

  // 옵션 입력 필드의 최대값을 퀴즈 세부 항목 개수로 제한
  function updateOptionLimits() {
    const optionInputs = document.querySelectorAll('.option-input');
    const itemsTableBody = document.getElementById('itemsTableBody');
    const numberOfDetails = itemsTableBody.getElementsByTagName('tr').length;

    optionInputs.forEach(input => {
      input.max = numberOfDetails;
    });
  }

  // 옵션 입력 필드의 값 변경 시 제한을 확인
  function enforceOptionLimits() {
    const optionInputs = document.querySelectorAll('.option-input');
    optionInputs.forEach(input => {
      input.addEventListener('input', function() {
        const max = parseInt(this.max);
        const value = parseInt(this.value);
        if (value > max) {
          this.value = max;
          alert(`옵션 값은 최대 ${max}까지 가능합니다.`);
        } else if (value < 0) {
          this.value = 0;
          alert('옵션 값은 0 이상이어야 합니다.');
        }
      });
    });
  }

  // 초기 옵션 제한 설정
  document.addEventListener('DOMContentLoaded', function() {
    enforceOptionLimits();
  });

  // 테이블에 행이 추가되거나 제거될 때 옵션 제한을 업데이트
  const observer = new MutationObserver(function(mutationsList, observer) {
    updateOptionLimits();
  });

  const tableBody = document.getElementById('itemsTableBody');
  observer.observe(tableBody, { childList: true });

</script>
</body>
</html>
