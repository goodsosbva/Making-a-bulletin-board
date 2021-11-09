<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="bbs.BbsDAO"%>
<%@ page import="java.io.PrintWriter"%>
<% request.setCharacterEncoding("UTF-8"); %>
<jsp:useBean id="bbs" class="bbs.Bbs" scope="page" />
<jsp:setProperty  name="bbs" property="bbsTitle" />
<jsp:setProperty  name="bbs" property="bbsContent"/>


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>JSP 게시판 웹사이트</title>
</head>
<body>
	<%	
		String userID = null;
		if((String)session.getAttribute("userID") != null) {
			userID = (String)session.getAttribute("userID");
		}
		if(userID == null) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('로그인 하십숑~~')");
			script.println("location.href='login.jsp'");
			script.println("</script>");
		} else {
			// 입력 안된 사항이 있다면 돌려보내 주기
			if(bbs.getBbsTitle() == null || bbs.getBbsContent() == null) {
				PrintWriter script = response.getWriter();
				// 오류 체크
				// System.out.println(bbs.getBbsTitle());
				// System.out.println(bbs.getBbsContent());
				
				script.println("<script>");
				script.println("alert('입력이 안 된 사항이 있습니당.')");
				script.println("history.back()");
				script.println("</script>");	
			} else {
				// 아니라면 실제 데이터 베이스에 등록 해주기
				BbsDAO bbsDAO = new BbsDAO();
				int result = bbsDAO.write(bbs.getBbsTitle(), userID, bbs.getBbsContent());
						
				if(result == -1) {
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("alert('글쓰기 실팽~')");
					script.println("history.back()");
					script.println("</script>");
				} else { // 글쓰기에 성공한 경우
					PrintWriter script = response.getWriter();
					script.println("<script>");
					// bbs.jsp로 이동
					script.print("location.href = 'bbs.jsp'");
					script.println("</script>");
				}
			}
		}
	
	%>
</body>
</html>