<%@page import="sg.edu.ntu.wedding.ActiveWedding"%>
<%@page import="sg.edu.ntu.wedding.Wedding"%>
<%@page import="sg.edu.ntu.wedding.DatabaseConnection"%>
<%
DatabaseConnection db = DatabaseConnection.getInstance();
Wedding active = ActiveWedding.getActiveWedding(db, session);
pageContext.setAttribute("active", active);

if (ActiveWedding.getAndCheckActiveWedding(db, session, out) != null) {
	int nTables = db.fetchInt("select count(*) as c from IP_TABLE where weddingId=?", active.getId());
	int nTablesUsed = db.fetchInt("select count(*) as c from IP_TABLE where weddingId=? and exists (select * from IP_GUEST where weddingId=? and tableNumber=number)", active.getId(), active.getId());
	int nGuests = db.fetchInt("select sum(guestTotal) as c from IP_GUEST where weddingId=?", active.getId());
	int nGroups = db.fetchInt("select count(*) as c from IP_GUEST where weddingId=?", active.getId());
	int nGroupsInvited = db.fetchInt("select count(*) as c from IP_GUEST where weddingId=? and status=?", active.getId(), "invited");
	int nGroupsAttended = db.fetchInt("select count(*) as c from IP_GUEST where weddingId=? and status=?", active.getId(), "attended");
	int nGroupsAbsent = db.fetchInt("select count(*) as c from IP_GUEST where weddingId=? and status=?", active.getId(), "absent");
	int nGroupsCancelled = db.fetchInt("select count(*) as c from IP_GUEST where weddingId=? and status=?", active.getId(), "cancelled");
%>

<h1>${active.brideName} &amp; ${active.groomName}'s Wedding</h1>

<h2>Wedding Info</h2>

<table class="listview">
	<tr>
		<th>Bride Name</th>
		<td>${active.brideName}</td>
	</tr>
	<tr>
		<th>Groom Name</th>
		<td>${active.groomName}</td>
	</tr>
	<tr>
		<th>Hotel Name</th>
		<td>${active.hotelName}</td>
	</tr>
	<tr>
		<th>Date</th>
		<td>${active.date}</td>
	</tr>
</table>

<h2>Tables</h2>

<table class="listview">
	<tr>
		<th>Number of tables</th>
		<td><%= nTables %></td>
	</tr>
	<tr>
		<th>Assigned tables</th>
		<td><%= nTablesUsed %></td>
	</tr>
	<tr>
		<th>Unassigned tables</th>
		<td><%= nTables - nTablesUsed %></td>
	</tr>
</table>

<h2>Guests</h2>

<table class="listview">
	<tr>
		<th>Total number of guests</th>
		<td><%= nGuests %></td>
	</tr>
	<tr>
		<th>Number of guest groups</th>
		<td><%= nGroups %></td>
	</tr>
	<tr>
		<th>- Invited groups</th>
		<td><%= nGroupsInvited %></td>
	</tr>
	<tr>
		<th>- Attended groups</th>
		<td><%= nGroupsAttended %></td>
	</tr>
	<tr>
		<th>- Absent groups</th>
		<td><%= nGroupsAbsent %></td>
	</tr>
	<tr>
		<th>- Cancelled groups</th>
		<td><%= nGroupsCancelled %></td>
	</tr>
</table>


<%
}
%>