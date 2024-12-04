package handler;

import javax.servlet.http.*;
import java.io.IOException;

public class MyQuizHandler implements Handler {
    @Override
    public String handleRequest(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            // 비로그인 상태라면 로그인 페이지로 리다이렉트
            response.sendRedirect(request.getContextPath() + "/views/index");
            return null;
        }

        // 로그인 상태라면 내 퀴즈 페이지로 이동
        return "/views/myquiz";
    }
}
