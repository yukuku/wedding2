<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%

response.setHeader("Cache-Control", "no-cache, must-revalidate");
response.setHeader("Expires", "Tue, 26 Feb 2008 00:00:00 GMT");

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>The Wedding Dinner Planner</title>
<link rel="stylesheet" type="text/css" href="css/main.css" />
<link rel="stylesheet" type="text/css" href="css/menu.css" />
<link rel="stylesheet" type="text/css" href="js/webforms2.css" />
<script type="text/javascript" src="js/webforms2.js"></script>
</head>


<body>
<div id="header">
<img src="images/banner.jpg"/>
</div>

<%

// get page name
boolean moduleOk = false;
String module = request.getParameter("module");
if (module == null) module = "main";
for (String ok: new String[] {"main", "weddings", "add", "edit", "guestlist", "assign", "overview", "attendance", }) {
    if (ok.equals(module)) {
        moduleOk = true;
        break;
    }
}

%>

<div id="main">
	<% if (moduleOk) { 	%>
		<jsp:include page="<%= module + ".inc.jsp" %>"></jsp:include>
	<% } else { %>
		<h1>Do not try to hack,  ok? _(^^;)ゞ</h1>
	<% } %>


<div id="leftMenu">
	<%@include file="leftmenu.inc.jsp" %>
</div>

<div id="footer">
<%@include file="footer.inc.jsp" %>
</div>
</div>

<div id="debugPanel">
	<%@include file="debug.inc.jsp" %>
</div>
 
</body>
</html>