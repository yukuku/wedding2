<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="sg.edu.ntu.wedding.DatabaseConnection"%>
<%@page import="sg.edu.ntu.wedding.Printer"%>
<%@page import="sg.edu.ntu.wedding.Wedding"%>
<%@page import="sg.edu.ntu.wedding.Constant"%>
<%@page import="java.sql.ResultSet"%>


<h2>test 1 2 3</h2>

<form name="formEdit" action="./?module=edit" method="post">
    <input type="hidden" name="action" value="edit" />
    <input type="hidden" name="id" value="0" />
</form>

<form name="formDelete" method="post">
    <input type="hidden" name="action" value="delete" />
    <input type="hidden" name="id" value="0" />
</form>
<script type="text/javascript">

function editguest(id) {
    document.formEdit.id.value = id;
    document.formEdit.submit();
}

function delete_(id, gname) {
    document.formDelete.id.value = id;
    if (confirm("Confirm delete guest: \"" + gname + "\"?")) {
    	document.formDelete.submit();
    }
}
</script>

<%
DatabaseConnection db = DatabaseConnection.getInstance();
Printer prn = new Printer(out);
String weddingID = request.getParameter("weddingID");
if (weddingID == null || weddingID == "") weddingID = "0";
%>

<form name="formSelect" method="post">
<span>Please select a wedding: </span>
	<select name="weddingID" onchange="submit()">
		<option value=""></option>
<%
{
	ResultSet rsWedding = db.select("SELECT * FROM IP_WEDDING");
	while(rsWedding.next()){
		if(weddingID != null && weddingID.equals(rsWedding.getString("ID"))){
			out.println("<option value=\"" + weddingID + "\" selected=\"selected\">" + rsWedding.getString("groomName") + " & " + rsWedding.getString("brideName") + " (" + rsWedding.getString("Date") + "@" + rsWedding.getString("HotelName") + ")" + "</option>");
		}
		else {
			out.println("<option value=\"" + rsWedding.getString("ID") + "\">" + rsWedding.getString("groomName") + " & " + rsWedding.getString("brideName") + " (" + rsWedding.getString("Date") + "@" + rsWedding.getString("HotelName") + ")" + "</option>");
		}
	} 
}
%>
	</select>
</form>

<table class="listview">
<tr>
  <th>Guest Title</th><th>Invited By</th><th>Table ID</th><th>Guest Number</th><th>Vegetarians</th><th>Muslims</th><th>Edit Guest</th><th>Delete Guest</th>
</tr>
<%
{
    Integer id = new Integer(weddingID);
    if (id != 0) {
        ResultSet rs = db.select("SELECT * FROM IP_GUEST WHERE WEDDINGID=?", id);
        while (rs.next()) {
            prn.tr(rs.getString("NAME"), 
            		rs.getString("INVITEDBY"),rs.getString("TABLEID"),rs.getString("GUESTTOTAL"),
            		rs.getString("GUESTVEG"), rs.getString("GUESTMUS"),
            		"<input type='button' onclick='editguest(" + rs.getInt("ID") + ")' value='Edit' />", 
            		"<input type='button' onclick='delete_(" + rs.getInt("ID") + ",\"" + rs.getString("NAME") + "\")' value='Delete' />");
        }
    }
}
%>
</table>

