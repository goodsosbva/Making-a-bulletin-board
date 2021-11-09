<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="bbs.Bbs" %>
<%@ page import="bbs.BbsDAO" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset="UTF-8">
<meta name='viewport' content="width=device-width", initial-scale="1">
<link rel="stylesheet" href="css/bootstrap.css">
<link rel="stylesheet" href="css/custom.css">
<title>hs드립넷</title>
</head>
<body>
	<%
	String userID = null;
	if ((String) session.getAttribute("userID") != null) {
		userID = (String) session.getAttribute("userID");
	}
	if (userID == null) {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('로그인을 하세영~~')");
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
	}
	%>
		<nav class="navbar navbar-default">
		<div class="navbar-header">
			<button type="button" class="navbar-toggle collapsed"
				data-toggle="collapse" data-target="#bs-example-navbar-collapse-1"
				aria-expanded="false">
				<!-- 게시판 아이콘 작대기(-) 하나를 의미 -->
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
				</button>
				<a class="navbar-brand" href="main.jsp">JSP 게시판 웹 사이트</a>
		<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
			<ul class="nav navbar-nav">
				<li><a href="main.jsp">메인</a></li>
				<!-- 현재 페이지는 게시판이다: active -->
				<li class="active"><a href="bbs.jsp">게시판</a></li>
			</ul>
			
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown">
					<a href="#" class="dropdown-toggle"
						data-toggle="dropdown" role="button" aria-haspopup="true"
						aria-expanded="false">회원관리<span="caret"></span></a>
					<ul class="dropdown-menu">
						<li><a href="logoutAction.jsp">로그아웃</a>
						
					</ul>
				</li>
			</ul>
		</div>
		</div>
	</nav>
	<div class="container">
		<div class="row">
			<form method="post" action="updateAction.jsp?bbsID=<%=bbsID%>">
				<table class="table table-striped" style="text-align: center; border: 1px solid $ddddd">
					<thead>
				 		<tr>
				 			<th colspan="2" style="background-clolr: #eeeeee; text-align: center;">게시판 글쓰기 수정</th>
				 		</tr>
				 	</thead>
				 	<tbody>
				 		<tr>
				 			<!-- 글쓰기를 수정할꺼니까 수정하기 전 내용을 보여줄 필요가 있음  -->
				 			<td><input type="text" class="form-control" placeholder="글 제목" name="bbsTitle" maxlength="50" value="<%=bbs.getBbsTitle() %>"></td>
				 		</tr>
				 		<tr>
				 			<td><textarea class="form-control" placeholder="글 내용" name="bbsContent" maxlength="2048" style="height: 350px;"><%=bbs.getBbsContent() %></textarea></td>
				 		</tr>
				 	</tbody>
				
				</table>
				<!-- 글쓰기 수정 만들어주기 -->
				<input type="submit" class="btn btn-primary pull-right" value="수정">
			</form>
		</div>
	</div>
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
</body>
</html>