package sg.edu.ntu.wedding;

import java.io.IOException;

import javax.servlet.jsp.JspWriter;

public class Printer {
    JspWriter out;
    
    public Printer(JspWriter out) {
        this.out = out;
    }
    
    public void tr(Object... cells) throws IOException {
        out.println("<tr>");
        
        for (Object cell: cells) {
            out.println("<td>" + cell + "</td>");
        }
        
        out.println("</tr>");
    }
}
