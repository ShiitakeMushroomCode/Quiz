package handler;

import dao.QuizDAO;
import model.Quiz;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;

public class MoreQuizzesHandler implements Handler {
    @Override
    public String handleRequest(HttpServletRequest request, HttpServletResponse response) {
        try {
            int offset = 0;
            int size = 24;

            if (request.getParameter("offset") != null) {
                offset = Integer.parseInt(request.getParameter("offset"));
            }
            if (request.getParameter("size") != null) {
                size = Integer.parseInt(request.getParameter("size"));
            }

            // QuizDAO를 통해 데이터 가져오기
            QuizDAO quizDAO = new QuizDAO();
            List<Quiz> quizzes = quizDAO.getQuizzesByOffset(offset, size);

            // 데이터를 요청 객체에 저장
            request.setAttribute("quizzes", quizzes);

            // 뷰 이름 반환
            return "loadMoreQuizzes";
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "퀴즈를 로드하는 중 오류가 발생했습니다.");
            return "error"; // 에러 페이지로 이동
        }
    }
}
