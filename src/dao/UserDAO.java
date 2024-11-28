package dao;

import model.User;
import db.DBConnection;

import java.sql.*;

public class UserDAO {

    public User findByKakaoId(long kakaoId) {
        String query = "SELECT * FROM users WHERE kakao_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setLong(1, kakaoId);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    User user = new User();
                    user.setId(rs.getInt("id"));
                    user.setKakaoId(rs.getLong("kakao_id"));
                    user.setNickname(rs.getString("nickname"));
                    user.setUpdatedAt(rs.getTimestamp("updated_at"));
                    return user;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public void save(User user) {
        String query = "INSERT INTO users (id, kakao_id, nickname, updated_at) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setInt(1, user.getId());
            pstmt.setLong(2, user.getKakaoId());
            pstmt.setString(3, user.getNickname());
            pstmt.setTimestamp(4, user.getUpdatedAt());
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void update(User user) {
        String query = "UPDATE users SET nickname = ?, updated_at = ? WHERE kakao_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setString(1, user.getNickname());
            pstmt.setTimestamp(2, user.getUpdatedAt());
            pstmt.setLong(3, user.getKakaoId());
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void deleteByKakaoId(long kakaoId) {
        String query = "DELETE FROM users WHERE kakao_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setLong(1, kakaoId);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
