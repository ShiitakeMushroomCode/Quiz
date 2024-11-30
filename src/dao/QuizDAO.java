package dao;

import model.Quiz;
import db.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class QuizDAO {

    public Quiz getQuizById(int id) {
        Quiz quiz = null;
        String query = "SELECT * FROM quiz WHERE quiz_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, id);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    quiz = new Quiz();
                    quiz.setQuizId(rs.getInt("quiz_id"));
                    quiz.setQuizName(rs.getString("quiz_name"));
                    quiz.setExp(rs.getString("exp"));
                    quiz.setOwnerId(rs.getInt("owner_id"));
                    quiz.setRelease(rs.getString("release"));
                    quiz.setCreatedAt(rs.getTimestamp("created_at"));
                    quiz.setUpdatedAt(rs.getTimestamp("updated_at"));
                    quiz.setN1(rs.getShort("n1"));
                    quiz.setN2(rs.getShort("n2"));
                    quiz.setN3(rs.getShort("n3"));
                    quiz.setN4(rs.getShort("n4"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return quiz;
    }

    public List<Quiz> getQuizzesByOffset(int offset, int size) {
        List<Quiz> quizzes = new ArrayList<>();
        String query = "SELECT * FROM quiz LIMIT ? OFFSET ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, size);
            stmt.setInt(2, offset);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Quiz quiz = new Quiz();
                    quiz.setQuizId(rs.getInt("quiz_id"));
                    quiz.setQuizName(rs.getString("quiz_name"));
                    quiz.setExp(rs.getString("exp"));
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

    public int getTotalQuizCount() {
        int totalQuizzes = 0;
        String query = "SELECT COUNT(*) FROM quiz";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                totalQuizzes = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return totalQuizzes;
    }
}
