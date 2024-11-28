package model;

import java.sql.Timestamp;

public class Quiz {
    private int quizId;
    private String quizName;
    private int ownerId;
    private String exp;
    private String type;
    private String release;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    private short n1;
    private short n2;
    private short n3;
    private short n4;

    public int getQuizId() {
        return quizId;
    }

    public void setQuizId(int quizId) {
        this.quizId = quizId;
    }

    public String getQuizName() {
        return quizName;
    }

    public void setQuizName(String quizName) {
        this.quizName = quizName;
    }

    public int getOwnerId() {
        return ownerId;
    }

    public void setOwnerId(int ownerId) {
        this.ownerId = ownerId;
    }

    public String getExp() {
        return exp;
    }

    public void setExp(String exp) {
        this.exp = exp;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getRelease() {
        return release;
    }

    public void setRelease(String release) {
        this.release = release;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

    public short getN1() {
        return n1;
    }

    public void setN1(short n1) {
        this.n1 = n1;
    }

    public short getN2() {
        return n2;
    }

    public void setN2(short n2) {
        this.n2 = n2;
    }

    public short getN3() {
        return n3;
    }

    public void setN3(short n3) {
        this.n3 = n3;
    }

    public short getN4() {
        return n4;
    }

    public void setN4(short n4) {
        this.n4 = n4;
    }

}
