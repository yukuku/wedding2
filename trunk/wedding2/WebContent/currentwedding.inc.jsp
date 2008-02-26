<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="sg.edu.ntu.wedding.DatabaseConnection"%>
<%@page import="sg.edu.ntu.wedding.ActiveWedding"%>
<%@page import="sg.edu.ntu.wedding.Wedding"%>
<%
{
DatabaseConnection dba = DatabaseConnection.getInstance();
Wedding wd = ActiveWedding.getActiveWedding(dba, session);
%>
<span>Active wedding: <%=wd.getBrideName() %> and <%=wd.getGroomName() %> on <%=wd.getDate() %> @ <%= wd.getHotelName() %></span>
<%
}
%>