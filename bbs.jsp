<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="bbs.BbsDAO" %>
<%@ page import="bbs.Bbs" %>
<%@ page import="java.util.ArrayList" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset="UTF-8">
<meta name='viewport' content="width=device-width", initial-scale="1">
<link rel="stylesheet" href="css/bootstrap.css">
<title>JSP 게시판 웹 사이트</title>
<style type="text/css">
	a, a:hover, a:focus { animation-duration: 3s; animation-name: rainbowLink; animation-iteration-count: infinite; } 
	@keyframes rainbowLink {     
 	0% { color: #ff2a2a; }
 	15% { color: #ff7a2a; }
 	30% { color: #ffc52a; }
 	45% { color: #43ff2a; }
 	60% { color: #2a89ff; }
 	75% { color: #202082; }
 	90% { color: #6b2aff; } 
 	100% { color: #e82aff; }
	}
</style>
</head>
<body>
	<%
		String userID = null;
		if (session.getAttribute("userID") != null) {
			userID = (String) session.getAttribute("userID");
		}
		// 게시판이 몇 번째 페이지인지 보여주기 위해
		int pageNumber = 1;
		// 페이지넘버 파라미터가 넘어 왔다면
		if (request.getParameter("pageNumber") != null) {
			// 파라미터는 정수형으로 바꿔주어야 한다
			pageNumber = Integer.parseInt(request.getParameter("pageNumber"));
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
			<%
				if(userID == null) {
			%>
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown">
					<a href="#" class="dropdown-toggle"
						data-toggle="dropdown" role="button" aria-haspopup="true"
						aria-expanded="false">접속하기<span="caret"></span></a>
					<ul class="dropdown-menu">
						<li><a href="login.jsp">로그인</a>
						<li><a href="join.jsp">회원가입</a>
					</ul>
				</li>
			</ul>
			<%
				} else {
			%>
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
			
			<%
				}
			%>
			
		</div>
		</div>
	</nav>
	<div class="container">
		<div class="row">
			<table class="table table-striped" style="text-align: center; border: 1px solid $ddddd">
				<thead>
				 	<tr>
				 		<th style="background-color: #eeeeee; text-align: center;">번호</th>
				 		<th style="background-color: #eeeeee; text-align: center;">제목</th>
				 		<th style="background-color: #eeeeee; text-align: center;">작성자</th>
				 		<th style="background-color: #eeeeee; text-align: center;">작성일</th>
				 		
				 		
				 	</tr>
				 </thead>
				 <tbody>
				 	<!-- 게시글 출력이 되야하는 부분 -->
				 	<%
				 		BbsDAO bbsDAO = new BbsDAO();
				 		ArrayList<Bbs> list = bbsDAO.getList(pageNumber);
				 		for(int i = 0; i < list.size(); i++) {
				 	%>
				 	<tr>
				 		<td><%= list.get(i).getBbsID() %></td>
				 		<!-- 클릭하면 이동하게끔 a태그를 이용 --> 
				 		<td><a href="view.jsp?bbsID=<%= list.get(i).getBbsID() %>">
				 			<%= list.get(i).getBbsTitle().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;")
				 				.replaceAll(">", "&gt;").replaceAll("\n", "<br>") %></a></td>
				 		<td><%= list.get(i).getUserID() %></td>
				 		<td><%= list.get(i).getBbsDate().substring(0, 11) + list.get(i).getBbsDate().substring(11, 13) + "시" + list.get(i).getBbsDate().substring(14, 16) + "분" %></td>
				 	</tr>
				 	<% 
				 		}
				 	%>
				 	
				 </tbody>
			</table>
			<%	
				// 페이지가 2 개이상이라면
				if(pageNumber != 1) {
					
			%>	
				<!-- 페이지 넘버가 -1를 해서 이전 페이지로 -->
				<a href="bbs.jsp?pageNumber=<%=pageNumber - 1%>" class="btn btn-success brn-array-left">이전</a>
			<%	
				// 다음 페이지가 있다면
				} if(bbsDAO.nextPage(pageNumber + 1)) {
			
			%>
				<a href="bbs.jsp?pageNumber=<%=pageNumber + 1%>" class="btn btn-success brn-array-left">다음</a>
			<%
				}
			%>
			<a href="write.jsp" class="btn btn-primary pull-right">글쓰기</a>
		</div>
	</div>
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
</body>
</html>