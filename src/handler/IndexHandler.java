package handler;

import dao.QuizDAO;
import model.Quiz;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;

import static util.FileSystem.*;

public class IndexHandler implements Handler {

    @Override
    public String handleRequest(HttpServletRequest request, HttpServletResponse response) {
        QuizDAO quizDAO = new QuizDAO();
        List<Quiz> quizzes = quizDAO.getQuizzesByOffset(1, 12);
        request.setAttribute("quizzes", quizzes);
        return "/views/index";
    }

}
