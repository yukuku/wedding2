<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="sg.edu.ntu.wedding.DatabaseConnection"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="sg.edu.ntu.wedding.Guest"%>
<%@page import="sg.edu.ntu.wedding.Assignment" %>
<%@page import="sg.edu.ntu.wedding.Wedding" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<h1>Edit guests</h1>

<form name="formGuestList" action="./?module=guestlist" method="post">
<input type="hidden" name="weddingID" value="0" />
</form>

<script language="javascript">
function validForm(frm){
    if (!Validation.filled(frm.name)) return false;
	if(!isNumeric(frm.guestTotal.value)){
	    alert("Make sure Total number of guests field is numeric!");        
        return false;
    }
    if(!isNumeric(frm.guestVeg.value)){
        alert("Make sure guestVeg field is numeric!");
        return false;
    }   
    if(!isNumeric(frm.guestMus.value)){
        alert("Make sure guestMus field is numeric!");
        return false;
    }  
    if(parseInt(frm.guestTotal.value)< (parseInt(frm.guestVeg.value)+parseInt(frm.guestMus.value))){
    	alert("Make sure the addition of guestVeg and guestMus is not greater than total no. of guests!");
    	return false;
    }    
    return true;
}

function isNumeric(str){
  	var strValidChars = "0123456789";
	var strChar;
   	var blnResult = true;

   	//  test str consists of valid characters listed above
   	for (i = 0; i < str.length && blnResult == true; i++){
    	strChar = str.charAt(i);
      	if (strValidChars.indexOf(strChar) == -1){
        	blnResult = false;
        }
    }
   	return blnResult;
   }

</script>

<%         
		int id= Integer.parseInt(request.getParameter("id"));		
	    DatabaseConnection db = DatabaseConnection.getInstance();
        ResultSet rs= db.select("SELECT * FROM IP_GUEST WHERE ID=?",id);
        rs.next();
        Guest g = new Guest(rs); 
        Guest gn=new Guest(rs);
        pageContext.setAttribute("g", g);
       
		String saction=request.getParameter("action");
		if("submit".equalsIgnoreCase(saction)){
%>
	<jsp:setProperty name="g" property="*" />
<%	    
		if (id > 0) {
			boolean b=db.update(g);
			if (b){			
				Assignment.unassign(db,Wedding.getWedding(db,gn.getweddingID()),gn);
				out.println("<SCRIPT LANGUAGE='JavaScript'>");
				out.println("document.formGuestList.weddingID.value=" + String.valueOf(g.getweddingID()));
				out.println("document.formGuestList.submit()");
				out.println("</SCRIPT>");				
			}else{
				out.println(" <SCRIPT LANGUAGE='JavaScript'>");
			    out.println("alert('Error in Guest updating.')");
			    out.println(" </SCRIPT> ");
			}
		}
	}
%>


<form name="frmGuestEdit" method="post" onSubmit="return validForm(this)">

<table class="form" >   
    <tr>
     	<td>Guest ID</td>
         <td><input name="guestID" type="text" value="${g.id}" readonly style="background-color: gainsboro;" size="24"/></td>
    </tr>          
	<tr>
        <td>Name</td>
        <td><input name="name" type="text" value="${g.name}" required="required id="name" size="24" maxlength="64" /></td>        
    </tr>
    <tr>
        <td>Category</td>
        <td>
        	<select name="category" id="category" >
        		<c:set var="sel" value=""></c:set>
            	<c:if test="${g.category == 'relative'}">
              		<c:set var="sel" value="selected"></c:set>
            	</c:if>
            	<option value="relative" ${sel}>relative</option>
        		<c:set var="sel" value=""></c:set>
            	<c:if test="${g.category == 'collage'}">
              		<c:set var="sel" value="selected"></c:set>
            	</c:if>
            	<option value="collage" ${sel}>collage</option>
         		<c:set var="sel" value=""></c:set>
            	<c:if test="${g.category == 'friend'}">
              		<c:set var="sel" value="selected"></c:set>
            	</c:if>
            	<option value="friend" ${sel}>friend</option>           
        	</select>
        </td>
    </tr>    
    <tr>
        <td>Invited by</td>
        <td>
        	<select name="invitedBy">
        		<c:set var="sel" value=""></c:set>
            	<c:if test="${g.invitedBy == 'bride'}">
            		<c:set var="sel" value="selected"></c:set>
           		</c:if>
            	<option value="bride" ${sel}>bride</option>
        		<c:set var="sel" value=""></c:set>
            	<c:if test="${g.invitedBy == 'groom'}">
            		<c:set var="sel" value="selected"></c:set>
            	</c:if>
            	<option value="groom" ${sel}>groom</option>
         		<c:set var="sel" value=""></c:set>
            	<c:if test="${g.invitedBy == 'both'}">
            		<c:set var="sel" value="selected"></c:set>
            	</c:if>
            	<option value="both" ${sel}>both</option>
        	</select>
        </td>
    </tr>
    <tr>
        <td>Group Size</td>
        <td><input name="guestTotal" value="${g.guestTotal}" type="text" id="guestTotal" required="required" size="6" maxlength="2" /> persons</td>
    </tr>
    <tr>
        <td>- Vegetarians</td>
        <td><input name="guestVeg" type="text" id="guestVeg" value="${g.guestVeg}" size="6" required="required  maxlength="2" /></td>
    </tr>
    <tr>
        <td>- Muslims</td>
        <td><input name="guestMus" type="text" id="guestMus" value="${g.guestMus}" size="6" required="required  maxlength="2" /></td>
    </tr>
    <tr>
    <tr>
        <td><input type="hidden" name="action" value="submit" />        	
        	<input type="hidden" name="id" id="id" value="${g.id}" />        	
        </td>
        <td><input type="submit" value="Edit" /></td>
    <tr>   
</table>

</form>



