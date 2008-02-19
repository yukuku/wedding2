package sg.edu.ntu.wedding;

import java.io.*;
import java.util.*;
import yuku.csv.*;
import sg.edu.ntu.wedding.*;

// Version 2 Of Importer
public class Importer {
	
	private static int intGuestId = 1;
	private static boolean blnValidation;
	private static CSVFile csvParser = new CSVFile();
	private static DatabaseConnection dbcConnection = new DatabaseConnection();
	
	public static int processFile(int intWeddingId, String strFileName) throws Exception {
		Vector<Vector<String>> vFileContents = csvParser.read(new File(new Scanner(strFileName).nextLine()));

		blnValidation = false;
		
		for (Vector<String> vFileContent : vFileContents) {
			if (vFileContent.size() == 6) {
				// Validate File Name
				String strName = vFileContent.elementAt(0).trim();
				if (strName.length() == 0 || strName.length() > 80)
					break;
					
				// Validate Allocated
				/*
				String strAllocated = vFileContent.elementAt(1).trim();
				if (strAllocated != "") {
					for (int intCounter=0; intCounter < strAllocated.length(); intCounter++) {
						char chrHolder = strAllocated.charAt(intCounter);
						if (chrHolder < '0' || chrHolder > '9')
							break;
					}
					Integer intAllocated = new Integer(strAllocated);
					if (intAllocated.intValue() < 1 || intAllocated.intValue() > 10)
						break;
				} 
				else
					break;
				*/
				
				// Validate Category
				String strCategory = vFileContent.elementAt(1).trim();
				if (strCategory.compareTo("relative") != 0 && strCategory.compareTo("colleague") != 0 && strCategory.compareTo("friend") != 0)
					break;
				
				// Validate InvitedBy
				String strInvitedBy = vFileContent.elementAt(2).trim();
				if (strInvitedBy.compareTo("groom") != 0 && strInvitedBy.compareTo("bride") != 0 && strInvitedBy.compareTo("both") != 0)
					break;

				// Validate Guest Total
				String strGuestTotal = vFileContent.elementAt(3).trim();
				if (validateNumber(strGuestTotal) == false)
					break;
				
				// Validate Guest Vegetarian
				String strGuestVegetarian = vFileContent.elementAt(4).trim();
				if (validateNumber(strGuestVegetarian) == false)
					break;
				
				// Validate Guest Muslim
				String strGuestMuslim = vFileContent.elementAt(5).trim();
				if (validateNumber(strGuestMuslim) == false)
					break;
				
				// Validate that Guest Total is always more or at least equal to the sum
				// of Guest Vegetarian and Guest Muslim
				Integer intGuestTotal = new Integer(strGuestTotal);
				Integer intGuestVegetarian = new Integer(strGuestVegetarian);
				Integer intGuestMuslim = new Integer (strGuestMuslim);
				
				if (intGuestTotal.intValue() < (intGuestVegetarian.intValue() + intGuestMuslim.intValue()))
					break;
			}
			else {
				break;
			}
			blnValidation = true;
		}		
		
		if (blnValidation) {
			// Prepare for Import only if all rows are validated correctly
			for (Vector<String> vFileContent : vFileContents) {
				dbcConnection.insert("Insert Into IP_Guest (weddingID, name, allocated, category, invitedBy, guestTotal, guestVeg, guestMus) values (?, ?, ?, ?, ?, ?, ?, ?)", 
				vFileContent);
			}
			return 1;
		}
		else {
			return 0;
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
		Importer.processFile(1, args[0]);
	}
}