package db;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

import java.sql.Connection;
import java.sql.SQLException;

public class DBConnection {
    private static HikariDataSource dataSource;

    static {
        try {
            HikariConfig config = new HikariConfig();
            config.setJdbcUrl("jdbc:mysql://localhost:3306/jsp_project?serverTimezone=Asia/Seoul?useSSL=false&serverTimezone=UTC");
            config.setUsername("root");
            config.setPassword("A@a01075396929");
            config.setDriverClassName("com.mysql.cj.jdbc.Driver");

            // HikariCP 설정
            config.setMaximumPoolSize(10);
            config.setMinimumIdle(5);
            config.setIdleTimeout(300000); // 5분
            config.setMaxLifetime(1800000); // 30분
            config.setConnectionTimeout(30000); // 30초

            dataSource = new HikariDataSource(config);
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("HikariCP DataSource initialization failed.");
        }
    }

    // Connection을 반환하는 메서드
    public static Connection getConnection() throws SQLException {
        return dataSource.getConnection();
    }

    // DataSource 종료 메서드
    public static void closeDataSource() {
        if (dataSource != null && !dataSource.isClosed()) {
            dataSource.close();
        }
    }
}
