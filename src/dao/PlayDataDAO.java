package dao;

import java.sql.Connection;

import db.DBConnection;
import model.PlayData;

public class PlayDataDAO {
    private Connection conn;

    public PlayDataDAO() {
        conn = DBConnection.getConnection();
    }
}
