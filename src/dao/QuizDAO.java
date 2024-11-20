package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import db.DBConnection;
import model.Quiz;

public class QuizDAO {
    private Connection conn;

    public QuizDAO() {
        conn = DBConnection.getConnection();
    }

    public List<Quiz> getAllQuizzes() {
        List<Quiz> quizzes = new ArrayList<>();
        String query = "SELECT * FROM quiz";

        try (PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Quiz quiz = new Quiz();
                quiz.setQuizId(rs.getInt("quiz_id"));
                quiz.setQuizName(rs.getString("quiz_name"));
                quiz.setOwnerId(rs.getInt("owner_id"));
                quiz.setExp(rs.getString("exp"));
                quiz.setType(rs.getString("type"));
                quiz.setRelease(rs.getString("release"));
                quiz.setCreatedAt(rs.getTimestamp("created_at"));
                quiz.setUpdatedAt(rs.getTimestamp("updated_at"));
                quizzes.add(quiz);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return quizzes;
    }
}
