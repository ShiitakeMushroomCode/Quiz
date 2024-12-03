package dao;

import db.DBConnection;
import model.PlayData;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class PlayDataDAO {
    public boolean savePlayData(PlayData playData) {
        String query = "INSERT INTO play_data (quiz_id, correct_percent) VALUES (?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, playData.getQuizId());
            stmt.setFloat(2, playData.getCorrectPercent());

            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0; // 저장 성공 시 true 반환
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    public List<Float> getAllCorrectRatios(int quizId) {
        String query = "SELECT correct_percent FROM play_data WHERE quiz_id = ?";
        List<Float> ratios = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, quizId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    ratios.add(rs.getFloat("correct_percent"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return ratios;
    }
}
