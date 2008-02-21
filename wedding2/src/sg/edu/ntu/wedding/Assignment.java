package sg.edu.ntu.wedding;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Vector;

public class Assignment {
	public static Vector<Table> getPossibleAssignment(DatabaseConnection db, Wedding w, Guest g) throws SQLException {
		Vector<Table> ret = new Vector<Table>();
		
		ResultSet rs = db.select("select * from IP_TABLE where weddingID=?", w.getId());
		while(rs.next()) {
			Table t = new Table(rs);
			t.detectType(db, w);
			
			// put logic of veg and mus here
			if (false) {
				continue;
			}
			
			if (t.getVacancy() >= g.getGuestTotal()) {
				ret.add(t);
			} else if (t.getNumber() == g.getTableNumber()) {
				// self table. must be available
				ret.add(t);
			}
		}
		return ret;
	}
	
	public static boolean assign(DatabaseConnection db, Wedding w, Guest g, Table t) throws SQLException {
		if (g.getTableNumber() == t.getNumber()) {
			// already assigned
			return true;
		}
		unassign(db, w, g);
		
		synchronized (db) {
			ResultSet rs = db.select("select * from IP_TABLE where weddingID=? and number=?", w.getId(), t.getNumber());
			rs.next();
			int vacancy = rs.getInt("vacancy");
			if (g.getGuestTotal() > vacancy) return false;
			db.execute("update IP_GUEST set tableNumber=? where id=?", t.getNumber(), g.getId());
			db.execute("update IP_TABLE set vacancy=vacancy-? where weddingID=? and number=?", g.getGuestTotal(), w.getId(), t.getNumber());
			g.setTableNumber(t.getNumber());
			t.setVacancy(t.getVacancy() - g.getGuestTotal());
			t.detectType(db, w);
		}
		
		return true;
	}

	public static void unassign(DatabaseConnection db, Wedding w, Guest g) {
		if (g.getTableNumber() == 0) return;
		synchronized (db) {
			db.execute("update IP_GUEST set tableNumber=0 where id=?", g.getId());
			db.execute("update IP_TABLE set vacancy=vacancy+? where weddingID=? and number=?", g.getGuestTotal(), w.getId(), g.getTableNumber());
			g.setTableNumber(0);
		}
	}
}
