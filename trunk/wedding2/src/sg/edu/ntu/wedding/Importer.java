package sg.edu.ntu.wedding;

import java.io.*;
import java.util.*;
import yuku.csv.*;

// Version 1 Of Importer
public class Importer {
	
	private static boolean blnValidation;
	private static CSVFile csvParser = new CSVFile();
	
	public static int processFile(String strFileName) throws Exception {
		Vector<Vector<String>> vFileContents = csvParser.read(new File(new Scanner(strFileName).nextLine()));

		blnValidation = false;
		
		for (Vector<String> vFileContent : vFileContents) {
			if (vFileContent.size() == 5) {
				// Validate File Name
				String strName = vFileContent.elementAt(0).trim();
				if (strName.length() == 0 || strName.length() > 80)
					break;
					
				// Validate Allocated
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
				// Validate Category
				String strCategory = vFileContent.elementAt(2).trim();
				if (strCategory.compareTo("relative") != 0 && strCategory.compareTo("colleague") != 0 && strCategory.compareTo("friend") != 0)
					break;
				
				// Validate InvitedBy
				String strInvitedBy = vFileContent.elementAt(3).trim();
				if (strInvitedBy.compareTo("groom") != 0 && strInvitedBy.compareTo("bride") != 0 && strInvitedBy.compareTo("both") != 0)
					break;

				// Validate Status
				String strStatus = vFileContent.elementAt(4).trim();
				if (strStatus.compareTo("invited") != 0)
					break;
			}
			blnValidation = true;
		}		
		
		if (blnValidation) {
			// Prepare For Import
			return 1;
		}
		else {
			return 0;
		}
	}
	
	public static void main (String[] args) throws Exception {
		Importer.processFile(args[0]);
	}
}