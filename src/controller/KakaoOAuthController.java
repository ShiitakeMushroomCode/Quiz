package controller;

import dao.UserDAO;
import model.User;
import util.HttpUtil;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Timestamp;

@WebServlet("/oauth/kakao")
public class KakaoOAuthController extends HttpServlet {
	private static final String CLIENT_ID = "5a505e392e1bb5e3f7044bf3390df0b5";
	private static final String REDIRECT_URI = "http://localhost:8383/Quiz_war_exploded/oauth/kakao";

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws IOException {
		String code = request.getParameter("code");

		// 로그인 버튼 클릭 시 카카오 인증 페이지로 리다이렉트
		if (code == null) {
			response.sendRedirect("https://kauth.kakao.com/oauth/authorize?response_type=code&client_id=" + CLIENT_ID
					+ "&redirect_uri=" + REDIRECT_URI);
			return;
		}

		try {
			// 1. 액세스 토큰 요청
			String tokenResponse = HttpUtil.post("https://kauth.kakao.com/oauth/token",
					"grant_type=authorization_code&client_id=" + CLIENT_ID + "&redirect_uri=" + REDIRECT_URI + "&code="
							+ code);
			JsonObject tokenJson = JsonParser.parseString(tokenResponse).getAsJsonObject();
			String accessToken = tokenJson.get("access_token").getAsString();

			// 2. 사용자 정보 요청
			String userResponse = HttpUtil.get("https://kapi.kakao.com/v2/user/me", "Bearer " + accessToken);
			JsonObject userJson = JsonParser.parseString(userResponse).getAsJsonObject();
			long kakaoId = userJson.get("id").getAsLong();
			String nickname = userJson.get("properties").getAsJsonObject().get("nickname").getAsString();

			// 3. 사용자 정보 저장 또는 업데이트
			UserDAO userDao = new UserDAO();
			User user = userDao.findByKakaoId(kakaoId);
			Timestamp now = new Timestamp(System.currentTimeMillis());
			if (user == null) {
				user = new User();
				user.setKakaoId(kakaoId);
				user.setNickname(nickname);
				user.setUpdatedAt(now);
				userDao.save(user);
			} else {
				user.setNickname(nickname);
				user.setUpdatedAt(now);
				userDao.update(user);
			}

			// 4. 세션에 사용자 정보 저장
			HttpSession session = request.getSession();
			session.setAttribute("user", user);

			// 5. 성공 후 리다이렉트
			response.sendRedirect(request.getContextPath() + "/views/");
		} catch (Exception e) {
			e.printStackTrace();
			response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "OAuth 처리 중 오류가 발생했습니다.");
		}
	}
}
