package co.sena.cimm.adso.saludboyaca.util;

import java.awt.Color;
import java.io.IOException;
import java.time.format.DateTimeFormatter;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

import com.lowagie.text.Chunk;
import com.lowagie.text.Document;
import com.lowagie.text.DocumentException;
import com.lowagie.text.Element;
import com.lowagie.text.Font;
import com.lowagie.text.PageSize;
import com.lowagie.text.Paragraph;
import com.lowagie.text.Phrase;
import com.lowagie.text.Rectangle;
import com.lowagie.text.pdf.PdfPCell;
import com.lowagie.text.pdf.PdfPTable;
import com.lowagie.text.pdf.PdfWriter;

import co.sena.cimm.adso.saludboyaca.dto.Cita;

/**
 * Genera comprobantes de cita en PDF usando iText 2.1.7 (com.lowagie).
 */
public class PDFGenerator {

    private static final Color COLOR_HEADER_TABLA = new Color(51, 65, 85);
    private static final Color COLOR_PRIMARIO = new Color(13, 148, 136);
    private static final Color COLOR_OSCURO = new Color(15, 118, 110);
    private static final Color COLOR_CLARO = new Color(204, 251, 241);
    private static final Color COLOR_TEXTO = new Color(15, 23, 42);
    private static final Color COLOR_MUTED = new Color(100, 116, 139);
    private static final DateTimeFormatter FMT_FECHA = DateTimeFormatter.ofPattern("dd/MM/yyyy");
    private static final DateTimeFormatter FMT_HORA = DateTimeFormatter.ofPattern("HH:mm");

    /**
     * Envía al cliente un PDF con el comprobante de cita.
     */
    public static void generarComprobante(Cita cita, HttpServletResponse response) throws IOException {
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition",
                "attachment; filename=\"comprobante_cita_" + cita.getId() + ".pdf\"");

