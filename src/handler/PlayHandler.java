package handler;

import bean.PlayData;
import dao.DetailQuizDAO;
import type.PlayDataObj;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;

public class PlayHandler implements Handler {

    @Override
    public String handleRequest(HttpServletRequest request, HttpServletResponse response) {
        // 요청 파라미터 가져오기
        String idParam = request.getParameter("id");
        String countParam = request.getParameter("count");

        int quizId = Integer.parseInt(idParam);
        int count = Integer.parseInt(countParam);

        // DAO를 사용하여 데이터 가져오기
        DetailQuizDAO detailQuizDAO = new DetailQuizDAO();
        List<PlayDataObj> details = detailQuizDAO.getDetailsByQuizId(quizId, count);

        // PlayData 자바빈 객체 생성 및 데이터 설정
        PlayData playData = new PlayData();
        playData.setQuizId(quizId);
        playData.setCount(count);
        playData.setItems(details.toArray(new PlayDataObj[0]));

        // 요청에 자바빈 객체 설정
        request.setAttribute("playData", playData);

        // JSP로 이동
        return "/views/quizPlay";
    }
}
