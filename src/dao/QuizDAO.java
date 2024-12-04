package dao;

import model.Quiz;
import db.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class QuizDAO {

    public Quiz getQuizById(int id) {
        Quiz quiz = null;
        String query = "SELECT * FROM quiz WHERE quiz_id = ? and `release` = 'Y'";

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
        String query = "SELECT * FROM quiz WHERE `release` = 'Y' LIMIT ? OFFSET ?";

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

    public List<Quiz> getQuizzesByOffsetAndSearch(int offset, int size, String searchValue, String filter) {
        List<Quiz> quizzes = new ArrayList<>();

        StringBuilder queryBuilder = new StringBuilder("SELECT * FROM quiz WHERE `release` = 'Y'");
        List<Object> params = new ArrayList<>();

        if (searchValue != null && !searchValue.isEmpty()) {
            queryBuilder.append(" AND quiz_name LIKE ?");
            params.add("%" + searchValue + "%");
        }

        if ("recent".equalsIgnoreCase(filter)) {
            queryBuilder.append(" ORDER BY created_at DESC");
        } else if ("popular".equalsIgnoreCase(filter)) {
            queryBuilder.append(" ORDER BY (SELECT COUNT(*) FROM play_data WHERE play_data.quiz_id = quiz.quiz_id) DESC, created_at ASC");
        }

        queryBuilder.append(" LIMIT ? OFFSET ?");
        params.add(size);
        params.add(offset);

        String query = queryBuilder.toString();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            for (int i = 0; i < params.size(); i++) {
                Object param = params.get(i);
                if (param instanceof Integer) {
                    stmt.setInt(i + 1, (Integer) param);
                } else if (param instanceof String) {
                    stmt.setString(i + 1, (String) param);
                }
            }

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

    public int getTotalQuizCount(String searchValue) {
        int totalQuizzes = 0;
        StringBuilder queryBuilder = new StringBuilder("SELECT COUNT(*) FROM quiz WHERE `release` = 'Y'");
        List<Object> params = new ArrayList<>();

        if (searchValue != null && !searchValue.isEmpty()) {
            queryBuilder.append(" AND quiz_name LIKE ?");
            params.add("%" + searchValue + "%");
        }

        String query = queryBuilder.toString();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            for (int i = 0; i < params.size(); i++) {
                stmt.setString(i + 1, (String) params.get(i));
            }

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    totalQuizzes = rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return totalQuizzes;
    }
    public List<Quiz> getQuizzesByOwnerIdAndOffset(int ownerId, int offset, int size, String searchValue, String filter) {
        List<Quiz> quizzes = new ArrayList<>();

        StringBuilder queryBuilder = new StringBuilder("SELECT * FROM quiz WHERE owner_id = ? AND `release` = 'Y'");
        List<Object> params = new ArrayList<>();
        params.add(ownerId);

        if (searchValue != null && !searchValue.isEmpty()) {
            queryBuilder.append(" AND quiz_name LIKE ?");
            params.add("%" + searchValue + "%");
        }

        if ("recent".equalsIgnoreCase(filter)) {
            queryBuilder.append(" ORDER BY created_at DESC");
        } else if ("popular".equalsIgnoreCase(filter)) {
            queryBuilder.append(" ORDER BY (SELECT COUNT(*) FROM play_data WHERE play_data.quiz_id = quiz.quiz_id) DESC, created_at ASC");
        }

        queryBuilder.append(" LIMIT ? OFFSET ?");
        params.add(size);
        params.add(offset);

        String query = queryBuilder.toString();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            int index = 1;
            stmt.setInt(index++, ownerId);
            for (Object param : params.subList(1, params.size())) {
                if (param instanceof Integer) {
                    stmt.setInt(index++, (Integer) param);
                } else if (param instanceof String) {
                    stmt.setString(index++, (String) param);
                }
            }

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
    public int getTotalQuizCountByOwnerId(int ownerId, String searchValue) {
        int totalQuizzes = 0;
        StringBuilder queryBuilder = new StringBuilder("SELECT COUNT(*) FROM quiz WHERE owner_id = ? AND `release` = 'Y'");
        List<Object> params = new ArrayList<>();
        params.add(ownerId);

        if (searchValue != null && !searchValue.isEmpty()) {
            queryBuilder.append(" AND quiz_name LIKE ?");
            params.add("%" + searchValue + "%");
        }

        String query = queryBuilder.toString();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            int index = 1;
            stmt.setInt(index++, ownerId);
            for (Object param : params.subList(1, params.size())) {
                stmt.setString(index++, (String) param);
            }

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    totalQuizzes = rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return totalQuizzes;
    }
}
