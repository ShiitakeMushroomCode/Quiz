package controller;

import handler.Handler;

import javax.servlet.*;
import javax.servlet.annotation.WebInitParam;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.*;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

@WebServlet(urlPatterns = "/views/*", // 모든 요청 처리
		initParams = {
				@WebInitParam(name = "handlerConfig", value = "/WEB-INF/handler-mapping.properties") }, loadOnStartup = 1)
public class FrontController extends HttpServlet {
	private Map<String, Handler> handlerMap = new HashMap<>();

	@Override
	public void init(ServletConfig config) throws ServletException {
		// 초기화 매개변수에서 설정 파일 경로를 가져옴
		String configFile = config.getInitParameter("handlerConfig");
		Properties props = new Properties();

		// 설정 파일을 읽어 핸들러 매핑 초기화
		try (InputStream input = config.getServletContext().getResourceAsStream(configFile)) {
			if (input == null) {
				throw new ServletException("핸들러 설정 파일을 찾을 수 없습니다: " + configFile);
			}

			props.load(input);

			for (String key : props.stringPropertyNames()) {
				String handlerClassName = props.getProperty(key);
				try {
					Class<?> handlerClass = Class.forName(handlerClassName);
					Handler handlerInstance = (Handler) handlerClass.getDeclaredConstructor().newInstance();
					handlerMap.put(key, handlerInstance);
				} catch (ClassNotFoundException e) {
					log("핸들러 클래스를 찾을 수 없습니다: " + handlerClassName, e);
				} catch (Exception e) {
					log("핸들러 초기화 실패: " + handlerClassName, e);
				}
			}
		} catch (IOException e) {
			throw new ServletException("핸들러 매핑 파일 로드 실패: " + configFile, e);
		}

		// Null 핸들러가 설정되지 않은 경우 기본 NullHandler 추가
		if (!handlerMap.containsKey("null")) {
			log("null 핸들러가 설정되지 않았습니다. 기본 NullHandler를 추가합니다.");
			try {
				handlerMap.put("null",
						(Handler) Class.forName("handler.NullHandler").getDeclaredConstructor().newInstance());
			} catch (Exception e) {
				throw new ServletException("기본 NullHandler 추가 실패", e);
			}
		}
	}

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		processRequest(request, response);
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		processRequest(request, response);
	}

	private void processRequest(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String uri = request.getRequestURI();
		String contextPath = request.getContextPath();
		String path = uri.substring(contextPath.length());
		
		// 기본 페이지
		if (path.equals("/views/") || path.isEmpty()) {
			path = "index";
		}

		// 디테일 페이지
		if (path.startsWith("/views/detail/")) {
			int baseLength = "/views/detail/".length();
			if (path.length() > baseLength) {
				String id = path.substring(baseLength);
				request.setAttribute("id", id);
			} else {
				request.setAttribute("id", null);
			}
			path = "detail";
		}

		// 나머지 페이지
		if (path.startsWith("/views/")) {
			path = path.substring("/views/".length());
		}

		Handler handler = handlerMap.getOrDefault(path, handlerMap.get("null"));
		if (handler == null) {
			if (!response.isCommitted()) {
				response.sendError(HttpServletResponse.SC_NOT_FOUND, "핸들러를 찾을 수 없습니다: " + path);
			}
			return;
		}

		String viewName = handler.handleRequest(request, response);

		// 응답이 이미 커밋된 경우 추가 처리하지 않음
		if (response.isCommitted() || viewName == null || viewName.isEmpty()) {
			return;
		}

		String view = "/WEB-INF/views/" + viewName + ".jsp";
		RequestDispatcher dispatcher = request.getRequestDispatcher(view);
		dispatcher.forward(request, response);
	}

}
