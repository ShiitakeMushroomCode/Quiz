package handler;

import dao.CommentDAO;
import model.Comment;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;

public class MoreCommentsHandler implements Handler {
    @Override
    public String handleRequest(HttpServletRequest request, HttpServletResponse response) {
        try {
            int offset = Integer.parseInt(request.getParameter("offset"));
            int limit = Integer.parseInt(request.getParameter("limit"));
            int quizId = Integer.parseInt(request.getParameter("quizId"));

            CommentDAO commentDAO = new CommentDAO();
            List<Comment> comments = commentDAO.getCommentsByQuizId(quizId, offset, limit);

            if (comments.isEmpty()) {
                response.setStatus(HttpServletResponse.SC_NO_CONTENT);
                return null;
            }

            request.setAttribute("comments", comments);
            return "/components/loadMoreComments";
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "댓글을 로드하는 중 오류가 발생했습니다.");
            return "/views/error";
        }
    }
}
