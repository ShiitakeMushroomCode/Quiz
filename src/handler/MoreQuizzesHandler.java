package handler;

import bean.DetailData;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class DetailHandler implements Handler {
    @Override
    public String handleRequest(HttpServletRequest request, HttpServletResponse response) {
        String id = request.getParameter("id");
        if (id.isEmpty()) {
            return "notFound"; // id가 없는 경우 처리
        }
        // DetailData Bean 생성 및 데이터 설정
        DetailData detailData = new DetailData();
        detailData.setId(id);
        detailData.setN1("10");
        detailData.setN2("20");
        detailData.setN3("30");
        detailData.setN4("50");
        detailData.setExp("이 항목의 설명입니다.");

        // Bean을 request에 설정
        request.setAttribute("detailData", detailData);
        return "detail"; // 정상적으로 처리된 경우
    }
}

