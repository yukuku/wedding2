package sg.edu.ntu.wedding;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.sql.ResultSet;
import java.util.Scanner;
import java.util.Vector;

public class AutoAssign {
	private static boolean blnAssigned;
	private static DatabaseConnection dbcConnection = new DatabaseConnection();
	
	public static int AutoAssignSingleGuest (int intGuestId, int intWeddingId, int intTotalGuests, int intTotalVeg, int intTotalMus, Wedding wWedding) throws Exception  {
		Table.Type tblType;
		ResultSet rsWeddingTables = dbcConnection.select("Select * From IP_TABLE Where weddingID = ? And vacancy > 0 Order By vacancy, number", intWeddingId);
		if (rsWeddingTables.last() == true) {
			
			// Determine the type of table for the current guest
			if ((intTotalGuests > 0 && intTotalVeg > 0 && intTotalMus > 0) || (intTotalGuests > 0 && intTotalVeg == 0 && intTotalMus > 0) || (intTotalGuests > 0 && intTotalVeg > 0 && intTotalMus == 0)) {
				if (intTotalGuests == intTotalVeg)
					tblType = Table.Type.VEG;
				else if (intTotalGuests == intTotalMus)
					tblType = Table.Type.MUS;
				else
					tblType = Table.Type.MIXED;
			}
			else if (intTotalGuests ==0 && intTotalVeg > 0 && intTotalMus == 0)
				tblType = Table.Type.VEG;
			else
				tblType = Table.Type.MUS;
			
			rsWeddingTables.first();
			do  {
					Table tblTable = new Table(rsWeddingTables);
					tblTable.detectType(dbcConnection, wWedding);
					if ((tblTable.getType() == Table.Type.UNKNOWN || tblTable.getType() == tblType) && rsWeddingTables.getInt("vacancy") >= intTotalGuests) {
						dbcConnection.execute("Update IP_GUEST Set tableNumber = ? Where id=?", rsWeddingTables.getInt("number"), intGuestId);
						dbcConnection.execute("Update IP_TABLE Set vacancy = vacancy - ? Where weddingID=? And number = ?", intTotalGuests, intWeddingId, rsWeddingTables.getInt("number"));
						// Return 1 if auto assignment for the current guest is successful
						return rsWeddingTables.getInt("number");
					}
			}
			while(rsWeddingTables.next());
			// Return 3 if there are no tables with adequate vacancies or type
			return -3;
		}
		else
			return -2;
		
	}
	
	public static int AutoAssignAllGuests () {
		return 1;
	}
	
}