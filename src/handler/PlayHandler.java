package handler;

import bean.PlayData;
import com.google.gson.Gson;
import dao.DetailQuizDAO;
import type.PlayDataObj;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class PlayHandler implements Handler {

    private final Gson gson = new Gson();

    @Override
    public String handleRequest(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession();

        // AJAX 요청 처리
        String action = request.getParameter("action");
        if ("getQuestion".equals(action)) {
            return handleGetQuestion(request, response, session);
        } else if ("submitAnswer".equals(action)) {
            return handleSubmitAnswer(request, response, session);
        }

        // 기본 초기화
        return initializeQuiz(request, session);
    }

    private String handleGetQuestion(HttpServletRequest request, HttpServletResponse response, HttpSession session) throws IOException {
        PlayData playData = (PlayData) session.getAttribute("playData");
        Integer currentIndex = (Integer) session.getAttribute("currentIndex");

        Map<String, Object> responseData = new HashMap<>();
        if (playData == null || currentIndex == null || currentIndex >= playData.getItems().length) {
            responseData.put("status", "end");
        } else {
            PlayDataObj currentQuestion = playData.getItems()[currentIndex];
            responseData.put("status", "ok");
            responseData.put("detailId", currentQuestion.getDetailId());
            responseData.put("imageId", currentQuestion.getImageId());
        }

        sendJsonResponse(response, responseData);
        return null;
    }

    private String handleSubmitAnswer(HttpServletRequest request, HttpServletResponse response, HttpSession session) throws IOException {
        PlayData playData = (PlayData) session.getAttribute("playData");
        Integer currentIndex = (Integer) session.getAttribute("currentIndex");
        Integer score = (Integer) session.getAttribute("score");

        if (playData == null || currentIndex == null || score == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "퀴즈 상태를 찾을 수 없습니다.");
            return null;
        }

        PlayDataObj currentQuestion = playData.getItems()[currentIndex];
        String userAnswer = request.getParameter("answer");
        boolean isCorrect = currentQuestion.isAnswerCorrect(userAnswer);

        if (isCorrect) {
            session.setAttribute("score", score + 1);
        }

        session.setAttribute("currentIndex", currentIndex + 1);

        Map<String, Object> responseData = new HashMap<>();
        responseData.put("isCorrect", isCorrect);
        responseData.put("correctAnswer", currentQuestion.getFirstCorrectAnswer()); // 정답 목록 중 첫 번째 정답 반환
        responseData.put("detailId", currentQuestion.getDetailId());
        responseData.put("imageId", currentQuestion.getImageId());

        sendJsonResponse(response, responseData);
        return null;
    }


    private String initializeQuiz(HttpServletRequest request, HttpSession session) {
        String idParam = request.getParameter("id");
        String countParam = request.getParameter("count");

        if (idParam == null || countParam == null) {
            request.setAttribute("error", "퀴즈 데이터를 찾을 수 없습니다.");
            return "/views/error";
        }

        int quizId = Integer.parseInt(idParam);
        int count = Integer.parseInt(countParam);

        // 퀴즈 데이터 초기화
        PlayData playData = new PlayData();
        playData.setQuizId(quizId);
        playData.setCount(count);

        // DAO에서 데이터 가져오기
        List<PlayDataObj> details = new DetailQuizDAO().getDetailsByQuizId(quizId, count);
        playData.setItems(details.toArray(new PlayDataObj[0]));

        // 세션에 초기화된 데이터 설정
        session.setAttribute("playData", playData);
        session.setAttribute("currentIndex", 0);
        session.setAttribute("score", 0);

        // quizId 전달
        request.setAttribute("quizId", quizId);

        request.setAttribute("currentQuestion", playData.getItems()[0]);
        return "/views/quizPlay";
    }

    private void sendJsonResponse(HttpServletResponse response, Object data) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(gson.toJson(data));
    }
}
