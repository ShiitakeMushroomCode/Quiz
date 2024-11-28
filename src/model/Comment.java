package model;

import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.Calendar;

public class Comment {
    private Long commentId;        // AUTO_INCREMENT
    private int quizId;            // Foreign Key
    private String writer;         // 작성자
    private String comment;        // 댓글 내용
    private String password;       // 비밀번호
    private Timestamp createdAt;   // 작성 시간

    // Getter and Setter for commentId
    public Long getCommentId() {
        return commentId;
    }

    public void setCommentId(Long commentId) {
        this.commentId = commentId;
    }

    // Getter and Setter for quizId
    public int getQuizId() {
        return quizId;
    }

    public void setQuizId(int quizId) {
        this.quizId = quizId;
    }

    // Getter and Setter for writer
    public String getWriter() {
        return writer;
    }

    public void setWriter(String writer) {
        this.writer = writer;
    }

    // Getter and Setter for comment
    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    // Getter and Setter for password
    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    // Getter and Setter for createdAt
    public String getCreatedAt() {
        if (createdAt == null) {
            return null;
        }
        // 9시간 추가
        Calendar cal = Calendar.getInstance();
        cal.setTimeInMillis(createdAt.getTime());

        // 포맷팅
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        return sdf.format(cal.getTime());
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}
