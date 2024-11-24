package model;

import java.sql.Timestamp;

public class Comment {
    private Timestamp commentId;
    private int quizId;
    private String writer;
    private String comment;
    private String password;

    public Timestamp getCommentId() {
        return commentId;
    }

    public void setCommentId(Timestamp commentId) {
        this.commentId = commentId;
    }

    public int getQuizId() {
        return quizId;
    }

    public void setQuizId(int quizId) {
        this.quizId = quizId;
    }

    public String getWriter() {
        return writer;
    }

    public void setWriter(String writer) {
        this.writer = writer;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public String getPassword() { return password; }

    public void setPassword(String password) { this.password = password; }
}
