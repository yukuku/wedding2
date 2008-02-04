package sg.edu.ntu.wedding;

import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;

public class Guest {
	private String name;
	private boolean allocated;
	private int tableID;
	private String category;
	private String invitedBy;
	private String status;
	private int guestTotal;
	private int guestVeg;
	private int guestMus;

	public Guest() {
	}

    public Guest(ResultSet rs) throws SQLException {
        rs.next();
        name = rs.getString("name");
        allocated = rs.getBoolean("allocated");
        tableID = rs.getInt("tableID");
        category = rs.getString("category");
        invitedBy = rs.getString("invitedBy");
        status = rs.getString("status");
        guestTotal = rs.getInt("guestTotal");
        guestVeg = rs.getInt("guestVeg");
        guestMus = rs.getInt("guestMus");
    }

    public Guest(HttpServletRequest req) {
        name = req.getParameter("name");
        allocated = Parse.toBoolean(req.getParameter("allocated"));
        tableID = Parse.toInt(req.getParameter("tableID"));
        category = req.getParameter("category");
        invitedBy = req.getParameter("invitedBy");
        status = req.getParameter("status");
        guestTotal = Parse.toInt(req.getParameter("guestTotal"));
        guestVeg = Parse.toInt(req.getParameter("guestVeg"));
        guestMus = Parse.toInt(req.getParameter("guestMus"));    
    }

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public boolean isAllocated() {
		return allocated;
	}

	public void setAllocated(boolean allocated) {
		this.allocated = allocated;
	}

	public int getTableID() {
		return tableID;
	}

	public void setTableID(int tableID) {
		this.tableID = tableID;
	}

	public String getCategory() {
		return category;
	}

	public void setCategory(String category) {
		this.category = category;
	}

	public String getInvitedBy() {
		return invitedBy;
	}

	public void setInvitedBy(String invitedBy) {
		this.invitedBy = invitedBy;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public int getGuestTotal() {
		return guestTotal;
	}

	public void setGuestTotal(int guestTotal) {
		this.guestTotal = guestTotal;
	}

	public int getGuestVeg() {
		return guestVeg;
	}

	public void setGuestVeg(int guestVeg) {
		this.guestVeg = guestVeg;
	}

	public int getGuestMus() {
		return guestMus;
	}

	public void setGuestMus(int guestMus) {
		this.guestMus = guestMus;
	}
    
    
}
