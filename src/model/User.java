package model;

import java.sql.Timestamp;

public class User {
	private int id;
	private long kakaoId;
	private String nickname;
	private Timestamp updatedAt;

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public long getKakaoId() {
		return kakaoId;
	}

	public void setKakaoId(long kakaoId) {
		this.kakaoId = kakaoId;
	}

	public String getNickname() {
		return nickname;
	}

	public void setNickname(String nickname) {
		this.nickname = nickname;
	}

	public Timestamp getUpdatedAt() {
		return updatedAt;
	}

	public void setUpdatedAt(Timestamp updatedAt) {
		this.updatedAt = updatedAt;
	}

}
