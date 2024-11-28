package handler;

import dao.CommentDAO;
import model.Comment;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class AddCommentHandler implements Handler {
    @Override
    public String handleRequest(HttpServletRequest request, HttpServletResponse response) {
        try {
            request.setCharacterEncoding("UTF-8");

            int quizId = Integer.parseInt(request.getParameter("quizId"));
            String writer = request.getParameter("writer");
            String commentText = request.getParameter("comment");
            String password = request.getParameter("password");

            // 댓글 객체 생성 및 값 설정
            Comment comment = new Comment();
            comment.setQuizId(quizId);
            comment.setWriter(writer);
            comment.setComment(commentText);
            comment.setPassword(password);

            // DAO를 통해 댓글 추가
            CommentDAO commentDAO = new CommentDAO();
            boolean isSuccess = commentDAO.addComment(comment);

            if (isSuccess) {
                // 댓글 추가 성공 시, 원래 페이지로 리다이렉트
                response.sendRedirect("detail?id=" + quizId);
                return null;
            } else {
                request.setAttribute("errorMessage", "댓글 작성에 실패했습니다.");
                return "/views/error";
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "댓글 작성 중 오류가 발생했습니다.");
            return "/views/error";
        }
    }
}
