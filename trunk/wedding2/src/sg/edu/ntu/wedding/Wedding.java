package sg.edu.ntu.wedding;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.http.HttpServletRequest;

public class Wedding {
    private String brideName;
    private String groomName;
    private Date date;
    
    public Wedding() {
    }
    
    public Wedding(ResultSet rs) throws SQLException {
        brideName = rs.getString("brideName");
        groomName = rs.getString("groomName");
        date = rs.getDate("date");
    }

    public Wedding(HttpServletRequest req) throws ParseException {
        brideName = req.getParameter("brideName");
        groomName = req.getParameter("groomName");
        date = new SimpleDateFormat("yyyy-MM-dd").parse(req.getParameter("date"));
    }

    public String getBrideName() {
        return brideName;
    }

    public void setBrideName(String brideName) {
        this.brideName = brideName;
    }

    public String getGroomName() {
        return groomName;
    }

    public void setGroomName(String groomName) {
        this.groomName = groomName;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }    
}
