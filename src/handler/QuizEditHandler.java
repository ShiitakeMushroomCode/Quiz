package handler;

import bean.DetailData;
import dao.QuizDAO;
import dao.UserDAO;
import model.Quiz;
import model.User;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class QuizEditHandler implements Handler {
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


        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            return "/views/notFound"; // id가 없는 경우 처리
        }

        int id;
        try {
            id = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            return "/views/notFound"; // id가 유효한 숫자가 아닌 경우 처리
        }

        // DAO를 사용하여 데이터베이스에서 Quiz 객체 가져오기
        QuizDAO quizDAO = new QuizDAO();
        Quiz quiz = quizDAO.getQuizById(id);

        if (quiz == null) {
            return "/views/notFound"; // 해당 id의 퀴즈가 없는 경우 처리
        }

        return "/views/editQuiz"; // 정상적으로 처리된 경우
    }
}
