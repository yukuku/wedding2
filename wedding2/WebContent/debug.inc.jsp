
<%@page import="java.util.Enumeration"%>

<h1>Variables</h1>

<h2>Application</h2>
<ul>
<% {
	Enumeration<String> e = application.getAttributeNames();
	while (e.hasMoreElements()) {
		String k = e.nextElement();
		Object v = application.getAttribute(k);
		out.println("<li>" + k + " = " + v + "</li>");
	}
} %>
</ul>

<h2>Session</h2>
<ul>
<% {
	Enumeration<String> e = session.getAttributeNames();
	while (e.hasMoreElements()) {
		String k = e.nextElement();
		Object v = session.getAttribute(k);
		out.println("<li>" + k + " = " + v + "</li>");
	}
} %>
</ul>

<h2>Request</h2>
<ul>
<% {
	Enumeration<String> e = request.getParameterNames();
	while (e.hasMoreElements()) {
		String k = e.nextElement();
		out.println("<li>" + k + " = ");
		String[] vv = request.getParameterValues(k);
		for (String v: vv) {
			out.println(v);
		}
		out.println("</li>");
	}
} %>
</ul>
