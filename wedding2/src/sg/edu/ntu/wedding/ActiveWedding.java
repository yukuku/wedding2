package sg.edu.ntu.wedding;

import java.sql.ResultSet;

import javax.servlet.http.HttpSession;
import javax.servlet.jsp.JspWriter;

public class ActiveWedding {
	public static Wedding getActiveWedding(DatabaseConnection db, HttpSession session) throws Exception {
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

	public static Wedding getAndCheckActiveWedding(DatabaseConnection db, HttpSession session, JspWriter out) throws Exception {
		Wedding w = getActiveWedding(db, session);
		if (w == null) {
			out.write("<div class='message'>The active wedding has not been selected. <a href='./?module=weddings'>Please select it first.</a></div>\n");
			return null;
		} else {
			return w;
		}
	}

}
