package dao;

import db.DBConnection;
import type.PlayDataObj;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DetailQuizDAO {

    public List<PlayDataObj> getDetailsByQuizId(int quizId, int limit) {
        List<PlayDataObj> details = new ArrayList<>();

        // LIMIT 조건을 동적으로 설정
        String limitClause = (limit > 0) ? " LIMIT ?" : "";

        String query = """
        SELECT dq.detail_id AS detailId, 
               ROW_NUMBER() OVER (ORDER BY dq.detail_id) AS imageId, 
               GROUP_CONCAT(c.correct SEPARATOR ',') AS correctAnswers
        FROM detail_quiz dq
        LEFT JOIN correct c ON dq.detail_id = c.detail_id
        WHERE dq.quiz_id = ?
        GROUP BY dq.detail_id
        ORDER BY RAND()
        """ + limitClause;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, quizId);

            if (limit > 0) {
                stmt.setInt(2, limit); // LIMIT 값 설정
            }

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    PlayDataObj item = new PlayDataObj();
                    item.setDetailId(rs.getInt("detailId"));
                    item.setImageId(rs.getInt("imageId"));

                    // 정답 세트 설정 (null 체크 추가)
                    String correctAnswers = rs.getString("correctAnswers");
                    if (correctAnswers != null) {
                        String[] answersArray = correctAnswers.split(",");
                        item.setCorrectAnswer(answersArray);
                    } else {
                        item.setCorrectAnswer(new String[0]); // 빈 배열로 설정
                    }

                    details.add(item);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return details;
    }

    public List<PlayDataObj> getDetailsByQuizIdOrdered(int quizId) {
        List<PlayDataObj> details = new ArrayList<>();

        String query = """
    SELECT dq.detail_id AS detailId, 
           ROW_NUMBER() OVER (ORDER BY dq.detail_id, c.correct_id) AS imageId, 
           GROUP_CONCAT(c.correct SEPARATOR ',') AS correctAnswers
    FROM detail_quiz dq
    LEFT JOIN correct c ON dq.detail_id = c.detail_id
    WHERE dq.quiz_id = ?
    GROUP BY dq.detail_id
    ORDER BY dq.detail_id, imageId
    """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, quizId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    PlayDataObj item = new PlayDataObj();
                    item.setDetailId(rs.getInt("detailId"));
                    item.setImageId(rs.getInt("imageId"));

                    // 정답 세트 설정 (null 체크 추가)
                    String correctAnswers = rs.getString("correctAnswers");
                    if (correctAnswers != null) {
                        String[] answersArray = correctAnswers.split(",");
                        item.setCorrectAnswer(answersArray);
                    } else {
                        item.setCorrectAnswer(new String[0]); // 빈 배열로 설정
                    }

                    details.add(item);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return details;
    }


}
