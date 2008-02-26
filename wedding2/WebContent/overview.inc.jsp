<%@page import="sg.edu.ntu.wedding.ActiveWedding"%>
<%@page import="sg.edu.ntu.wedding.Wedding"%>
<%@page import="sg.edu.ntu.wedding.DatabaseConnection"%>
<%
DatabaseConnection db = DatabaseConnection.getInstance();
Wedding active = ActiveWedding.getActiveWedding(db, session);
pageContext.setAttribute("active", active);

if (ActiveWedding.getAndCheckActiveWedding(db, session, out) != null) {
%>

<h1>${w.brideName} &amp; ${w.groomName}'s Wedding</h1>

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
		<th>Assigned tables</th>
		<td></td>
	</tr>
	<tr>
		<th>Unassigned tables</th>
		<td></td>
	</tr>
</table>


<%
}
%>