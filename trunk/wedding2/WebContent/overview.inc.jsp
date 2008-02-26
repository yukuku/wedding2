<%@page import="sg.edu.ntu.wedding.ActiveWedding"%>
<%@page import="sg.edu.ntu.wedding.Wedding"%>
<%@page import="sg.edu.ntu.wedding.DatabaseConnection"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="sg.edu.ntu.wedding.Printer"%>
<%
DatabaseConnection db = DatabaseConnection.getInstance();
Wedding active = ActiveWedding.getActiveWedding(db, session);
pageContext.setAttribute("active", active);

if (ActiveWedding.getAndCheckActiveWedding(db, session, out) != null) {
	int nTables = db.fetchInt("select count(*) as c from IP_TABLE where weddingId=?", active.getId());
	int nTablesUsed = db.fetchInt("select count(*) as c from IP_TABLE where weddingId=? and exists (select * from IP_GUEST where weddingId=? and tableNumber=number)", active.getId(), active.getId());
	int nGuests = db.fetchInt("select sum(guestTotal) as c from IP_GUEST where weddingId=?", active.getId());
	int nGroups = db.fetchInt("select count(*) as c from IP_GUEST where weddingId=?", active.getId());
	int nGroupsFull = db.fetchInt("select count(*) as c from IP_GUEST where weddingId=? and attended=guestTotal", active.getId());
	int nGroupsPartial = db.fetchInt("select count(*) as c from IP_GUEST where weddingId=? and attended>0 and attended<guestTotal", active.getId());
	int nGroupsNone = db.fetchInt("select count(*) as c from IP_GUEST where weddingId=? and attended=0", active.getId());
	int nAssignedGroups= db.fetchInt("select count(*) as c from IP_GUEST where weddingId=? and tableNumber<>0", active.getId());
	int nUnassignedGroups= db.fetchInt("select count(*) as c from IP_GUEST where weddingId=? and tableNumber=0", active.getId());	
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
		<td><%= nTables %> tables</td>
	</tr>
	<tr>
		<th>Assigned tables</th>
		<td><%= nTablesUsed %> tables</td>
	</tr>
	<tr>
		<th>Unassigned tables</th>
		<td><%= nTables - nTablesUsed %> tables</td>
	</tr>
</table>

<div style="height: 12px"></div>

<table class="listview">
	<tr>
		<th>Table Number</th>
		<th>Assigned</th>
		<th>Attended</th>
		<th>Free</th>
	</tr>
<%
	Printer prn = new Printer(out);
	
	ResultSet rs = db.select("select * from IP_TABLE where weddingId=? order by number asc", active.getId());
	
	while (rs.next()) {
		int assigned = db.fetchInt("select sum(guestTotal) as c from IP_GUEST where weddingId=? and tableNumber=?", active.getId(), rs.getInt("number"));
		int attended = db.fetchInt("select sum(attended) as c from IP_GUEST where weddingId=? and tableNumber=?", active.getId(), rs.getInt("number"));
		prn.tr(
			rs.getInt("number"),
			assigned,
			attended,
			rs.getInt("vacancy")
		);
	}


%>
</table>


<h2>Guests</h2>

<table class="listview">
	<tr>
		<th>Total number of guests</th>
		<td><%= nGuests %> people</td>
	</tr>
	<tr>
		<th>Number of guest groups</th>
		<td><%= nGroups %> groups</td>
	</tr>
	<tr>
		<th>- Full attendance groups</th>
		<td><%= nGroupsFull %> groups</td>
	</tr>
	<tr>
		<th>- Partial attendance groups</th>
		<td><%= nGroupsPartial %> groups</td>
	</tr>
	<tr>
		<th>- Absent groups</th>
		<td><%= nGroupsNone %> groups</td>
	</tr>
		<th>- Assigned groups</th>
		<td><%= nAssignedGroups %> groups</td>
	<tr>
		<th>- Unassigned groups</th>
		<td><%= nUnassignedGroups %> groups</td>	
	</tr>
	<tr>
	</tr>
</table>


<%
}
%>