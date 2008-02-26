package sg.edu.ntu.wedding;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.lowagie.text.Document;
import com.lowagie.text.DocumentException;
import com.lowagie.text.Paragraph;
import com.lowagie.text.pdf.PdfPCell;
import com.lowagie.text.pdf.PdfPTable;
import com.lowagie.text.pdf.PdfWriter;

/**
 * Servlet implementation class for Servlet: GuestList
 * 
 */
public class GuestList extends javax.servlet.http.HttpServlet implements
		javax.servlet.Servlet {
	static final long serialVersionUID = 20080222223801L;

	/*
	 * (non-Java-doc)
	 * 
	 * @see javax.servlet.http.HttpServlet#HttpServlet()
	 */
	public GuestList() {
		super();
	}

	/*
	 * (non-Java-doc)
	 * 
	 * @see javax.servlet.http.HttpServlet#doGet(HttpServletRequest request,
	 *      HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		String[] exportType = request.getServletPath().split("\\.");
		String et = exportType[exportType.length - 1];
		String weddingId = request.getParameter("id");

		DatabaseConnection db = DatabaseConnection.getInstance();

		if (weddingId != "" || weddingId != "0") {
			try {
				ResultSet rsWedding = db.select(Constant.Session.guestTableQry,
						weddingId);

				if (et.equalsIgnoreCase("xls")) {
					ExportXls(request, response, rsWedding);
				} else if (et.equalsIgnoreCase("pdf")) {
					ExportPdf(request, response, rsWedding);
				}

			} catch (SQLException ex) {
				PrintWriter out = response.getWriter();
				out.println("SQLException:" + ex.getErrorCode());
			}

		}
	}

	private void ExportXls(HttpServletRequest request,
			HttpServletResponse response, ResultSet rsWedding)
			throws ServletException, IOException, SQLException {
		PrintWriter out = response.getWriter();
		response.setContentType("application/vnd.ms-excel");
		response.setHeader("Content-Disposition",
				"Attachment; filename=GuestList.xls");
		out.println(Constant.Session.guestTableSqs.replace(',', '\t'));
		while (rsWedding.next() == true) {
			out.println(rsWedding.getString("NAME") + "\t"
					+ rsWedding.getString("INVITEDBY") + "\t"
					+ rsWedding.getString("tableNumber") + "\t"
					+ rsWedding.getString("GUESTTOTAL") + "\t"
					+ rsWedding.getString("GUESTVEG") + "\t"
					+ rsWedding.getString("GUESTMUS"));
		}
	}

	private void ExportPdf(HttpServletRequest request,
			HttpServletResponse response, ResultSet rsWedding)
			throws ServletException, IOException, SQLException {
		try {
			Document document = new Document();
			ByteArrayOutputStream baos = new ByteArrayOutputStream();
			PdfWriter.getInstance(document, baos);
			document.open();

			PdfPTable pdfPTable = new PdfPTable(6);
			PdfPCell pdfPCell = new PdfPCell(new Paragraph(
					"Guest List Export Table"));
			pdfPCell.setColspan(6);
			pdfPTable.addCell(pdfPCell);
			for (String header : Constant.Session.guestTableSqs.split(",")) {
				pdfPTable.addCell(header);
			}
			while (rsWedding.next() == true) {
				pdfPTable.addCell(rsWedding.getString("NAME"));
				pdfPTable.addCell(rsWedding.getString("INVITEDBY"));
				pdfPTable.addCell("0".equals(rsWedding.getString("tableNumber"))?"U.A.":rsWedding.getString("tableNumber"));
				pdfPTable.addCell(rsWedding.getString("GUESTTOTAL"));
				pdfPTable.addCell(rsWedding.getString("GUESTVEG"));
				pdfPTable.addCell(rsWedding.getString("GUESTMUS"));
			}

			document.add(pdfPTable);
			document.close();
			response.setContentType("application/pdf");
			response.setHeader("Content-Disposition",
					"Attachment; filename=GuestList.pdf");
			response.setContentLength(baos.size());
			ServletOutputStream out = response.getOutputStream();
			baos.writeTo(out);
			out.flush();

		} catch (DocumentException de) {
			PrintWriter out = response.getWriter();
			out.println("DocumentException:" + de.getMessage());
		} catch (IOException ioe) {
			PrintWriter out = response.getWriter();
			out.println("IOException:" + ioe.getMessage());
		}
	}

}