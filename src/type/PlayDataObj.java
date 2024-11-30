package type;

import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;

public class PlayDataObj {
    private int detailId;
    private int imageId;
    private Set<String> correctAnswerSet;

    public int getDetailId() {
        return detailId;
    }

    public void setDetailId(int detailId) {
        this.detailId = detailId;
    }

    public int getImageId() {
        return imageId;
    }

    public void setImageId(int imageId) {
        this.imageId = imageId;
    }

    public boolean isAnswerCorrect(String correctAnswer) {
        if (correctAnswerSet == null || correctAnswer == null) {
            return false;
        }
        return correctAnswerSet.contains(correctAnswer);
    }

    public Set<String> getCorrectAnswerSet() {
        return correctAnswerSet;
    }

    public void setCorrectAnswer(String[] correctAnswer) {
        this.correctAnswerSet = correctAnswer == null ? new HashSet<>() : new HashSet<>(Arrays.asList(correctAnswer));
    }
}
