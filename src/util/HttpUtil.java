package util;

import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;

public class HttpUtil {
	public static String post(String urlStr, String params) throws IOException {
		URL url = new URL(urlStr);
		HttpURLConnection conn = (HttpURLConnection) url.openConnection();
		conn.setRequestMethod("POST");
		conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
		conn.setDoOutput(true);

		try (OutputStream os = conn.getOutputStream()) {
			os.write(params.getBytes());
			os.flush();
		}

		BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
		StringBuilder sb = new StringBuilder();
		String line;
		while ((line = br.readLine()) != null) {
			sb.append(line);
		}
		return sb.toString();
	}

	public static String get(String urlStr, String authorization) throws IOException {
		URL url = new URL(urlStr);
		HttpURLConnection conn = (HttpURLConnection) url.openConnection();
		conn.setRequestMethod("GET");
		conn.setRequestProperty("Authorization", authorization);

		BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
		StringBuilder sb = new StringBuilder();
		String line;
		while ((line = br.readLine()) != null) {
			sb.append(line);
		}
		return sb.toString();
	}
}
