<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="sg.edu.ntu.wedding.DatabaseConnection"%>
<%@page import="sg.edu.ntu.wedding.Wedding"%>
<%@page import="sg.edu.ntu.wedding.Parse"%>
<%@page import="sg.edu.ntu.wedding.Guest"%>
<%@page import="sg.edu.ntu.wedding.Assignment"%>
<%@page import="java.util.Vector"%>
<%@page import="sg.edu.ntu.wedding.Table"%>
<%@page import="sg.edu.ntu.wedding.ActiveWedding"%>
<%@page import="java.sql.ResultSet"%>
<%
	DatabaseConnection db = DatabaseConnection.getInstance();
	Wedding active = ActiveWedding.getActiveWedding(db, session);

	int guestID = Parse.toInt(request.getParameter("id"));
	String action = request.getParameter("action");
%>

<h1>Assign guests to tables</h1>

<%
	if (ActiveWedding.getAndCheckActiveWedding(db, session, out) != null) {
%>

<%
	if (guestID == 0 || action != null) {
		if ("assign".equals(action)) {
			ResultSet rs = db.select("select * from IP_GUEST where id=?", guestID);
			rs.next();
			Guest g = new Guest(rs);
			int tableNumber = Parse.toInt(request.getParameter("tableNumber"));
			if (tableNumber == 0) {
				Assignment.unassign(db, active, g);
			} else {
				rs = db.select("select * from IP_TABLE where weddingID=? and number=?", active.getId(), tableNumber);
				rs.next();
				Table t = new Table(rs);
				Assignment.assign(db, active, g, t);
			}
		}
%>
<p>Select guest to assign.</p>

<table class="listview">
	<tr>
		<th>Name</th>
		<th>Persons</th>
		<th>Vegetarian</th>
		<th>Muslim</th>
		<th>Table Number</th>
	</tr>
	<%
		ResultSet rs = db.select("select * from IP_GUEST where weddingID=? order by name", active.getId());
				while (rs.next()) {
					Guest g = new Guest(rs);
					out.println(String.format("<tr><td><a href='./?module=assign&id=%d'>%s</a></td><td>%d</td><td>%d</td><td>%d</td><td>%s</td>", g.getId(), g.getName(), g.getGuestTotal(), g
							.getGuestVeg(), g.getGuestMus(), g.getTableNumber() == 0 ? "-" : String.valueOf(g.getTableNumber())));
				}
	%>
</table>
<%
	} else {
		ResultSet rs2 = db.select("select * from IP_GUEST where id=?", guestID);
		rs2.next();
		Guest guest = new Guest(rs2);
		pageContext.setAttribute("guest", guest);
%>
<p>Assign this guest:</p>
<form name="form1" method="post">
<table class="listview">

	<tr>
		<th>Name</th>
		<td>${guest.name}</td>
	</tr>
	<tr>
		<th>Number of people</th>
		<td>${guest.guestTotal}</td>
	</tr>
	<tr>
		<th>- Vegetarians</th>
		<td>${guest.guestVeg}</td>
	</tr>
	<tr>
		<th>- Muslims</th>
		<td>${guest.guestMus}</td>
	</tr>
	<tr>
		<th>Assigned to table</th>
		<td><select name="tableNumber">
		<%
		
		Vector<Table> tables = Assignment.getPossibleAssignment(db, active, guest);
		// unassigned
		out.println(String.format("<option value='0'>(unassigned)</option>"));
		
		for (Table table: tables) {
			String self = "";
			if (table.getNumber() == guest.getTableNumber()) {
				self = " selected ";
			}
			out.println(String.format("<option value='%d' %s>%d (%d vacancy, %s)</option>%n", table.getNumber(), self, table.getNumber(), table.getVacancy(), table.getType()));
		}
		
		%>
		</select></td>
	</tr>

	<tr>
		<td>
			<input type="hidden" name="action" value="assign" />
		</td>
		<td><input type="submit" value="Assign" /></td>
	</tr>

</table>
</form>
<%
	}
%>
<%
	}
%>
