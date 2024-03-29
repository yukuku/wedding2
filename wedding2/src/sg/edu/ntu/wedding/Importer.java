package sg.edu.ntu.wedding;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.Scanner;
import java.util.Vector;

import yuku.csv.CSVFile;

// Version 2 Of Importer
public class Importer {
	
	private static boolean blnValidation;
	private static DatabaseConnection dbcConnection = new DatabaseConnection();
	
	public static int processFile(int intWeddingId, InputStreamReader strFileName, int intAutoAssign, Wedding wWedding) throws Exception {

		// Vector<Vector<String>> vFileContents = CSVFile.read(new File(new Scanner(strFileName).nextLine()));
	    Vector<Vector<String>> vFileContents = CSVFile.read(strFileName);
	    if (vFileContents.isEmpty() == true)
	    	return -10;
	    
		for (Vector<String> vFileContent : vFileContents) {
			if (vFileContent.size() == 6) {
				// Validate File Name
				String strName = vFileContent.elementAt(0).trim();
				if (strName.length() == 0 || strName.length() > 80)
					return -1;
				
				// Validate Category
				String strCategory = vFileContent.elementAt(1).trim();
				if (strCategory.compareTo("relative") != 0 && strCategory.compareTo("collague") != 0 && strCategory.compareTo("friend") != 0)
					return -2;
				
				// Validate InvitedBy
				String strInvitedBy = vFileContent.elementAt(2).trim();
				if (strInvitedBy.compareTo("groom") != 0 && strInvitedBy.compareTo("bride") != 0 && strInvitedBy.compareTo("both") != 0)
					return -3;

				// Validate Guest Total
				String strGuestTotal = vFileContent.elementAt(3).trim();
				if (validateNumber(strGuestTotal) == false)
					return -4;
				    
				// Validate Guest Vegetarian
				String strGuestVegetarian = vFileContent.elementAt(4).trim();
				if (validateNumber(strGuestVegetarian) == false)
					return -5;
				
				// Validate Guest Muslim
				String strGuestMuslim = vFileContent.elementAt(5).trim();
				if (validateNumber(strGuestMuslim) == false)
					return -6;
				
				// Validate that Guest Total is always more or at least equal to the sum
				// of Guest Vegetarian and Guest Muslim
				int intGuestTotal = new Integer(strGuestTotal);
				int intGuestVegetarian = new Integer(strGuestVegetarian);
				int intGuestMuslim = new Integer (strGuestMuslim);
				
				if (intGuestTotal < (intGuestVegetarian + intGuestMuslim))
					return -7;
			}
			else {
				return -8;
			}
		}	
		if (intAutoAssign == 1) {
			int intAutoAssignResult;
			boolean blnAutoAssignNotComplete = false;
			// Prepare for Import only if all rows are validated correctly
			for (Vector<String> vFileContent : vFileContents) {
				int intGuestId = dbcConnection.insert("Insert Into IP_GUEST (weddingID, name, category, invitedBy, guestTotal, guestVeg, guestMus) values (?, ?, ?, ?, ?, ?, ?)", 
				intWeddingId, vFileContent.elementAt(0).trim(), vFileContent.elementAt(1).trim(), vFileContent.elementAt(2).trim(), vFileContent.elementAt(3).trim(), vFileContent.elementAt(4).trim(), vFileContent.elementAt(5).trim());
				if (intAutoAssign == 1) {
					intAutoAssignResult = AutoAssign.AutoAssignSingleGuest(intGuestId, wWedding.getId(), Integer.parseInt(vFileContent.elementAt(3).trim()), Integer.parseInt(vFileContent.elementAt(4).trim()), Integer.parseInt(vFileContent.elementAt(5).trim()), wWedding);	
					if (intAutoAssignResult < 1)
						blnAutoAssignNotComplete = true;
				}
			}
			if (blnAutoAssignNotComplete == false)
				return 1;
			else
				return 2;
		}
		else {
			for (Vector<String> vFileContent : vFileContents) {
				int intGuestId = dbcConnection.insert("Insert Into IP_GUEST (weddingID, name, category, invitedBy, guestTotal, guestVeg, guestMus) values (?, ?, ?, ?, ?, ?, ?)", 
				intWeddingId, vFileContent.elementAt(0).trim(), vFileContent.elementAt(1).trim(), vFileContent.elementAt(2).trim(), vFileContent.elementAt(3).trim(), vFileContent.elementAt(4).trim(), vFileContent.elementAt(5).trim());
			}	
			return 1;
		}

	}
	
	private static boolean validateNumber (String strVariable) {
		strVariable = strVariable.trim();
		if (strVariable != "") {
			for (int intCounter=0; intCounter < strVariable.length(); intCounter++) {
				char chrHolder = strVariable.charAt(intCounter);
				if (chrHolder < '0' || chrHolder > '9')
					return false;
			}
			Integer intAllocated = new Integer(strVariable);
			if (intAllocated.intValue() < 0 || intAllocated.intValue() > 10)
				return false;
			
			return true;
		} 
		
		return false;
	}
	
	public static void main (String[] args) throws Exception {
		System.out.println("Processing");
		if (args.length <= 0) {
			System.out.println("Please supply parameters");
		}
		else {
			// Importer.processFile(5, args[0]);
		}
	}
}