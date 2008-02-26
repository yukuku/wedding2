package sg.edu.ntu.wedding;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.sql.ResultSet;
import java.util.Scanner;
import java.util.Vector;

public class AutoAssign {
	private static boolean blnValidation;
	private static DatabaseConnection dbcConnection = new DatabaseConnection();
	
	public static int AutoAssignSingleGuest (int intGuestId, int intWeddingId, int intTotalGuests) throws Exception  {
		ResultSet rsWeddingTables = dbcConnection.select("Select * From IP_TABLE Where weddingID = ? And vacancy > 0 Order By vacancy, number", intWeddingId);
		
		if (rsWeddingTables.getFetchSize() > 0) {
			while(rsWeddingTables.next()) {
				if (rsWeddingTables.getInt("vacancy") >= intTotalGuests) {
					dbcConnection.execute("Update IP_GUEST Set tableNumber = ? Where id=?", rsWeddingTables.getInt("number"), intGuestId);
					dbcConnection.execute("Update IP_TABLE Set vacancy = vacancy - ? Where weddingID=? And number = ?", intTotalGuests, intWeddingId, rsWeddingTables.getInt("number"));
					// Return 1 if auto assignment for the current guest is successful
					return 1;
				}
			}
			// Return 3 if there are no tables with adequate vacancies
			return 3;
		}
		else {
			// Return 2 if there are no tables for the current wedding
			return 2;
		}
	}
	
	public static int AutoAssignAllGuests () {
		return 1;
	}
	
}