<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="ez.lsp.boards.BoardBean"%>
<%@ page import="java.util.Vector"%>

<jsp:useBean id="bMgr" class="ez.lsp.boards.oracle.BoardDAO" />

<%	
	request.setCharacterEncoding("UTF-8");
	
	int totalRecord=0;		// 전체레코드수
	int numPerPage=10;		// 페이지당 레코드 수 
	int pagePerBlock=15;	// 블럭당 페이지수 
	
	int totalPage=0;		// 전체 페이지 수
	int totalBlock=0;		// 전체 블럭수 
	
	int nowPage=1;			// 현재페이지
	int nowBlock=1;			// 현재블럭
	
	int start=0;			// DB의 select 시작번호
	int end=10;				// 시작번호로 부터 가져올 select 갯수
	
	int listSize=0;			//현재 읽어온 게시물의 수

	String keyWord = "";
	String keyField = "";
	
	Vector<BoardBean> vlist = null;
	if (request.getParameter("keyWord") != null) {
		keyWord = request.getParameter("keyWord");
		keyField = request.getParameter("keyField");
	}
	
	if (request.getParameter("reload") != null){
		if(request.getParameter("reload").equals("true")) {
			keyWord = "";
			keyField = "";
		}
	}
	
	if (request.getParameter("nowPage") != null) {
		nowPage = Integer.parseInt(request.getParameter("nowPage"));
	}
	
	start = (nowPage * numPerPage) - numPerPage;
	end = numPerPage;
	 
	totalRecord = bMgr.getTotalCount(keyField, keyWord);
	totalPage = (int)Math.ceil((double)totalRecord / numPerPage);	// 전체페이지수
	nowBlock = (int)Math.ceil((double)nowPage / pagePerBlock); 		// 현재블럭 계산
	  
	totalBlock = (int)Math.ceil((double)totalPage / pagePerBlock);  // 전체블럭계산
%>

<html>
<head>
<title>EZLSP Boards</title>
<link href="style.css" rel="stylesheet" type="text/css">
<script type="text/javascript">
	function list() {
		document.listFrm.action = "list.jsp";
		document.listFrm.submit();
	}
	
	function pageing(page) {
		document.readFrm.nowPage.value = page;
		document.readFrm.submit();
	}
	
	function block(value){
		 document.readFrm.nowPage.value=<%=pagePerBlock%>*(value-1)+1;
		 document.readFrm.submit();
	} 
	
	function read(num){
		document.readFrm.num.value=num;
		document.readFrm.action="read.jsp";
		document.readFrm.submit();
	}
	
	function check() {
	     if (document.searchFrm.keyWord.value == "") {
			alert("검색어를 입력하세요.");
			document.searchFrm.keyWord.focus();
			return;
	     }
	  document.searchFrm.submit();
	 }

</script>
<style>
	h1{
	 text-align: center; 
	 font-size:35;
	}
	 .wrap {
            display: grid;
            grid-template-columns: 70% 30%;
            grid-template-rows: 100px 400px;
      }
      .main{ 
      	 grid-column-start: 1;
         grid-column-end: 3;
      }
      .login2{
      	 grid-column-start: 2;
         grid-column-end: 3;
         float: right;
      }
    
</style>
<h1>EZLSP Boards</h1>
</head>

