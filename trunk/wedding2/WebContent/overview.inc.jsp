<%@page import="sg.edu.ntu.wedding.ActiveWedding"%>
<%@page import="sg.edu.ntu.wedding.Wedding"%>
<%@page import="sg.edu.ntu.wedding.DatabaseConnection"%>
<%
DatabaseConnection db = DatabaseConnection.getInstance();
Wedding active = ActiveWedding.getActiveWedding(db, session);
pageContext.setAttribute("active", active);

if (ActiveWedding.getAndCheckActiveWedding(db, session, out) != null) {
%>

<h1>${active.brideName} &amp; ${active.groomName}'s Wedding</h1>

<h2>Wedding Info</h2>

<table class="listview">
	<tr>
		<th>Bride Name</th>
		<td></td>
	</tr>
	<tr>
		<th>Groom Name</th>
		<td></td>
	</tr>
	<tr>
		<th>Unassigned tables</th>
		<td></td>
	</tr>
</table>

<h2>Tables</h2>

<table class="listview">
	<tr>
		<th>Number of tables</th>
		<td></td>
	</tr>
	<tr>
		<th>Assigned tables</th>
		<td></td>
	</tr>
	<tr>
		<th>Unassigned tables</th>
		<td></td>
	</tr>
</table>

<h2>Guests</h2>

<table class="listview">
	<tr>
		<th>Total number of guests</th>
		<td></td>
	</tr>
	<tr>
		<th>Number of guest groups</th>
		<td></td>
	</tr>
	<tr>
		<th>- Invited groups</th>
		<td></td>
	</tr>
	<tr>
		<th>- Attended groups</th>
		<td></td>
	</tr>
	<tr>
		<th>- Absent groups</th>
		<td></td>
	</tr>
	<tr>
		<th>- Cancelled groups</th>
		<td></td>
	</tr>
</table>


<%
}
%>