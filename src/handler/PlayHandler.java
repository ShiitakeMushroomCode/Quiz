package handler;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class DetailHandler implements Handler {
    @Override
    public String handleRequest(HttpServletRequest request, HttpServletResponse response) {
        // 요청에 포함된 id를 가져오기
        String id = request.getParameter("id");

        // 경로에서 id 추출 (예: "/views/detail/123" 형태)
        if (id == null || id.isEmpty()) {
            String uri = request.getRequestURI();
            String contextPath = request.getContextPath();
            String path = uri.substring(contextPath.length());
            if (path.startsWith("/views/detail/")) {
                id = path.substring("/views/detail/".length());
            }
        }

        // 예: 데이터베이스에서 id에 해당하는 데이터를 조회
        // Quiz quiz = quizService.getQuizById(id);
        // request.setAttribute("quiz", quiz);

        request.setAttribute("message", "퀴즈 ID: " + id);
        return "detail";
    }
}
