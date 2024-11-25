package handler;

import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public interface Handler {
    String handleRequest(HttpServletRequest request, HttpServletResponse response) throws IOException;

}
