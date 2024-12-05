package controller;

import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import javax.servlet.ServletException;
import model.User;
import dao.UserDAO;
import dao.QuizDAO;
import model.Quiz;
import util.FileSystem;
import java.io.*;
import java.sql.SQLException;
import java.awt.image.BufferedImage;
import javax.imageio.ImageIO;

// WebP 지원 라이브러리 추가 필요
import com.luciad.imageio.webp.WebPImageReaderSpi;
import com.luciad.imageio.webp.WebPImageWriterSpi;

@WebServlet("/createQuiz")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10,      // 10MB
        maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class CreateQuizController extends HttpServlet {

    @Override
    public void init() throws ServletException {
        super.init();
        // WebP 플러그인 등록
        ImageIO.scanForPlugins();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 세션 처리
        HttpSession session = request.getSession();

        // 로그인된 사용자 정보 가져오기
        User user = (User) session.getAttribute("user");

        if (user == null) {
            // 사용자 로그인 필요
            request.setAttribute("errorMessage", "로그인이 필요합니다.");
            request.getRequestDispatcher("/views/error.jsp").forward(request, response);
            return;
        }

        long kakaoId = user.getKakaoId(); // User 객체에 getKakaoId() 메서드가 있다고 가정

        UserDAO userDAO = new UserDAO();

        User dbUser = userDAO.findByKakaoId(kakaoId);
        if (dbUser == null) {
            request.setAttribute("errorMessage", "사용자를 찾을 수 없습니다.");
            request.getRequestDispatcher("/views/error.jsp").forward(request, response);
            return;
        }

        int userId = dbUser.getId();

        // 파라미터 가져오기
        String quizName = request.getParameter("quizName");
        String exp = request.getParameter("exp");

        // 문자열 공백 제거
        quizName = quizName != null ? quizName.trim() : "";
        exp = exp != null ? exp.trim() : "";

        // 빈 값 체크
        if (quizName.isEmpty() || exp.isEmpty()) {
            request.setAttribute("errorMessage", "퀴즈 제목과 설명은 필수입니다.");
            request.getRequestDispatcher("/views/error.jsp").forward(request, response);
            return;
        }

        // 썸네일 이미지 파일 가져오기
        Part thumbnailPart = null;
        try {
            thumbnailPart = request.getPart("thumbnail");
        } catch (IOException | ServletException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "썸네일 파일 업로드 중 오류가 발생했습니다.");
            request.getRequestDispatcher("/views/error.jsp").forward(request, response);
            return;
        }

        if (thumbnailPart == null || thumbnailPart.getSize() == 0) {
            request.setAttribute("errorMessage", "썸네일 이미지를 선택해주세요.");
            request.getRequestDispatcher("/views/error.jsp").forward(request, response);
            return;
        }

        // 퀴즈 객체 생성
        Quiz quiz = new Quiz();
        quiz.setQuizName(quizName);
        quiz.setExp(exp);
        quiz.setOwnerId(userId);

        // 퀴즈 저장
        QuizDAO quizDAO = new QuizDAO();
        int quizId = 0;
        try {
            quizId = quizDAO.insertQuiz(quiz);
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "퀴즈 저장 중 오류가 발생했습니다.");
            request.getRequestDispatcher("/views/error.jsp").forward(request, response);
            return;
        }

        if (quizId == 0) {
            request.setAttribute("errorMessage", "퀴즈 저장 중 오류가 발생했습니다.");
            request.getRequestDispatcher("/views/error.jsp").forward(request, response);
            return;
        }

        // 썸네일 이미지 저장
        String thumbnailPath = FileSystem.getThumbnailImagePath(quizId);
        try (InputStream inputStream = thumbnailPart.getInputStream()) { // Try-With-Resources 사용
            BufferedImage image = ImageIO.read(inputStream);

            if (image == null) {
                request.setAttribute("errorMessage", "썸네일 이미지 형식이 올바르지 않습니다.");
                request.getRequestDispatcher("/views/error.jsp").forward(request, response);
                return;
            }

            // 디렉토리 생성
            File thumbnailFile = new File(thumbnailPath);
            thumbnailFile.getParentFile().mkdirs();

            // 이미지 WebP로 저장 (webp-imageio 라이브러리 필요)
            boolean success = ImageIO.write(image, "webp", thumbnailFile);
            if (!success) {
                request.setAttribute("errorMessage", "썸네일 이미지 저장 중 오류가 발생했습니다.");
                request.getRequestDispatcher("/views/error.jsp").forward(request, response);
                return;
            }
        } catch (IOException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "썸네일 이미지 저장 중 오류가 발생했습니다.");
            request.getRequestDispatcher("/views/error.jsp").forward(request, response);
            return;
        }

        // 퀴즈 편집 페이지로 리디렉션
        response.sendRedirect(request.getContextPath() + "/views/quizEdit?id=" + quizId);
    }
}
