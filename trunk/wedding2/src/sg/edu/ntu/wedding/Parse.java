package sg.edu.ntu.wedding;

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

}
