package bean;

import type.PlayDataObj;

import java.io.Serializable;

public class PlayData implements Serializable {
    private int quizId;;
    private int count;
    private String title;
    private PlayDataObj[] items;

    public int getQuizId() {
        return quizId;
    }

    public void setQuizId(int quizId) {
        this.quizId = quizId;
    }

    public int getCount() {
        return count;
    }

    public void setCount(int count) {
        this.count = count;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public PlayDataObj[] getItems() {
        return items;
    }

    public void setItems(PlayDataObj[] items) {
        this.items = items;
    }
}

