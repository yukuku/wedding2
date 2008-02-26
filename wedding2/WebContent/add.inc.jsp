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
	    		
	    		int intProcessedId = Importer.processFile(ActiveWedding.getActiveWedding(db, session).getId(), new InputStreamReader(stream, "utf8"));
	    		if (intProcessedId != 1) {
	    			pageContext.setAttribute("message", "There are errors with the file");
	    		}
	    		else {
	    			pageContext.setAttribute("message", "File uploaded successfully");
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
			<td>Data File</td>
			<td><input type="file" name="file" required="required" size="60"/></td>
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

<%
	}
%>
