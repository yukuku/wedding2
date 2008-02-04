<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@page import="sg.edu.ntu.wedding.DatabaseConnection"%>
<%@page import="sg.edu.ntu.wedding.Printer"%>
<%@page import="sg.edu.ntu.wedding.Wedding"%>
<%@page import="sg.edu.ntu.wedding.Constant"%>
<%@page import="java.sql.ResultSet"%>

<%
DatabaseConnection db = DatabaseConnection.getInstance();
Printer prn = new Printer(out);

// handle form
String action = request.getParameter("action");

if ("activate".equals(action)) {
    session.setAttribute(Constant.Session.activeWedding, Integer.parseInt(request.getParameter("id")));
} else if ("create".equals(action)) {
    Wedding w = new Wedding(request);
    int id = db.insert("insert into WEDDING (brideName, groomName, date) values (?, ?, ?)", w.getBrideName(), w.getGroomName(), w.getDate());
    session.setAttribute(Constant.Session.activeWedding, id);
    
    // add tables
    for (int i = 0; i < Integer.parseInt(request.getParameter("tables")); i++) {
        db.insert("insert into `TABLE` (weddingID, name, vacancy) values (?, ?, ?)", id, i+1, 10);
    }
} else if ("delete".equals(action)) {
	int id = Integer.parseInt(request.getParameter("id"));
	
	// del guests
	db.execute("delete from GUEST where weddingID=?", id);
	
	// del tables
	db.execute("delete from `TABLE` where weddingID=?", id);
	
	// del wedding
	db.execute("delete from WEDDING where id=?", id);
}

// active wedding
{
    Integer id = (Integer)session.getAttribute(Constant.Session.activeWedding);
    if (id != null && id != 0) {
        ResultSet rs = db.select("select * from WEDDING where id=?", id);
        pageContext.setAttribute("active", new Wedding(rs));
    }
}

%>

<form name="formActivate" method="post">
    <input type="hidden" name="action" value="activate" />
    <input type="hidden" name="id" value="0" />
</form>

<form name="formDelete" method="post">
    <input type="hidden" name="action" value="delete" />
    <input type="hidden" name="id" value="0" />
</form>

<script type="text/javascript">

function activate(id) {
    document.formActivate.id.value = id;
    document.formActivate.submit();
}

function delete_(id) {
    document.formDelete.id.value = id;
    if (confirm("Are you sure you want to delete this wedding data?")) {
    	document.formDelete.submit();
    }
}

</script>

<h1>Manage weddings</h1>

<h2>Active wedding</h2>

<% if (session.getAttribute(Constant.Session.activeWedding) != null) { %>
    <p>The active wedding now is <b>${active.brideName} & ${active.groomName}</b> (${active.date})</p>
<% } else { %>
    <p>Please activate a wedding from the list below.</p>
<% } %>

<h2>Previous weddings</h2>

<table class="listview">
    <tr>
        <th>Bride &amp; Groom</th>
        <th>Date</th>
        <th>Activate</th>
        <th>Delete</th>
    </tr>
    
    <%
    ResultSet rs = db.select("select * from WEDDING order by date desc");
    while (rs.next()) {
        prn.tr(rs.getString("brideName") + " & " + rs.getString("groomName"), rs.getString("date"), "<input type='button' onclick='activate(" + rs.getInt("id") + ")' value='Activate' />", "<input type='button' onclick='delete_(" + rs.getInt("id") + ")' value='Delete' />");
    }
    %>
</table>


<h2>Create a new wedding</h2>

<form name="form1" method="post">
<table class="form">
    <tr>
        <td>Bride Name</td>
        <td><input type="text" name="brideName" size="20" maxlength="64" required="required" /></td>
    </tr>
    <tr>
        <td>Groom Name</td>
        <td><input type="text" name="groomName" size="20" maxlength="64" required="required" /></td>
    </tr>
    <tr>
        <td>Date (yyyy-mm-dd)</td>
        <td><input type="date" name="date" size="10" maxlength="10" required="required" /></td>
    </tr>
    <tr>
        <td>Number of Tables</td>
        <td><input type="number" min="1" max="999" name="tables" size="6" maxlength="3" value="50" required="required" /></td>
    </tr>
    <tr>
        <td><input type="hidden" name="action" value="create" /></td>
        <td><input type="submit" value="Create now" /></td>
    </tr>
</table>
</form>
