package handler;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class PlayHandler implements Handler {
    @Override
    public String handleRequest(HttpServletRequest request, HttpServletResponse response) {
        // 요청에 포함된 id를 가져오기
        String id = request.getParameter("id");
        String count = request.getParameter("count");

        // 예: 데이터베이스에서 id에 해당하는 데이터를 조회
        // Quiz quiz = quizService.getQuizById(id);

        request.setAttribute("id", id);
        request.setAttribute("count", count);
        return "/views/quizPlay";
    }
}
