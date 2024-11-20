package handler;

import dao.QuizDAO;
import model.Quiz;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;

public class IndexHandler implements Handler {

	@Override
	public String handleRequest(HttpServletRequest request, HttpServletResponse response) {
		QuizDAO quizDAO = new QuizDAO();
		List<Quiz> quizzes = quizDAO.getAllQuizzes();

		request.setAttribute("quizzes", quizzes);
		return "index";
	}

}
