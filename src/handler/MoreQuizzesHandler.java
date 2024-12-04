package handler;

import dao.QuizDAO;
import dao.UserDAO;
import model.Quiz;
import model.User;

import javax.servlet.http.*;
import java.util.List;

public class MoreQuizzesHandler implements Handler {
    @Override
    public String handleRequest(HttpServletRequest request, HttpServletResponse response) {
        try {
            int offset = 0;
            int size = 24;
            String searchValue = request.getParameter("searchInput");
            String filter = request.getParameter("filter");

            if (filter == null || filter.isEmpty()) {
                filter = "popular";
            }

            if (request.getParameter("offset") != null) {
                offset = Integer.parseInt(request.getParameter("offset"));
            }
            if (request.getParameter("size") != null) {
                size = Integer.parseInt(request.getParameter("size"));
            }

            // 요청이 마이퀴즈 페이지에서 왔는지 확인
            String referer = request.getHeader("Referer");
            boolean isMyQuizPage = referer != null && referer.contains("myquiz");

            // QuizDAO를 통해 데이터 가져오기
            QuizDAO quizDAO = new QuizDAO();
            List<Quiz> quizzes;

            if (isMyQuizPage) {
                // 로그인된 사용자 정보 가져오기
                HttpSession session = request.getSession(false);
                if (session == null || session.getAttribute("user") == null) {
                    // 비로그인 상태라면 에러 반환
                    response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                    return null;
                }
                User user = (User) session.getAttribute("user");
                long kakaoId = user.getKakaoId();

                UserDAO userDAO = new UserDAO();
                int userId = userDAO.findByKakaoId(kakaoId).getId();

                quizzes = quizDAO.getQuizzesByOwnerIdAndOffset(userId, offset, size, searchValue, filter);
            } else {
                quizzes = quizDAO.getQuizzesByOffsetAndSearch(offset, size, searchValue, filter);
            }

            if (quizzes.isEmpty()) {
                // 더 이상 로드할 퀴즈가 없음
                response.setStatus(HttpServletResponse.SC_NO_CONTENT);
                return null;
            }

            // 데이터를 요청 객체에 저장
            request.setAttribute("quizzes", quizzes);

            // 뷰 이름 반환
            return "/components/loadMoreQuizzes";
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "퀴즈를 로드하는 중 오류가 발생했습니다.");
            return "/views/error"; // 에러 페이지로 이동
        }
    }
}
