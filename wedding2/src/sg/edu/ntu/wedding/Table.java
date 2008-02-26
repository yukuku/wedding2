package sg.edu.ntu.wedding;

import java.sql.ResultSet;
import java.sql.SQLException;

public class Table {
	public enum Type {
		UNKNOWN, MIXED, MUS, VEG,
	};

	private int number;
	private int vacancy;
	private Type type = Type.UNKNOWN;

	public Table(ResultSet rs) throws SQLException {
		number = rs.getInt("number");
		vacancy = rs.getInt("vacancy");
	}
	
	public void detectType(DatabaseConnection db, Wedding w) throws SQLException {
		ResultSet rs = db.select("select * from IP_GUEST where weddingID=?", w.getId());
		boolean veg = false;
		boolean mus = false;
		while(rs.next()) {
			// every guest
			Guest g = new Guest(rs);
			if (g.getTableNumber() == number) {
				if (g.getGuestVeg() > 0) veg = true;
				if (g.getGuestMus() > 0) mus = true;
			}
		}
		if ((veg && mus) || (!veg && !mus)) {
			type = Type.MIXED;
		} else if (veg && !mus) {
			type = Type.VEG;
		} else if (!veg && mus) {
			type = Type.MUS;
		}
	}
	
	public int getNumber() {
		return number;
	}

	public void setNumber(int number) {
		this.number = number;
	}

	public int getVacancy() {
		return vacancy;
	}

	public void setVacancy(int vacancy) {
		this.vacancy = vacancy;
	}

	public Type getType() {
		return type;
	}

	public void setType(Type type) {
		this.type = type;
	}

}
