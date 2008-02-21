<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="activeWedding.inc.jsp" %>
<%
DatabaseConnection db = DatabaseConnection.getInstance();
Wedding active = getActiveWedding(db, session); 

%>

<h1>Edit guests</h1>


<%
	if (getAndCheckActiveWedding(db, session, out) != null) {
%>
	
<form name="form0">
<table class="form">

    <tr>
        <td>Select guest to edit</td>
        <td><select name="id" id="id">
        </select></td>
    </tr>
    <tr>
        <td>Name</td>
        <td><input name="name" type="text" id="name" size="24" maxlength="64" /></td>
    </tr>
    <tr>
        <td>Category</td>
        <td>
        <p><select name="category" id="category">
            <option>relative</option>
            <option>collague</option>
            <option>friend</option>
        </select></p>
        </td>
    </tr>
    <tr>
        <td>Invited by</td>
        <td><select name="invitedBy">
            <option>bride</option>
            <option>groom</option>
            <option>both</option>
        </select></td>
    </tr>

    <tr>
        <td>Total number of guests</td>
        <td><input name="guestTotal" type="text" id="guestTotal" size="6" maxlength="2" /></td>
    </tr>
    <tr>
        <td>- Vegetarians</td>
        <td><input name="guestVeg" type="text" id="guestVeg" value="0" size="6" maxlength="2" /></td>
    </tr>
    <tr>
        <td>- Muslims</td>
        <td><input name="guestMus" type="text" id="guestMus" value="0" size="6" maxlength="2" /></td>
    </tr>
    <tr>
        <td><input type="hidden" name="action" value="edit" /></td>
        <td><input type="submit" value="Edit" /></td>
    </tr>

</table>
</form>

<%
	}
%>

