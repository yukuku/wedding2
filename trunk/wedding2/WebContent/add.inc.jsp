<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.io.InputStream"%>
<%@page import="sg.edu.ntu.wedding.DatabaseConnection"%>
<%@page import="sg.edu.ntu.wedding.Guest"%>
<%@page import="org.apache.commons.fileupload.FileItemIterator"%>
<%@page import="org.apache.commons.fileupload.servlet.ServletFileUpload"%>
<%@page import="org.apache.commons.fileupload.FileItemStream"%>
<%@page import="org.apache.commons.fileupload.util.Streams"%>
<%@page import="java.util.Vector"%>
<%@page import="sg.edu.ntu.wedding.Parse"%>
<%@page import="sg.edu.ntu.wedding.Importer"%>
<%@page import="java.io.InputStreamReader"%>
<%@page import="sg.edu.ntu.wedding.ActiveWedding"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page import="sg.edu.ntu.wedding.AutoAssign"%>
<%@page import="java.io.BufferedReader"%>
<%
DatabaseConnection db = DatabaseConnection.getInstance();

// handle form
if (ServletFileUpload.isMultipartContent(request)) {
	// Create a new file upload handler
	ServletFileUpload upload = new ServletFileUpload();

	// Parse the request
	FileItemIterator iter = upload.getItemIterator(request);
	Vector<String> lines = new Vector<String>();
	boolean auto = false;
	while (iter.hasNext()) {
	    FileItemStream item = iter.next();
	    String name = item.getFieldName();
	    InputStream stream = item.openStream();
	    if (item.isFormField()) {
	        if ("auto".equals(name)) {
	        	auto = Parse.toBoolean(Streams.asString(stream));
	        }
	    } else {
	    	if ("file".equals(name)) {
	    		//BufferedReader in = new BufferedReader(new InputStreamReader(stream, "utf8"));
	    		int intAutoAssign;
	    		if (auto == true)
	    			intAutoAssign = 1;
	    		else
	    			intAutoAssign = 0;
	    		int intProcessedId = Importer.processFile(ActiveWedding.getActiveWedding(db, session).getId(), new InputStreamReader(stream, "utf8"), intAutoAssign, ActiveWedding.getActiveWedding(db, session));
	    		if (intProcessedId < 0) {
	    			pageContext.setAttribute("message", "There are errors with the file. File not uploaded!");
	    		}
	    		else {
	    			if (intAutoAssign == 0)
	    				pageContext.setAttribute("message", "File uploaded successfully!");
	    			else {
	    				if (intProcessedId == 1)
	    					pageContext.setAttribute("message", "File uploaded successfully with Auto-Assign completed!");
	    				else
	    					pageContext.setAttribute("message", "File uploaded successfully with Auto-Assign incomplete! Please perform manual assignment!");
	    			}
	    		}
	    	}
	    }
	}
} else {
	String action = request.getParameter("action");
	if ("add".equals(action)) {
		Guest g = new Guest(request);
		int id = db.insert(
				"insert into IP_GUEST (weddingID, name, category, invitedBy, guestTotal, guestVeg, guestMus) values (?, ?, ?, ?, ?, ?, ?)", 
				ActiveWedding.getActiveWedding(db, session).getId(), g.getName(), g.getCategory(), g.getInvitedBy(), g.getGuestTotal(), g.getGuestVeg(), g.getGuestMus()
		);
		String strAutoAssign = request.getParameter("auto");
		if (strAutoAssign == null)
			strAutoAssign = "0";
		else
			strAutoAssign = "1";
		if (strAutoAssign.compareTo("1") == 0) {
			int intAutoAssignResult = AutoAssign.AutoAssignSingleGuest(id, ActiveWedding.getActiveWedding(db, session).getId(), g.getGuestTotal(), g.getGuestVeg(), g.getGuestMus(), ActiveWedding.getActiveWedding(db, session));
			if (intAutoAssignResult < 1) {
				if (intAutoAssignResult == -3)
					pageContext.setAttribute("message", "The guest (" + g.getName() + ") has been added. " + "Unable to auto assign due to lack of tables with either the right vacancy or meal type!");
				else if (intAutoAssignResult == -2)
					pageContext.setAttribute("message", "The guest (" + g.getName() + ") has been added. " + "Unable to auto assign as there are no more empty tables!");
				else
					pageContext.setAttribute("message", "The guest (" + g.getName() + ") has been added. " + "Unable to auto assign with unexpected error code of " + intAutoAssignResult);
			}
			else {
				pageContext.setAttribute("message", "The guest (" + g.getName() + ") has been added. " + "Successfully assigned to table " + intAutoAssignResult);
			}
		}
		else
			pageContext.setAttribute("message", "The guest (" + g.getName() + ") has been added");
	}
}

%>

<h1>Add/import guests</h1>

<h2>Add guests</h2>

<%
	if (ActiveWedding.getAndCheckActiveWedding(db, session, out) != null) {
%>
<c:if test="${not empty message}">
<div class="message">${message}</div>
</c:if>

<script type="text/javascript">

function validateForm(form) {
    if (!Validation.filled(form.name)) return false;
    if (!Validation.number(form.guestTotal, 1, 10)) return false;
    if (!Validation.number(form.guestVeg, 0, parseInt(form.guestTotal.value))) return false;
    if (!Validation.number(form.guestMus, 0, parseInt(form.guestTotal.value))) return false;
    if (parseInt(form.guestTotal.value) < (parseInt(form.guestVeg.value) + parseInt(form.guestMus.value))){
    	alert("Make sure the addition of guestVeg and guestMus is not greater than total no. of guests!");
    	return false;
    }
    return true;
}

</script>

<form name="form0" method="post" onSubmit="return validateForm(this)">
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
      <td>Group Size</td>
      <td>
        <input name="guestTotal" type="number" min="1" max="10" required="required" id="guestTotal" size="6" maxlength="2" /> persons
      </td>
    </tr>
    <tr>
      <td>- Vegetarians </td>
      <td>
        <input name="guestVeg" type="number" min="0" max="10" id="guestVeg" value="0" size="6" maxlength="2" />
      </td>
    </tr>
    <tr>
      <td>- Muslims </td>
      <td>
        <input name="guestMus" type="number" min="0" max="10" id="guestMus" value="0" size="6" maxlength="2" />
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

<form name="form1" method="post" enctype="multipart/form-data">
	<table class="form">
		<tr>
			<td>AutoAssign</td>
			<td><input type="checkbox" name="auto" value="1"/>Let the system AutoAssign new groups</td>
		</tr>
		<tr>
			<td>Data File</td>
			<td><input type="file" name="file" required="required" size="60"/></td>
		</tr>
		<tr>
			<td><input type="hidden" name="action" value="import" /></td>
			<td><input type="submit" value="Import" /></td>
		</tr>
	</table>
</form>

<%
	}
%>
