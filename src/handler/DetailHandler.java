package handler;

import bean.DetailData;
import dao.QuizDAO;
import model.Quiz;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class DetailHandler implements Handler {
    @Override
    public String handleRequest(HttpServletRequest request, HttpServletResponse response) {
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

        // DetailData Bean 생성 및 데이터 설정
        DetailData detailData = new DetailData();
        detailData.setTitle(String.valueOf(quiz.getQuizName()));
        detailData.setId(String.valueOf(quiz.getQuizId()));
        detailData.setN1(String.valueOf(quiz.getN1()));
        detailData.setN2(String.valueOf(quiz.getN2()));
        detailData.setN3(String.valueOf(quiz.getN3()));
        detailData.setN4(String.valueOf(quiz.getN4()));
        detailData.setExp(quiz.getExp());

        // Bean을 request에 설정
        request.setAttribute("detailData", detailData);
        return "/views/detail"; // 정상적으로 처리된 경우
    }
}
