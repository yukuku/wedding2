<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="sg.edu.ntu.wedding.DatabaseConnection"%>
<%@page import="sg.edu.ntu.wedding.Wedding"%>
<%@page import="sg.edu.ntu.wedding.Guest"%>
<%@page import="sg.edu.ntu.wedding.ActiveWedding"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="sg.edu.ntu.wedding.Parse"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
	DatabaseConnection db = DatabaseConnection.getInstance();
	Wedding active = ActiveWedding.getActiveWedding(db, session);
%>

<% if (ActiveWedding.getAndCheckActiveWedding(db, session, out) != null) { %>

<%
// process form
String action = request.getParameter("action");
if ("attend".equals(action)) {
	String[] guestIds = request.getParameterValues("guestId");
	String[] attendeds = request.getParameterValues("attended");
	
	for (int i = 0; i < guestIds.length && i < attendeds.length; i++) {
		int guestId = Parse.toInt(guestIds[i]);
		int attended = Parse.toInt(attendeds[i]);
		
		db.execute("update IP_GUEST set attended=? where id=?", attended, guestId);
	}
	
	pageContext.setAttribute("message", "Attendance status updated.");
}

%>

<h1>Guest Attendance</h1>

<c:if test="${not empty message}">
<div class="message">${message}</div>
</c:if>

<form name="form1" method="post">

<table class="listview">
	<tr>
		<th>Name</th>
		<th>Persons</th>
		<th>Table Number</th>
		<th>Attended</th>
	</tr>
	<%
		ResultSet rs = db.select("select * from IP_GUEST where weddingID=? order by name", active.getId());
				while (rs.next()) {
					Guest g = new Guest(rs);
					
					out.println(String.format("<input type='hidden' name='guestId' value='%d' /><tr><td>%s</td><td>%d</td><td>%s</td><td><input name='attended' value='%d' type='number' min='0' max='%d' required='required' maxlength='2' size='4' /></td></tr>", 
							g.getId(), g.getName(), g.getGuestTotal(), g.getTableNumber() == 0 ? "-" : String.valueOf(g.getTableNumber()), g.getAttended(), g.getGuestTotal())
					);
				}
	%>
	
	<tr>
		<td><input type="hidden" name="action" value="attend" /></td>
		<td colspan="3"><input type="submit" value="Update" /></td>
	</tr>	
</table>

</form>
<%
}
%>