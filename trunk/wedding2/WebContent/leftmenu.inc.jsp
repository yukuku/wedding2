<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="sg.edu.ntu.wedding.DatabaseConnection"%>
<%@page import="sg.edu.ntu.wedding.ActiveWedding"%>
<%
DatabaseConnection db = DatabaseConnection.getInstance();
%>

<script language="JavaScript" src="js/menu.js"></script>
<script language="JavaScript" src="js/menu_tpl.js"></script>

<script language="JavaScript">
<!--//
var MENU_ITEMS = [
['Home Page','./?module=main', {'tw' : '_parent'},]
,['Manage Weddings','./?module=weddings', {'tw' : '_parent'},]

<% if (ActiveWedding.getActiveWedding(db, session) != null) { %>

,['Overview','./?module=overview', {'tw' : '_parent'},]
,['Add / Import Guests','./?module=add', {'tw' : '_parent'},]
,['Guest List','./?module=guestlist', {'tw' : '_parent'},]
,['Table Assignments','./?module=assign', {'tw' : '_parent'},]
,['Auto Assignments (tm)','./?module=auto', {'tw' : '_parent'},]
,['Guest Attendance','./?module=attendance', {'tw' : '_parent'},]

<% } %>

];
new menu (MENU_ITEMS, MENU_POS);
//-->
</script>
