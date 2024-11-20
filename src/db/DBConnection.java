package db;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
	private static Connection conn = null;

	// 데이터베이스 연결 메서드
	public static Connection getConnection() {
		if (conn == null) {
			try {
				Class.forName("com.mysql.cj.jdbc.Driver"); // MySQL JDBC 드라이버
				String url = "jdbc:mysql://localhost:3306/jsp_project"; // 데이터베이스 URL
				String user = "root"; // MySQL 사용자명
				String password = "A@a01075396929"; // MySQL 비밀번호

				conn = DriverManager.getConnection(url, user, password);
			} catch (ClassNotFoundException | SQLException e) {
				e.printStackTrace();
			}
		}
		return conn;
	}

	// 연결 종료 메서드
	public static void closeConnection() {
		if (conn != null) {
			try {
				conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
	}
}