        Document doc = new Document(PageSize.A4, 50, 50, 60, 50);
        try {
            PdfWriter writer = PdfWriter.getInstance(doc, response.getOutputStream());
            doc.open();

            // ── Fuentes
            Font fTitle = new Font(Font.HELVETICA, 22, Font.BOLD, COLOR_PRIMARIO);
            Font fHeader = new Font(Font.HELVETICA, 11, Font.BOLD, Color.WHITE);
            Font fLabel = new Font(Font.HELVETICA, 9, Font.BOLD, COLOR_MUTED);
            Font fValue = new Font(Font.HELVETICA, 11, Font.NORMAL, COLOR_TEXTO);
            Font fBold = new Font(Font.HELVETICA, 11, Font.BOLD, COLOR_TEXTO);
            Font fSmall = new Font(Font.HELVETICA, 8, Font.NORMAL, COLOR_MUTED);

            // ── Encabezado institucional
            PdfPTable header = new PdfPTable(1);
            header.setWidthPercentage(100);
            PdfPCell cellHeader = new PdfPCell();
            cellHeader.setBackgroundColor(COLOR_PRIMARIO);
            cellHeader.setPadding(18);
            cellHeader.setBorder(Rectangle.NO_BORDER);
            Paragraph titInst = new Paragraph("CENTRO DE SALUD MUNICIPAL DE PAIPA\n",
                    new Font(Font.HELVETICA, 14, Font.BOLD, Color.WHITE));
            titInst.add(new Phrase("Boyacá, Colombia  ·  Sistema SaludBoyacá\n",
                    new Font(Font.HELVETICA, 9, Font.NORMAL, new Color(204, 251, 241))));
            titInst.add(new Phrase("SENA · CIMM · ADSO · 2026",
                    new Font(Font.HELVETICA, 8, Font.ITALIC, new Color(153, 246, 228))));
            cellHeader.addElement(titInst);
            header.addCell(cellHeader);
            doc.add(header);

            doc.add(Chunk.NEWLINE);

            // ── Título comprobante
            Paragraph titulo = new Paragraph("COMPROBANTE DE CITA MÉDICA", fTitle);
            titulo.setAlignment(Element.ALIGN_CENTER);
            doc.add(titulo);
            doc.add(new Paragraph("N° " + cita.getId() + "  ·  "
                    + cita.getFechaCita().format(FMT_FECHA),
                    new Font(Font.HELVETICA, 10, Font.NORMAL, COLOR_MUTED)));
            doc.add(Chunk.NEWLINE);

            // ── Tabla principal
            PdfPTable tabla = new PdfPTable(2);
            tabla.setWidthPercentage(100);
            tabla.setWidths(new float[]{35f, 65f});
            tabla.setSpacingBefore(4);

            // Sección: Datos de la cita
            addSectionHeader(tabla, "INFORMACIÓN DE LA CITA", fHeader, COLOR_OSCURO);
            addRow(tabla, "Fecha", cita.getFechaCita().format(FMT_FECHA), fLabel, fValue);
            addRow(tabla, "Hora", cita.getHoraCita().format(FMT_HORA), fLabel, fBold);
            addRow(tabla, "Especialidad", cita.getEspecialidad().getNombre(), fLabel, fValue);
            addRow(tabla, "Estado", cita.getEstado(), fLabel, fValue);
            if (cita.getMotivo() != null && !cita.getMotivo().isEmpty()) {
                addRow(tabla, "Motivo", cita.getMotivo(), fLabel, fValue);
            }

            // Sección: Datos del paciente
            addSectionHeader(tabla, "DATOS DEL PACIENTE", fHeader, COLOR_OSCURO);
            addRow(tabla, "Nombre", cita.getPaciente().getNombres() + " " + cita.getPaciente().getApellidos(), fLabel, fBold);
            addRow(tabla, "Documento", cita.getPaciente().getDocumento(), fLabel, fValue);

            // Sección: Médico
            addSectionHeader(tabla, "MÉDICO ASIGNADO", fHeader, COLOR_OSCURO);
            addRow(tabla, "Médico",
                    "Dr. " + cita.getMedico().getNombres() + " " + cita.getMedico().getApellidos(), fLabel, fBold);
            addRow(tabla, "Especialidad", cita.getEspecialidad().getNombre(), fLabel, fValue);

            doc.add(tabla);
            doc.add(Chunk.NEWLINE);

            // ── Pie
            PdfPTable footer = new PdfPTable(1);
            footer.setWidthPercentage(100);
            PdfPCell cellFooter = new PdfPCell();
            cellFooter.setBackgroundColor(COLOR_CLARO);
            cellFooter.setPadding(12);
            cellFooter.setBorder(Rectangle.NO_BORDER);
            Paragraph pie = new Paragraph(
                    "Presente este comprobante el día de su cita.\n"
                    + "Para información y cancelaciones llame al 098-780-0000.\n"
                    + "Generado por SaludBoyacá — SENA · CIMM · Regional Boyacá · 2026",
                    fSmall);
            pie.setAlignment(Element.ALIGN_CENTER);
            cellFooter.addElement(pie);
            footer.addCell(cellFooter);
            doc.add(footer);

        } catch (DocumentException e) {
            throw new IOException("Error generando PDF: " + e.getMessage(), e);
        } finally {
            if (doc.isOpen()) {
                doc.close();
            }
        }
    }

    // ── Helpers
    private static void addSectionHeader(PdfPTable tabla, String texto, Font font, Color bg) {
        PdfPCell cell = new PdfPCell(new Phrase(texto, font));
        cell.setColspan(2);
        cell.setBackgroundColor(bg);
        cell.setPadding(9);
        cell.setBorder(Rectangle.NO_BORDER);
        tabla.addCell(cell);
    }

    private static void addRow(PdfPTable tabla, String label, String value, Font fLabel, Font fValue) {
        PdfPCell cLabel = new PdfPCell(new Phrase(label.toUpperCase(), fLabel));
        cLabel.setPadding(8);
        cLabel.setBackgroundColor(new Color(248, 250, 252));
        cLabel.setBorder(Rectangle.BOTTOM);
        cLabel.setBorderColor(new Color(226, 232, 240));
        tabla.addCell(cLabel);

        PdfPCell cValue = new PdfPCell(new Phrase(value != null ? value : "—", fValue));
        cValue.setPadding(8);
        cValue.setBorder(Rectangle.BOTTOM);
        cValue.setBorderColor(new Color(226, 232, 240));
        tabla.addCell(cValue);
    }

    /**
     * Genera un PDF con el listado completo de citas (para exportar todas)
     */
    public static void generarListadoCitas(List<Cita> citas, HttpServletResponse response) throws IOException {
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition",
                "attachment; filename=\"listado_citas_" + java.time.LocalDate.now() + ".pdf\"");

        Document doc = new Document(PageSize.A4.rotate(), 30, 30, 40, 40);
        try {
            PdfWriter.getInstance(doc, response.getOutputStream());
            doc.open();

            // ── Fuentes
            Font fTitle = new Font(Font.HELVETICA, 20, Font.BOLD, COLOR_PRIMARIO);
            Font fHeader = new Font(Font.HELVETICA, 9, Font.BOLD, Color.WHITE);
            Font fNormal = new Font(Font.HELVETICA, 9, Font.NORMAL, COLOR_TEXTO);
            Font fSmallBold = new Font(Font.HELVETICA, 8, Font.BOLD, COLOR_MUTED);
            Font fFooter = new Font(Font.HELVETICA, 7, Font.NORMAL, COLOR_MUTED);

            // ── Encabezado institucional
            PdfPTable header = new PdfPTable(1);
            header.setWidthPercentage(100);
            PdfPCell cellHeader = new PdfPCell();
            cellHeader.setBackgroundColor(COLOR_PRIMARIO);
            cellHeader.setPadding(12);
            cellHeader.setBorder(Rectangle.NO_BORDER);

            Paragraph titInst = new Paragraph("CENTRO DE SALUD MUNICIPAL DE PAIPA\n",
                    new Font(Font.HELVETICA, 14, Font.BOLD, Color.WHITE));
            titInst.add(new Phrase("Boyacá, Colombia · Sistema SaludBoyacá\n",
                    new Font(Font.HELVETICA, 8, Font.NORMAL, new Color(204, 251, 241))));
            cellHeader.addElement(titInst);
            header.addCell(cellHeader);
            doc.add(header);

            doc.add(Chunk.NEWLINE);

            // ── Título
            Paragraph title = new Paragraph("REPORTE DE CITAS MÉDICAS", fTitle);
            title.setAlignment(Element.ALIGN_CENTER);
            doc.add(title);

            Paragraph subtitle = new Paragraph("Generado: " + java.time.LocalDateTime.now().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss")),
                    fSmallBold);
            subtitle.setAlignment(Element.ALIGN_CENTER);
            doc.add(subtitle);
            doc.add(Chunk.NEWLINE);

            // ── Estadísticas
            long total = citas.size();
            long programadas = citas.stream().filter(c -> "PROGRAMADA".equals(c.getEstado())).count();
            long confirmadas = citas.stream().filter(c -> "CONFIRMADA".equals(c.getEstado())).count();
            long atendidas = citas.stream().filter(c -> "ATENDIDA".equals(c.getEstado())).count();
            long canceladas = citas.stream().filter(c -> "CANCELADA".equals(c.getEstado())).count();

            PdfPTable stats = new PdfPTable(4);
            stats.setWidthPercentage(100);
            stats.setWidths(new float[]{25f, 25f, 25f, 25f});

            addStatCell(stats, "📋 TOTAL", String.valueOf(total), COLOR_PRIMARIO);
            addStatCell(stats, "⏳ Programadas", String.valueOf(programadas), new Color(245, 158, 11));
            addStatCell(stats, "✅ Confirmadas", String.valueOf(confirmadas), new Color(16, 185, 129));
            addStatCell(stats, "✔️ Atendidas", String.valueOf(atendidas), new Color(59, 130, 246));

            doc.add(stats);
            doc.add(Chunk.NEWLINE);

            // ── Tabla de citas
            PdfPTable tabla = new PdfPTable(7);
            tabla.setWidthPercentage(100);
            tabla.setWidths(new float[]{12f, 12f, 18f, 15f, 15f, 13f, 15f});
            tabla.setHeaderRows(1);

            // Encabezados
            String[] headers = {"FECHA", "HORA", "PACIENTE", "DOCUMENTO", "MÉDICO", "ESPECIALIDAD", "ESTADO"};
            for (String h : headers) {
                PdfPCell cell = new PdfPCell(new Phrase(h, fHeader));
                cell.setBackgroundColor(COLOR_HEADER_TABLA);
                cell.setPadding(8);
                cell.setHorizontalAlignment(Element.ALIGN_CENTER);
                tabla.addCell(cell);
            }

            // Datos
            for (Cita c : citas) {
                addCell(tabla, c.getFechaCita().format(FMT_FECHA), fNormal);
                addCell(tabla, c.getHoraCita().format(FMT_HORA), fNormal);
                addCell(tabla, c.getPaciente().getNombres() + " " + c.getPaciente().getApellidos(), fNormal);
                addCell(tabla, c.getPaciente().getDocumento(), fNormal);
                addCell(tabla, "Dr. " + c.getMedico().getNombres() + " " + c.getMedico().getApellidos(), fNormal);
                addCell(tabla, c.getEspecialidad().getNombre(), fNormal);

                // Celda de estado con color
                PdfPCell estadoCell = new PdfPCell(new Phrase(getEstadoTexto(c.getEstado()), fNormal));
                estadoCell.setPadding(7);
                estadoCell.setHorizontalAlignment(Element.ALIGN_CENTER);

                switch (c.getEstado()) {
                    case "PROGRAMADA":
                        estadoCell.setBackgroundColor(new Color(254, 243, 199));
                        break;
                    case "CONFIRMADA":
                        estadoCell.setBackgroundColor(new Color(209, 250, 229));
                        break;
                    case "ATENDIDA":
                        estadoCell.setBackgroundColor(new Color(219, 234, 254));
                        break;
                    case "CANCELADA":
                        estadoCell.setBackgroundColor(new Color(254, 226, 226));
                        break;
                }
                tabla.addCell(estadoCell);
            }

            doc.add(tabla);
            doc.add(Chunk.NEWLINE);

            // ── Footer
            PdfPTable footer = new PdfPTable(1);
            footer.setWidthPercentage(100);
            PdfPCell cellFooter = new PdfPCell();
            cellFooter.setBackgroundColor(COLOR_CLARO);
            cellFooter.setPadding(10);
            cellFooter.setBorder(Rectangle.NO_BORDER);
            Paragraph pie = new Paragraph(
                    "Reporte generado por SaludBoyacá - Sistema de Gestión de Citas\n"
                    + "SENA · CIMM · Regional Boyacá · 2026",
                    fFooter);
            pie.setAlignment(Element.ALIGN_CENTER);
            cellFooter.addElement(pie);
            footer.addCell(cellFooter);
            doc.add(footer);

        } catch (DocumentException e) {
            throw new IOException("Error generando PDF: " + e.getMessage(), e);
        } finally {
            if (doc.isOpen()) {
                doc.close();
            }
        }
    }