<body bgcolor="#CCFFCC">
<div class = "wrap">
		<div class = "login2">
		<form name="login" method="post" action="memberlogin.jsp">
			<table>
				<th>로그인</th>
				<tr>
					<td>아이디</td>
					<td><input type="text" name="userid"></td>
				</tr>
			
				<tr>
					<td>비밀번호</td>
					<td><input type="password" name="userpw"></td>
				</tr>
				
				<tr>
					<td><input type="submit" value="로그인"></td>
					<td><input type="reset" value="다시입력"></td>
				</tr>
			</table>
		</form>
	</div>
	<div align="center" class ="main">

	<table align="center" width="1000">
			<tr>
				<td>Total : <%=totalRecord%>Articles(<font color="red">
				<%=nowPage%>/<%=totalPage%>Pages</font>)</td>
			</tr>
	</table>
	<table align="center" width="1000" cellpadding="3">
		<tr>
			<td align="center" colspan="2">	
			<%
				  vlist = bMgr.getBoardList(keyField, keyWord, start, end);
				  listSize = vlist.size();//브라우저 화면에 보여질 게시물 번호
				  if (vlist.isEmpty()) {
					out.println("등록된 게시물이 없습니다.");
				  } else {
			%>
				  <table width="100%" cellpadding="2" cellspacing="0">
					<tr align="center" bgcolor="#D0D0D0" height="120%">
						<td>번 호</td>
						<td>제 목</td>
						<td>이 름</td>
						<td>날 짜</td>
						<td>조회수</td>
					</tr>
					<%
						  for (int i = 0;i<numPerPage; i++) {
							if (i == listSize) break;
							BoardBean bean = vlist.get(i);
							int num = bean.getNum();
							String name = bean.getName();
							String subject = bean.getSubject();
							String regdate = bean.getRegdate();
							int depth = bean.getDepth();
							int count = bean.getCount();
					%>
					<tr>
						<td align="center">
							<%=totalRecord-((nowPage-1)*numPerPage)-i%>
						</td>
						<td>
						<%
							  if(depth>0){
								for(int j=0;j<depth;j++){
									out.println("&nbsp;&nbsp;");
									}
								}
						%>
						  <a href="javascript:read('<%=num%>')"><%=subject%></a>
						</td>
						<td align="center"><%=name%></td>
						<td align="center"><%=regdate%></td>
						<td align="center"><%=count%></td>
						</tr>
					<%}//for%>
				</table> <%
 			}//if
 		%>
			</td>
		</tr>
		<tr>
		
			<td colspan="2"><br /><br /></td>
		</tr>
		<tr>
			<td>
			<!-- 페이징 및 블럭 처리 Start--> 
			<%
   				  int pageStart = (nowBlock -1)*pagePerBlock + 1 ; //하단 페이지 시작번호
   				  int pageEnd = ((pageStart + pagePerBlock ) <= totalPage) ?  (pageStart + pagePerBlock): totalPage+1; 
   				  //하단 페이지 끝번호
   				  if(totalPage !=0){
    			  	if (nowBlock > 1) {%>
    			  		<a href="javascript:block('<%=nowBlock-1%>')">prev...</a><%}%>&nbsp; 
    			  		<%for ( ; pageStart < pageEnd; pageStart++){%>
     			     	<a href="javascript:pageing('<%=pageStart %>')"> 
     					<%if(pageStart==nowPage) {%><font color="blue"> <%}%>
     					[<%=pageStart %>] 
     					<%if(pageStart==nowPage) {%></font> <%}%></a> 
    					<%}//for%>&nbsp; 
    					<%if (totalBlock > nowBlock ) {%>
    					<a href="javascript:block('<%=nowBlock+1%>')">.....next</a>
    				<%}%>&nbsp;  
   				<%}%>
 				<!-- 페이징 및 블럭 처리 End-->
				</td>
				<td align="right">
					<a href="post.jsp">[글쓰기]</a> 
					<a href="javascript:list()">[처음으로]</a>
				</td>
			</tr>
		</table>
	<hr width="600"/>
	<form  name="searchFrm"  method="get" action="list.jsp">
	<table width="600" cellpadding="4" cellspacing="0">
 		<tr>
  			<td align="center" valign="bottom">
   				<select name="keyField" size="1" >
    				<option value="name"> 이 름</option>
    				<option value="subject"> 제 목</option>
    				<option value="content"> 내 용</option>
   				</select>
   				<input size="16" name="keyWord">
   				<input type="button"  value="찾기" onClick="javascript:check()">
   				<input type="hidden" name="nowPage" value="1">
  			</td>
 		</tr>
	</table>
	</form>
	<form name="listFrm" method="post">
		<input type="hidden" name="reload" value="true"> 
		<input type="hidden" name="nowPage" value="1">
	</form>
	<form name="readFrm" method="get">
		<input type="hidden" name="num"> 
		<input type="hidden" name="nowPage" value="<%=nowPage%>"> 
		<input type="hidden" name="keyField" value="<%=keyField%>"> 
		<input type="hidden" name="keyWord" value="<%=keyWord%>">
	</form>
	</div>
</div>
</body>
</html>