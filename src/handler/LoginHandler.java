package handler;

import dao.QuizDAO;
import model.Quiz;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;

public class LoginHandler implements Handler {

    @Override
    public String handleRequest(HttpServletRequest request, HttpServletResponse response) {
        return "login";
    }

}
