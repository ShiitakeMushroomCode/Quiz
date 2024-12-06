package handler;

import dao.QuizDAO;
import dao.UserDAO;
import model.Quiz;
import model.User;

import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class MyQuizHandler implements Handler {
    @Override
    public String handleRequest(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            // 비로그인 상태라면 로그인 페이지로 리다이렉트
            response.sendRedirect(request.getContextPath() + "/views/index");
            return null;
        }

        // 로그인된 사용자 정보 가져오기
        User user = (User) session.getAttribute("user");
        long kakaoId = user.getKakaoId(); // User 객체에 getUserId() 메서드가 있다고 가정

        UserDAO userDAO = new UserDAO();
        int userId = userDAO.findByKakaoId(kakaoId).getId();

        // 파라미터 값 가져오기
        String searchValue = request.getParameter("searchInput");
        String filter = request.getParameter("filter");

        if (filter == null || filter.isEmpty()) {
            filter = "popular";
        }

        int offset = 0;
        int size = 12;

        // QuizDAO를 통해 데이터 가져오기
        QuizDAO quizDAO = new QuizDAO();
        List<Quiz> quizzes = quizDAO.getQuizzesByOwnerIdAndOffset(userId, offset, size, searchValue, filter);

        // 총 퀴즈 수 가져오기
        int totalQuizzes = quizDAO.getTotalQuizCountByOwnerId(userId, searchValue);

        // 데이터를 요청 객체에 저장
        request.setAttribute("quizzes", quizzes);
        request.setAttribute("totalQuizzes", totalQuizzes);

        // 마이퀴즈 페이지로 이동
        return "/views/myquiz";
    }
}
