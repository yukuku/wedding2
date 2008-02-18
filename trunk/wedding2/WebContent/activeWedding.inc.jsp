<%@page import="sg.edu.ntu.wedding.DatabaseConnection"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="sg.edu.ntu.wedding.Constant"%>
<%@page import="sg.edu.ntu.wedding.Wedding"%>
<%!
// active wedding
public Wedding getActiveWedding(DatabaseConnection db, HttpSession session) throws Exception {
	Integer id = (Integer)session.getAttribute(Constant.Session.activeWedding);
    if (id != null && id != 0) {
        ResultSet rs = db.select("select * from IP_WEDDING where id=?", id);
    	if (rs.next()) {
        	return new Wedding(rs);
    	} else {
    		return null;
    	}
    }
    return null;
}

%>