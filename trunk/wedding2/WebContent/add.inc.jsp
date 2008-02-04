<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="sg.edu.ntu.wedding.DatabaseConnection"%>
<%@page import="sg.edu.ntu.wedding.Guest"%>

<%
DatabaseConnection db = DatabaseConnection.getInstance();

// handle form
String action = request.getParameter("action");
if ("add".equals(action)) {
	Guest g = new Guest(request);
	int id = db.insert(
			"insert into GUEST (name, allocated, category, invitedBy, status, guestTotal, guestVeg, guestMus) values (?, ?, ?, ?, ?, ?, ?, ?)", 
			g.getName(), g.isAllocated(), g.getCategory(), g.getInvitedBy(), g.getStatus(), g.getGuestTotal(), g.getGuestVeg(), g.getGuestMus()
	);
}

%>

<h1>Add/import guests</h1>

<h2>Add guests</h2>

<form name="form0" method="post">
	<table class="form">
    <tr>
      <td>Name</td>
      <td>
        <input name="name" type="text" required="required" id="name" size="24" maxlength="64" />
      </td>
    </tr>
    <tr>
      <td>Category</td>
      <td>
         <select name="category" id="category">
           <option value="relative">Relative</option>
           <option value="collague">Collague</option>
           <option value="friend">Friend</option>
         </select>
      </td>
    </tr>
    <tr>
      <td>Invited by </td>
      <td>
        <select name="invitedBy">
          <option value="bride">Bride</option>
          <option value="groom">Groom</option>
          <option value="both">Both</option>
        </select>
      </td>
    </tr>
    <tr>
      <td>Total number of guests </td>
      <td>
        <input name="guestTotal" type="number" min="1" max="10" required="required" id="guestTotal" size="6" maxlength="2" />
      </td>
    </tr>
    <tr>
      <td>- Vegetarians </td>
      <td>
        <input name="guestVeg" type="number" min="1" max="10" id="guestVeg" value="0" size="6" maxlength="2" />
      </td>
    </tr>
    <tr>
      <td>- Muslims </td>
      <td>
        <input name="guestMus" type="number" min="1" max="10" id="guestMus" value="0" size="6" maxlength="2" />
      </td>
    </tr>
    <tr>
      <td>Assign to table</td>
      <td>
        <input type="checkbox" name="auto" value="1" />Automatically assign a table
      </td>
    </tr>
    <tr>
      <td><input type="hidden" name="action" value="add" /></td>
      <td>
        <input type="submit" value="Add" />
      </td>
    </tr>
	</table>
</form>


<h2>Or, import list of guests from file</h2>

<form name="form1" method="post" enctype="application/x-www-form-urlencoded">
	<table class="form">
		<tr>
			<td>Data File</td>
			<td><input type="file" name="file"  required="required" size="60" /></td>
		</tr>
		<tr>
			<td>AutoAssign</td>
			<td><input type="checkbox" name="auto" value="1"/>Let the system AutoAssign new groups</td>
		</tr>
		<tr>
			<td><input type="hidden" name="action" value="import" /></td>
			<td><input type="submit" value="Import" /></td>
		</tr>
	</table>
</form>
