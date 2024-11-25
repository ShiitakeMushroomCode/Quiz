package dao;

import model.Quiz;
import db.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class QuizDAO {
    private Connection conn;

    public QuizDAO() {
        conn = DBConnection.getConnection();
    }

    public List<Quiz> getQuizzesByOffset(int offset, int size) {
        List<Quiz> quizzes = new ArrayList<>();
        String query = "SELECT * FROM quiz LIMIT ? OFFSET ?";

        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, size);
            stmt.setInt(2, offset);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Quiz quiz = new Quiz();
                    quiz.setQuizId(rs.getInt("quiz_id"));
                    quiz.setQuizName(rs.getString("quiz_name"));
                    quiz.setExp(rs.getString("exp"));
                    quiz.setType(rs.getString("type"));
                    quiz.setOwnerId(rs.getInt("owner_id"));
                    quiz.setRelease(rs.getString("release"));
                    quiz.setCreatedAt(rs.getTimestamp("created_at"));
                    quiz.setUpdatedAt(rs.getTimestamp("updated_at"));
                    quizzes.add(quiz);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return quizzes;
    }
}
