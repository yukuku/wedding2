<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="sg.edu.ntu.wedding.DatabaseConnection"%>
<%@page import="sg.edu.ntu.wedding.Printer"%>
<%@page import="sg.edu.ntu.wedding.Wedding"%>
<%@page import="sg.edu.ntu.wedding.Constant"%>
<%@page import="java.sql.ResultSet"%>


<h2>test 1 2 3</h2>

<%
DatabaseConnection db = DatabaseConnection.getInstance();
Printer prn = new Printer(out);
%>

<table class="listview">
<tr>
  <th>Guest Title</th><th>Invited By</th><th>Table ID</th><th>Guest Number</th><th>Vegetarians</th><th>Muslims</th><th>Edit Guest</th><th>Delete Guest</th>
</tr>
<%
{
    Integer id = (Integer)session.getAttribute(Constant.Session.activeWedding);
    id = 1;
    if (id != null && id != 0) {
        ResultSet rs = db.select("SELECT * FROM IP_GUEST WHERE WEDDINGID=?", id);
        while (rs.next()) {
            prn.tr(rs.getString("NAME"), 
            		rs.getString("INVITEDBY"),rs.getString("TABLEID"),rs.getString("GUESTTOTAL"),
            		rs.getString("GUESTVEG"), rs.getString("GUESTMUS"),
            		"<input type='button' onclick='editguest(" + rs.getInt("ID") + ")' value='Edit' />", 
            		"<input type='button' onclick='delete_(" + rs.getInt("ID") + ")' value='Delete' />");
        }
    }
}
%>
</table>

