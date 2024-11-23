<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Login</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f9f9f9;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }

        .login-card {
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 8px 12px rgba(0, 0, 0, 0.2);
            width: 60%;
            max-width: 600px;
            height: 50%;
            max-height: 400px;
            display: flex;
            flex-direction: column;
            justify-content: space-around;
            align-items: center;
        }

        .login-button {
            background-color: #fee500;
            border: none;
            border-radius: 5px;
            padding: 10px 20px;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 16px;
            font-weight: bold;
            color: #3c1e1e;
            text-decoration: none;
            transition: transform 0.2s, box-shadow 0.2s;
        }

        .login-button:hover {
            transform: translateY(-3px);
            box-shadow: 0 6px 10px rgba(0, 0, 0, 0.15);
        }

        .login-button:active {
            transform: translateY(1px);
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        .home-button {
            align-items: center;
            justify-content: center;
            padding: 1rem;
            background-color: #3ca0e0;
            border: none;
            border-radius: 5px;
            padding: 10px 20px;
            cursor: pointer;
            font-size: 3rem;
            color: white;
            text-decoration: none;
            transition: background-color 0.2s, transform 0.2s;
        }

        .home-button:hover {
            background-color: #2a82b8;
            transform: translateY(-3px);
        }

        .home-button:active {
            background-color: #1f6a94;
            transform: translateY(1px);
        }
    </style>
</head>
<body>
<div class="login-card">
    <button
            class="login-button"
            onclick="location.href='<%=request.getContextPath()%>/oauth/kakao'">
        <img src="<%=request.getContextPath()%>/static/icons/KakaoLoginBtn.png" alt="카카오 로그인">
    </button>
    <a href="<%=request.getContextPath()%>/views/" class="home-button">기본 화면으로 가기</a>
</div>
</body>
</html>