// Métodos auxiliares
    private static void addStatCell(PdfPTable table, String label, String value, Color bgColor) {
        PdfPCell cell = new PdfPCell();
        cell.setBackgroundColor(new Color(bgColor.getRed(), bgColor.getGreen(), bgColor.getBlue(), 50));
        cell.setPadding(10);
        cell.setHorizontalAlignment(Element.ALIGN_CENTER);

        Paragraph p = new Paragraph();
        p.add(new Chunk(label + "\n", new Font(Font.HELVETICA, 8, Font.NORMAL, COLOR_MUTED)));
        p.add(new Chunk(value, new Font(Font.HELVETICA, 18, Font.BOLD, bgColor)));
        cell.addElement(p);
        table.addCell(cell);
    }

    private static void addCell(PdfPTable table, String text, Font font) {
        PdfPCell cell = new PdfPCell(new Phrase(text != null ? text : "—", font));
        cell.setPadding(6);
        cell.setBorderColor(new Color(226, 232, 240));
        table.addCell(cell);
    }

    private static String getEstadoTexto(String estado) {
        switch (estado) {
            case "PROGRAMADA":
                return "PROGRAMADA";
            case "CONFIRMADA":
                return "CONFIRMADA";
            case "ATENDIDA":
                return "ATENDIDA";
            case "CANCELADA":
                return "CANCELADA";
            default:
                return estado;
        }
    }
}
