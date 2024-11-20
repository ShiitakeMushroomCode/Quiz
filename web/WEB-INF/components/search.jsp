<%@ page contentType="text/html; charset=UTF-8"
		 pageEncoding="UTF-8"%>
<div class="search-container-wrapper">
	<div class="container search-container">
		<div class="filter-dropdown-wrapper">
			<!-- 필터 버튼 -->
			<button class="filter-button" onclick="toggleDropdown(event)">
				<img
					src="${pageContext.request.contextPath}/static/icons/FilterBtn.png"
					alt="필터" />
			</button>
			<!-- 드롭다운 메뉴 -->
			<div class="dropdown-menu">
				<span onclick="selectFilter(event, 'popular')">인기순</span> <span
					onclick="selectFilter(event, 'recent')">최신순</span>
			</div>
		</div>
		<input name="searchInput" type="text" placeholder="검색창"
			autocomplete="off">
		<button class="search-button">
			<img
				src="${pageContext.request.contextPath}/static/icons/SearchBtn.png"
				alt="검색">
		</button>
	</div>
	<script type="text/javascript">
		// 드롭다운 토글
		function toggleDropdown(event) {
			event.preventDefault();
			const wrapper = event.target.closest('.filter-dropdown-wrapper');
			wrapper.classList.toggle('active');
		}

		// 필터 선택
		function selectFilter(event, value) {
			event.preventDefault();

			// 모든 span에서 'selected' 클래스 제거
			const spans = document.querySelectorAll('.dropdown-menu span');
			spans.forEach(span => span.classList.remove('selected'));

			// 선택한 span에 'selected' 클래스 추가
			const selectedSpan = event.target;
			selectedSpan.classList.add('selected');

			// 선택된 값을 로컬 스토리지에 저장
			localStorage.setItem('selectedFilter', value);

			// 드롭다운 닫기
			const wrapper = event.target.closest('.filter-dropdown-wrapper');
			wrapper.classList.remove('active');

			// 선택된 필터 값을 hidden input에 저장
			let hiddenInput = document.querySelector('input[name="filter"]');
			if (!hiddenInput) {
				hiddenInput = document.createElement('input');
				hiddenInput.type = 'hidden';
				hiddenInput.name = 'filter';
				document.querySelector('.search-container').appendChild(hiddenInput);
			}
			hiddenInput.value = value;
		}

		// 페이지 로드 시 선택된 필터 복원
		window.addEventListener('DOMContentLoaded', () => {
			let selectedFilter = localStorage.getItem('selectedFilter');

			// 로컬 스토리지 값이 없으면 기본값으로 "popular" 설정
			if (!selectedFilter) {
				selectedFilter = 'popular';
				localStorage.setItem('selectedFilter', 'popular');
			}

			// 선택된 필터를 복원
			const spans = document.querySelectorAll('.dropdown-menu span');
			spans.forEach(span => {
				if (span.getAttribute('onclick').includes(selectedFilter)) {
					span.classList.add('selected');
				}
			});

			// 선택된 값을 hidden input에 저장
			let hiddenInput = document.querySelector('input[name="filter"]');
			if (!hiddenInput) {
				hiddenInput = document.createElement('input');
				hiddenInput.type = 'hidden';
				hiddenInput.name = 'filter';
				document.querySelector('.search-container').appendChild(hiddenInput);
			}
			hiddenInput.value = selectedFilter;
		});
	</script>
</div>
