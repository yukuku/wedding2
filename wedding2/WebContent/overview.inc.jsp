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
	ResultSet rs= db.select("select tableNumber,sum(attended) as total from IP_GUEST where weddingID=? and tableNumber<> 0 group by tableNumber",active.getId());
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

<h2>Attended Tables</h2>

<table class="listview">
	<tr>
		<th onclick="gsort('tableNumber')" class="sortable">Table Number</th>
		<th  onclick="gsort('total')" class="sortable">Total Guests</th>		
	</tr>
<%
	Printer prn = new Printer(out);
	while (rs.next()) {
		prn.tr(rs.getString("tableNumber"), rs.getString("total"));
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
</table>


<%
}
%>