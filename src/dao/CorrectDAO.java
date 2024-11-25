package dao;

import java.sql.Connection;

import db.DBConnection;
import model.Correct;

public class CorrectDAO {
    private Connection conn;

    public CorrectDAO() {
        conn = DBConnection.getConnection();
    }

}
