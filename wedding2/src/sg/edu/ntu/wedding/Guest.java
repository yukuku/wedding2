package sg.edu.ntu.wedding;

import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;

public class Guest {
	private String name;
	private int tableNumber;
	private String category;
	private String invitedBy;
	private int attended;
	private int guestTotal;
	private int guestVeg;
	private int guestMus;
	private int id;
	private int weddingID;
	
	public Guest() {
	}

    public Guest(ResultSet rs) throws SQLException {
        name = rs.getString("name");
        tableNumber = rs.getInt("tableNumber");
        category = rs.getString("category");
        invitedBy = rs.getString("invitedBy");
        attended = rs.getInt("attended");
        guestTotal = rs.getInt("guestTotal");
        guestVeg = rs.getInt("guestVeg");
        guestMus = rs.getInt("guestMus");
        id = rs.getInt("id");
        weddingID=rs.getInt("weddingID");
    }

    public Guest(HttpServletRequest req) {
        name = req.getParameter("name");
        tableNumber = Parse.toInt(req.getParameter("tableNumber"));
        category = req.getParameter("category");
        invitedBy = req.getParameter("invitedBy");
        attended = Parse.toInt(req.getParameter("attended"));
        guestTotal = Parse.toInt(req.getParameter("guestTotal"));
        guestVeg = Parse.toInt(req.getParameter("guestVeg"));
        guestMus = Parse.toInt(req.getParameter("guestMus"));    
    }
    
    public int getId() {
    	return id;
    }
    
    public void setId(int id){
    	this.id = id;
    }

	public String getName() {
		return name;
	}

	public int getweddingID(){
		return weddingID;
	}
	
	public void setweddingID(int weddingID){
		this.weddingID = weddingID;
	}	
	
	public void setName(String name) {
		this.name = name;
	}

	public int getTableNumber() {
		return tableNumber;
	}

	public void setTableNumber(int tableNumber) {
		this.tableNumber = tableNumber;
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

	public int getAttended() {
		return attended;
	}

	public void setAttended(int attended) {
		this.attended = attended;
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
