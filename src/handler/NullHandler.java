package handler;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class NullHandler implements Handler {

	@Override
	public String handleRequest(HttpServletRequest request, HttpServletResponse response) {
		return "notFound";
	}

}
