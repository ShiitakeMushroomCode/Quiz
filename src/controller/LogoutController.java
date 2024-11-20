package controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/logout")
public class LogoutController extends HttpServlet {
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws IOException {
		// 세션 무효화
		HttpSession session = request.getSession(false);
		if (session != null) {
			session.invalidate();
		}

		// 메인 페이지로 리다이렉트
		response.sendRedirect(request.getContextPath() + "/views/");
	}
}
