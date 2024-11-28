package handler;

import dao.CommentDAO;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class DeleteCommentHandler implements Handler {
    @Override
    public String handleRequest(HttpServletRequest request, HttpServletResponse response) {
        try {
            long commentId = Long.parseLong(request.getParameter("commentId")); // comment_id를 Long으로 파싱
            String password = request.getParameter("password");

            CommentDAO commentDAO = new CommentDAO();
            boolean isDeleted = commentDAO.deleteComment(commentId, password);

            response.setContentType("text/plain");
            response.setCharacterEncoding("UTF-8");
            if (isDeleted) {
                response.getWriter().write("success");
            } else {
                response.getWriter().write("failure");
            }
            return null;
        } catch (Exception e) {
            e.printStackTrace();
            try {
                response.getWriter().write("error");
            } catch (Exception ex) {
                ex.printStackTrace();
            }
            return null;
        }
    }
}
