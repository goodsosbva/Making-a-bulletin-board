<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="bbs.BbsDAO"%>
<%@ page import="bbs.Bbs"%>
<%@ page import="java.io.PrintWriter"%>
<% request.setCharacterEncoding("UTF-8"); %>



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
		} 
		// 현재 글이 유효한지 체크하는 부분
		int bbsID = 0;
		if (request.getParameter("bbsID") != null) {
			// System.out.println(request.getParameter("bbsID"));
			bbsID = Integer.parseInt(request.getParameter("bbsID"));
		}
		if (bbsID == 0) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('유효 하지 않는 글이데용~~')");
			script.println("location.href='bbs.jsp'");
			script.println("</script>");
		}
		// bbsID값을 가지고 넘어온 글을 가져와서 세션에 있는 주체 아이디인지 확인
		Bbs bbs = new BbsDAO().getBbs(bbsID);	
		if (!userID.equals(bbs.getUserID())) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('권한이 없네양~~')");
			script.println("location.href='bbs.jsp'");
			script.println("</script>");
		} else {
			// 입력 안된 사항이 있다면 돌려보내 주기
			if(request.getParameter("bbsTitle") == null || request.getParameter("bbsContent") == null
				|| request.getParameter("bbsTitle").equals("") || request.getParameter("bbsContent").equals("")) {
				PrintWriter script = response.getWriter();
				// 오류 체크
				// System.out.println(bbs.getBbsTitle());
				// System.out.println(bbs.getBbsContent());
				
				script.println("<script>");
				script.println("alert('입력이 안 된 사항이 있습니당.')");
				script.println("history.back()");
				script.println("</script>");	
			} else {
				// 아니라면 실제 데이터 베이스에 업데이트 해주기
				BbsDAO bbsDAO = new BbsDAO();
				int result = bbsDAO.update(bbsID, request.getParameter("bbsTitle"), request.getParameter("bbsContent"));
					// System.out.println(result + " " +bbsID + " " +request.getParameter("bbsTitle") + " " + request.getParameter("bbsContent"));
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