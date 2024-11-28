package dao;

import db.DBConnection;
import model.Comment;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CommentDAO {

    // 댓글 추가 메서드
    public boolean addComment(Comment comment) {
        String sql = "INSERT INTO comment (quiz_id, writer, comment, password) VALUES (?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, comment.getQuizId());
            stmt.setString(2, comment.getWriter());
            stmt.setString(3, comment.getComment());
            stmt.setString(4, comment.getPassword());

            int rowsInserted = stmt.executeUpdate();
            return rowsInserted > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 댓글 가져오기 메서드
    public List<Comment> getCommentsByQuizId(int quizId, int offset, int limit) {
        List<Comment> comments = new ArrayList<>();
        String sql = "SELECT *, DATE_ADD(created_at, INTERVAL 9 HOUR) AS created_at FROM comment WHERE quiz_id = ? ORDER BY created_at DESC LIMIT ? OFFSET ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, quizId);
            stmt.setInt(2, limit);
            stmt.setInt(3, offset);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Comment comment = new Comment();
                    comment.setCommentId(rs.getLong("comment_id"));
                    comment.setQuizId(rs.getInt("quiz_id"));
                    comment.setWriter(rs.getString("writer"));
                    comment.setComment(rs.getString("comment"));
                    comment.setPassword(rs.getString("password"));
                    comment.setCreatedAt(rs.getTimestamp("created_at"));
                    comments.add(comment);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return comments;
    }

    // 댓글 삭제 메서드
    public boolean deleteComment(long commentId, String password) {
        String sql = "DELETE FROM comment WHERE comment_id = ? AND password = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, commentId);
            stmt.setString(2, password);

            int rowsDeleted = stmt.executeUpdate();
            return rowsDeleted > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
