package handler;

import bean.PlayData;
import com.google.gson.Gson;
import dao.DetailQuizDAO;
import dao.PlayDataDAO;
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

        String action = request.getParameter("action");
        if ("getQuestion".equals(action)) {
            return handleGetQuestion(request, response, session);
        } else if ("submitAnswer".equals(action)) {
            return handleSubmitAnswer(request, response, session);
        }

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
            score += 1;
            session.setAttribute("score", score);
        }

        currentIndex++;
        session.setAttribute("currentIndex", currentIndex);

        Map<String, Object> responseData = new HashMap<>();
        responseData.put("isCorrect", isCorrect);
        responseData.put("correctAnswer", currentQuestion.getFirstCorrectAnswer());
        responseData.put("detailId", currentQuestion.getDetailId());
        responseData.put("imageId", currentQuestion.getImageId());

        if (currentIndex >= playData.getItems().length) {
            int totalQuestions = playData.getItems().length;
            int correctAnswers = score; // 현재 점수가 정답 개수
            float correctRatio = ((float) correctAnswers / totalQuestions) * 100;
            correctRatio = Math.round(correctRatio * 100.0f) / 100.0f;

            // PlayData 저장
            model.PlayData playDataRecord = new model.PlayData();
            playDataRecord.setQuizId(playData.getQuizId());
            playDataRecord.setCorrectPercent(correctRatio);

            PlayDataDAO dao = new PlayDataDAO();
            boolean isSaved = dao.savePlayData(playDataRecord);

            if (!isSaved) {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "퀴즈 데이터를 저장하는 도중 오류가 발생했습니다.");
                return null;
            }

            // 상위 퍼센트 계산
            List<Float> allRatios = dao.getAllCorrectRatios(playData.getQuizId());
            allRatios.add(correctRatio);
            allRatios.sort(Float::compareTo);

            int totalPlayers = allRatios.size();
            int betterScores = 0;

            for (Float ratio : allRatios) {
                if (correctRatio < ratio) {
                    betterScores++;
                }
            }

            int percentile;
            if (correctAnswers == totalQuestions) {
                percentile = 1; // 정답 개수와 문제 개수가 같으면 상위 1%
            } else {
                percentile = (int) Math.ceil(((float) betterScores / totalPlayers) * 100); // 소수점 없이 올림
            }

            // 세션에 결과 저장
            session.setAttribute(
                    "quizResult", Map.of(
                    "correctRatio", Math.round(correctRatio), // 소수점 없이 정수로 저장
                    "percentile", percentile,
                    "totalPlayers", totalPlayers,
                    "quizId", playData.getQuizId(),
                    "totalQuestions", totalQuestions,
                    "correctAnswers", correctAnswers
            ));

        responseData.put("status", "end");
        } else {
            responseData.put("status", "continue");
        }



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

        PlayData playData = new PlayData();
        playData.setQuizId(quizId);
        playData.setCount(count);

        List<PlayDataObj> details = new DetailQuizDAO().getDetailsByQuizId(quizId, count);
        playData.setItems(details.toArray(new PlayDataObj[0]));

        session.setAttribute("playData", playData);
        session.setAttribute("currentIndex", 0);
        session.setAttribute("score", 0);
        session.setAttribute("quizId", quizId);

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
