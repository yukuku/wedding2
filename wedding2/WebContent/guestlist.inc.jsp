<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="sg.edu.ntu.wedding.DatabaseConnection"%>
<%@page import="sg.edu.ntu.wedding.Printer"%>
<%@page import="sg.edu.ntu.wedding.ActiveWedding"%>
<%@page import="sg.edu.ntu.wedding.Wedding"%>
<%@page import="sg.edu.ntu.wedding.Guest"%>
<%@page import="sg.edu.ntu.wedding.Constant"%>
<%@page import="java.sql.ResultSet"%>

<h1>View Guest List</h1>

<%
//begin of if activeWedding;
DatabaseConnection db = DatabaseConnection.getInstance();
	if (ActiveWedding.getAndCheckActiveWedding(db, session, out) != null) {
%>

<form name="formEdit" action="./?module=edit" method="post">
<input type="hidden" name="action" value="edit" /> 
<input type="hidden" name="id" value="0" />
<input type="hidden" name="weddingID" value="0" />
</form>

<form name="formDelete" method="post">
<input type="hidden" name="action" value="delete" /> 
<input type="hidden" name="id" value="0" />
<input type="hidden" name="weddingID" value="0" />
</form>
<script type="text/javascript">
<!--
function editguest(id) {
	var weddingId = document.formSelect.weddingID.value;
    document.formEdit.id.value = id;
    document.formEdit.weddingID.value = weddingId;
    document.formEdit.submit();
}

function delete_(id, gname) {
	var weddingId = document.formSelect.weddingID.value;
    document.formDelete.id.value = id;
    document.formDelete.weddingID.value = weddingId;
    if (confirm("Confirm delete guest: \"" + gname + "\"?")) {
    	document.formDelete.submit();
    }
}

function exportAs(suffix) {
	var weddingId = document.formSelect.weddingID.value;
	window.location.href = "GuestList." + suffix + "?module=export&id=" + weddingId;
}

function gsort(sortCol) {
	var weddingId = document.formSelect.weddingID.value;
	if (weddingId > 0) {
	document.formSelect.sortAs.value = sortCol;
	document.formSelect.submit();
	}
}
-->
</script>

<%
	Printer prn = new Printer(out);
	String weddingID = session.getAttribute(Constant.Session.activeWedding).toString();
	if (weddingID == null || weddingID == "") weddingID = "0";
	String action = request.getParameter("action");
//	if (action.equalsIgnoreCase("delete")) {
	if ("delete".equalsIgnoreCase(action)) {
		ResultSet rs1 = db.select(Constant.Session.guestTableQry2, request.getParameter("id"));
		while (rs1.next()){
			db.delete(ActiveWedding.getActiveWedding(db, session), new Guest(rs1));
		}
	}

%>

<form name="formSelect" method="post">
<%@include file="./currentwedding.inc.jsp" %>
<input type="hidden" name="sortAs" value="" />
<input type="hidden" name="weddingID" value="<%=session.getAttribute(Constant.Session.activeWedding).toString()%>" />
</form>
<p></p>
<table class="listview">
	<tr>
		<th onclick="gsort('NAME')" class="sortable">Name</th>
		<th  onclick="gsort('INVITEDBY')" class="sortable">Invited By</th>
		<th  onclick="gsort('TABLENUMBER')" class="sortable">Table Number</th>
		<th  onclick="gsort('GUESTTOTAL')"  class="sortable">Group Size</th>
		<th  onclick="gsort('GUESTVEG')" class="sortable">Vegetarians</th>
		<th onclick="gsort('GUESTMUS')" class="sortable">Muslims</th>
		<th>Edit Guest</th>
		<th>Delete Guest</th>
	</tr>
	<%
		{
			Integer id = new Integer(weddingID);
			String sortAs = request.getParameter("sortAs");
			String sortOdr = "  ";
			if (sortAs != null && sortAs != "") sortOdr = sortOdr + "Order By " + sortAs;
			if (id != 0) {
				ResultSet rs = db.select(Constant.Session.guestTableQry + sortOdr, id);
				while (rs.next()) {
					prn.tr(rs.getString("NAME"), rs.getString("INVITEDBY"), "0".equals(rs.getString("tableNumber"))?"U.A.":rs.getString("tableNumber"), rs.getString("GUESTTOTAL"), rs.getString("GUESTVEG"),
							rs.getString("GUESTMUS"), "<input type='button' onclick='editguest(" + rs.getInt("ID") + ")' value='Edit' />",
							"<input type='button' onclick='delete_(" + rs.getInt("ID") + ",\"" + rs.getString("NAME") + "\")' value='Delete' />");
				}
			}
		}
	%>
</table>

<br>
<form name="formExport" method="get">
    <input type="button" onclick="exportAs('pdf')" value="Export as PDF" />
    <input type="button" onclick="exportAs('xls')" value="Export as Excel" />
</form>

<%
//end of if activeWedding;
	}
%>

