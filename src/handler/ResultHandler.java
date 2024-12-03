package handler;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Map;

public class ResultHandler implements Handler {

    @Override
    public String handleRequest(HttpServletRequest request, HttpServletResponse response) {
        HttpSession session = request.getSession();
        Map<String, Object> quizResult = (Map<String, Object>) session.getAttribute("quizResult");

        if (quizResult == null) {
            try {
                response.sendRedirect(request.getContextPath() + "/views/index");
                return null;
            } catch (IOException e) {
                e.printStackTrace();
                return null;
            }
        }

        // 세션 데이터 삭제
        session.removeAttribute("quizResult");

        // 결과 데이터를 리퀘스트에 전달
        request.setAttribute("quizResult", quizResult);

        return "/views/quizResult";
    }
}
