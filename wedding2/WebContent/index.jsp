<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>The Wedding Dinner Planner</title>
</head>


<body>

<%

// get page name
boolean moduleOk = false;
String module = request.getParameter("module");
if (module == null) module = "main";
for (String ok: new String[] {"main", "weddings", "add", "edit", }) {
    if (ok.equals(module)) {
        moduleOk = true;
        break;
    }
}

%>

<div id="leftmenu">
	<%@include file="leftmenu.inc.jsp" %>
</div>
 
<div id="main">
	<% if (moduleOk) { %>
		<jsp:include page="<%= module + ".inc.jsp" %>"></jsp:include>
	<% } else { %>
		<h1>Do not try to hack,  ok? _(^^;)ゞ</h1>
	<% } %>
</div>

</body>
</html>