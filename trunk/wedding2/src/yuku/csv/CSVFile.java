package yuku.csv;


import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.Scanner;
import java.util.Vector;

public class CSVFile {
    public static Vector<Vector<String>> read(File file) throws IOException {
        return read(new InputStreamReader(new FileInputStream(file), "utf8"));
    }
    
    public static Vector<Vector<String>> read(InputStream is) throws IOException {
        return read(new InputStreamReader(is, "utf8"));
    }
    
	public static Vector<Vector<String>> read(InputStreamReader in) throws IOException {
        Vector<Vector<String>> ret = new Vector<Vector<String>>();
        Vector<String> line = new Vector<String>();

        String item = "";
        int begin = 1;

        while (true) {
            int kar = in.read();
            if (kar < 0) break;
            
            if (kar == ',') {
                line.add(item);
                item = "";
                begin = 1;
            } else if (kar == '\r') { // optional \r
            } else if (kar == '\n') {
                line.add(item);
                item = "";
                begin = 1;
                ret.add(line);
                line = new Vector<String>();
            } else if (kar == '"') {
                if (item.length() > 0 || begin == 0) {
                    item += '"';
                }
                while (true) {
                    kar = in.read();
                    if (kar < 0) break;
                    begin = 0;
                    if (kar == '"') {
                        break;
                    } else {
                        item += (char)kar;
                    }
                }
            } else {
                item += (char)kar;
                begin = 0;
            }
        }
        in.close();
        return ret;
    }

	/**
	 * test
	 * @param args
	 * @throws Exception
	 */
	public static void main(String[] args) throws Exception {
		System.out.print("tulis nama file csv: ");
		Vector<Vector<String>> hs = read(new File(new Scanner(System.in).nextLine()));
		for (Vector<String> baris : hs) {
			System.out.println("-----BARIS BARU-------");
			for (String sel : baris) {
				System.out.println("sel: " + sel);
			}
		}
	}

}
