package model;

import java.sql.Timestamp;
public class PlayData {
    private Timestamp playId;
    private int quizId;
	private float correctPercent;

	public Timestamp getPlayId() {
		return playId;
	}

	public void setPlayId(Timestamp playId) {
		this.playId = playId;
	}

	public int getQuizId() {
		return quizId;
	}

	public void setQuizId(int quizId) {
		this.quizId = quizId;
	}

	public float getCorrectPercent() {
		return correctPercent;
	}

	public void setCorrectPercent(float correctPercent) {
		this.correctPercent = correctPercent;
	}
}
