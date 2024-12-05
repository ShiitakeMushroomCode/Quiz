package util;

import java.io.File;

public class FileSystem {

    private static final String UPLOADS_DIR = "uploads";
    private static final String IMAGES_DIR = "images";

    // 확장자 정의
    private static final String WEBP_EXTENSION = ".WebP";

    public static String getOriginPath() {
        return System.getProperty("user.dir");
    }

    private static void createDirectoryIfNotExists(String path) {
        File directory = new File(path);
        if (!directory.exists()) {
            boolean created = directory.mkdirs();
            if (!created) {
                throw new RuntimeException("디렉토리 생성 실패: " + path);
            }
        }
    }

    /**
     * 퀴즈 디렉토리 경로를 반환하고, 존재하지 않으면 생성
     *
     * @param quizId 퀴즈 ID
     * @return 퀴즈 디렉토리의 절대 경로
     */
    public static String getQuizDirectoryPath(int quizId) {
        String path = String.join(File.separator,
                getOriginPath(),
                UPLOADS_DIR,
                IMAGES_DIR,
                String.valueOf(quizId));

        createDirectoryIfNotExists(path);
        return path;
    }

    /**
     * 세부 이미지 디렉토리 경로를 반환하고, 존재하지 않으면 생성
     *
     * @param quizId  퀴즈 ID
     * @param imageId 이미지 ID
     * @return 세부 이미지 디렉토리의 절대 경로
     */
    public static String getQuizDetailDirectoryPath(int quizId, int imageId) {
        String path = String.join(File.separator,
                getQuizDirectoryPath(quizId),
                String.valueOf(imageId));

        createDirectoryIfNotExists(path);
        return path;
    }

    /**
     * Thumbnail 이미지의 실제 파일 경로를 반환
     *
     * @param quizId 퀴즈 ID
     * @return Thumbnail 이미지의 절대 경로
     */
    public static String getThumbnailImagePath(int quizId) {
        String directoryPath = getQuizDirectoryPath(quizId);
        String fileName = "Thumbnail" + WEBP_EXTENSION;
        return String.join(File.separator, directoryPath, fileName);
    }

    /**
     * Quiz 이미지의 실제 파일 경로를 반환
     *
     * @param quizId  퀴즈 ID
     * @param imageId 이미지 ID
     * @return Quiz 이미지의 절대 경로
     */
    public static String getQuizImagePath(int quizId, int imageId) {
        String directoryPath = getQuizDetailDirectoryPath(quizId, imageId);
        String fileName = "Quiz" + WEBP_EXTENSION;
        return String.join(File.separator, directoryPath, fileName);
    }

    /**
     * Correct 이미지의 실제 파일 경로를 반환
     *
     * @param quizId  퀴즈 ID
     * @param imageId 이미지 ID
     * @return Correct 이미지의 절대 경로
     */
    public static String getCorrectImagePath(int quizId, int imageId) {
        String directoryPath = getQuizDetailDirectoryPath(quizId, imageId);
        String fileName = "Correct" + WEBP_EXTENSION;
        return String.join(File.separator, directoryPath, fileName);
    }
}
