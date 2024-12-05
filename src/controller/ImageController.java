package controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import util.FileSystem;

import java.io.*;

@WebServlet("/images/*")
public class ImageController extends HttpServlet {
    @Serial
    private static final long serialVersionUID = 1L;

    public ImageController() {
        super();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 요청된 이미지의 경로 추출
        String pathInfo = request.getPathInfo(); // 예: /1.T 또는 /1/2.Q 또는 /1/2.C

        if (pathInfo == null || pathInfo.equals("/")) {
            // 404 오류 반환
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        // 경로를 슬래시('/')로 분리
        String[] pathParts = pathInfo.split("/");

        // 최소한 파일 이름은 있어야 함
        if (pathParts.length < 2) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid Image Path");
            return;
        }

        try {
            if (pathParts.length == 2) {
                // /images/{quizId}.T 형식
                String quizPart = pathParts[1]; // 예: 1.T
                String[] quizParts = quizPart.split("\\.");
                if (quizParts.length != 2) {
                    throw new NumberFormatException();
                }
                int quizId = Integer.parseInt(quizParts[0]);
                String suffix = quizParts[1].toUpperCase();

                if (!suffix.equals("T")) {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid Thumbnail Extension");
                    return;
                }

                // Thumbnail 이미지 경로
                String filePath = FileSystem.getThumbnailImagePath(quizId);
                sendImage(response, filePath);
                return;

            } else if (pathParts.length == 3) {
                // /images/{quizId}/{imageId}.Q 또는 /images/{quizId}/{imageId}.C 형식
                int quizId = Integer.parseInt(pathParts[1]);
                String imagePart = pathParts[2]; // 예: 2.Q 또는 2.C
                String[] imageParts = imagePart.split("\\.");
                if (imageParts.length != 2) {
                    throw new NumberFormatException();
                }
                int imageId = Integer.parseInt(imageParts[0]);
                String suffix = imageParts[1].toUpperCase();

                String filePath;
                if (suffix.equals("Q")) {
                    // Quiz 이미지 경로
                    filePath = FileSystem.getQuizImagePath(quizId, imageId);
                } else if (suffix.equals("C")) {
                    // Correct 이미지 경로
                    filePath = FileSystem.getCorrectImagePath(quizId, imageId);
                } else {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid Image Extension");
                    return;
                }

                sendImage(response, filePath);
                return;

            } else {
                // 예상하지 못한 경로 형식
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid Image Path");
                return;
            }
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid ID Format");
            return;
        }
    }

    /**
     * 이미지 파일을 클라이언트로 전송하는 메서드
     *
     * @param response HTTP 응답 객체
     * @param filePath 이미지 파일의 절대 경로
     * @throws IOException 파일 읽기/쓰기 중 오류 발생 시
     */
    private void sendImage(HttpServletResponse response, String filePath) throws IOException {
        File imageFile = new File(filePath);

        if (!imageFile.exists() || !imageFile.isFile()) {
            // 이미지 파일이 존재하지 않으면 404 오류 반환
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        // 파일의 MIME 타입 설정
        String mimeType = getServletContext().getMimeType(imageFile.getName());
        if (mimeType == null) {
            // MIME 타입을 알 수 없으면 기본값 설정
            mimeType = "application/octet-stream";
        }
        response.setContentType(mimeType);
        response.setContentLength((int) imageFile.length());

        // 캐시 설정 (선택 사항)
        // response.setHeader("Cache-Control", "public, max-age=86400"); // 1일 캐시

        // 파일을 읽어서 응답으로 전송
        try (FileInputStream inStream = new FileInputStream(imageFile);
             OutputStream outStream = response.getOutputStream()) {

            byte[] buffer = new byte[4096];
            int bytesRead;

            while ((bytesRead = inStream.read(buffer)) != -1) {
                outStream.write(buffer, 0, bytesRead);
            }
        } catch (IOException e) {
            // 파일 읽기 또는 쓰기 중 오류 발생 시 500 오류 반환
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error serving the image.");
        }
    }
}
