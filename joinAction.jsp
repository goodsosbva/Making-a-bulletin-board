<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="user.UserDAO"%>
<%@ page import="java.io.PrintWriter"%>
<% request.setCharacterEncoding("UTF-8"); %>
<jsp:useBean id="user" class="user.User" scope="page" />
<jsp:setProperty  name="user" property="userID" />
<jsp:setProperty  name="user" property="userPassword"/>
<jsp:setProperty  name="user" property="userName" />
<jsp:setProperty  name="user" property="userGender"/>
<jsp:setProperty  name="user" property="userEmail" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>JSP 게시판 웹사이트</title>
</head>
<body>
	<%	
		String userID = null;
		if((String)session.getAttribute("userID") != null){
			userID = (String)session.getAttribute("userID");
		}
		if(userID != null){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('이미 로그인 되어있습니다.')");
			script.println("location.href='main.jsp'");
			script.println("</script>");
		}
	
		if(user.getUserID() == null || user.getUserPassword() == null ||
		   user.getUserName() == null || user.getUserGender() == null || user.getUserEmail() == null){
			PrintWriter script = response.getWriter();
			System.out.println(user.getUserID());
			System.out.println(user.getUserPassword());
			System.out.println(user.getUserName());
			System.out.println(user.getUserGender());
			System.out.println(user.getUserEmail());
			script.println("<script>");
			script.println("alert('입력이 안 된 사항이 있습니다.')");
			script.println("history.back()");
			script.println("</script>");	
		} else {
			// 객체 접근
			UserDAO userDAO = new UserDAO();
			int result = userDAO.join(user);
			
			if(result == -1){
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('이미 존재하는 아이디입니다.')");
				script.println("history.back()");
				script.println("</script>");
			}
			else { // result == 0
				session.setAttribute("userID", user.getUserID());
				PrintWriter script = response.getWriter();
				script.println("<script>");
				// 메인 페이지 이동
				script.print("location.href = 'main.jsp'");
				script.println("</script>");
			}
		}
	
	%>
</body>
</html>