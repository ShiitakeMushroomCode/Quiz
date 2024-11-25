package dao;

import java.sql.Connection;

import db.DBConnection;
import model.Comment;

public class CommentDAO {
    private Connection conn;

    public CommentDAO() {
        conn = DBConnection.getConnection();
    }

}
