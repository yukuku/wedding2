package sg.edu.ntu.wedding;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

public class Parse {

	public static int toInt(String s) {
		try {
			return Integer.parseInt(s);
		} catch (NumberFormatException e) {
			return 0;
		}
	}

	public static boolean toBoolean(String s) {
		try {
			return Integer.parseInt(s) != 0;
		} catch (NumberFormatException e) {
			return Boolean.parseBoolean(s);
		}
	}

    public static Date toDate(String s) {
        try {
            return new SimpleDateFormat("yyyy-MM-dd").parse(s);
        } catch (ParseException e) {
            return null;
        }
    }

}
