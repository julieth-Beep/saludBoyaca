package co.sena.cimm.adso.saludboyaca.servlet;

import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import co.sena.cimm.adso.saludboyaca.dao.CitaDAO;
import co.sena.cimm.adso.saludboyaca.dao.EspecialidadDAO;
import co.sena.cimm.adso.saludboyaca.dao.PacienteDAO;
import co.sena.cimm.adso.saludboyaca.dao.UsuarioDAO;
import co.sena.cimm.adso.saludboyaca.dto.Cita;
import co.sena.cimm.adso.saludboyaca.dto.Especialidad;
import co.sena.cimm.adso.saludboyaca.dto.Paciente;
import co.sena.cimm.adso.saludboyaca.dto.Usuario;
import co.sena.cimm.adso.saludboyaca.util.PDFGenerator;

@WebServlet(name = "CitaServlet", urlPatterns = {"/citas"})
public class CitaServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String accion = request.getParameter("accion");
        if (accion == null) {
            accion = "listar";
        }

        CitaDAO citaDAO = new CitaDAO();
        HttpSession session = request.getSession();
        String rol = (String) session.getAttribute("usuarioRol");
        int idUsuario = (int) session.getAttribute("usuarioId");

        switch (accion) {

            case "listar":
                List<Cita> lista;
                if ("MEDICO".equals(rol)) {
                    lista = citaDAO.listarPorMedico(idUsuario);
                } else {
                    lista = citaDAO.listarTodas();
                }
                request.setAttribute("citas", lista);
                request.getRequestDispatcher("/views/citas/lista.jsp")
                        .forward(request, response);
                break;

            case "nuevo":
                if ("ENFERMERO".equals(rol)) {
                    response.sendRedirect(request.getContextPath() + "/citas");
                    return;
                }
                PacienteDAO pacDAO = new PacienteDAO();
                UsuarioDAO usuDAO = new UsuarioDAO();
                EspecialidadDAO espDAO = new EspecialidadDAO();
                request.setAttribute("pacientes", pacDAO.listarTodos());
                request.setAttribute("medicos", usuDAO.listarMedicos());
                request.setAttribute("especialidades", espDAO.listarTodas());
                request.setAttribute("hoy", LocalDate.now().toString());
                request.getRequestDispatcher("/views/citas/formulario.jsp")
                        .forward(request, response);
                break;

            case "detalle":
                int idDetalle = Integer.parseInt(request.getParameter("id"));
                Cita citaDetalle = citaDAO.buscarPorId(idDetalle);
                request.setAttribute("cita", citaDetalle);
                request.getRequestDispatcher("/views/citas/detalle.jsp")
                        .forward(request, response);
                break;

            case "cambiarEstado":
                if ("ENFERMERO".equals(rol)) {
                    response.sendRedirect(request.getContextPath() + "/citas");
                    return;
                }
                int idCambiar = Integer.parseInt(request.getParameter("id"));
                String nuevoEst = request.getParameter("estado");
                citaDAO.cambiarEstado(idCambiar, nuevoEst);
                response.sendRedirect(request.getContextPath() + "/citas");
                break;

            case "eliminar":
                if ("ENFERMERO".equals(rol)) {
                    response.sendRedirect(request.getContextPath() + "/citas");
                    return;
                }
                int idElim = Integer.parseInt(request.getParameter("id"));
                citaDAO.eliminar(idElim);
                response.sendRedirect(request.getContextPath() + "/citas");
                break;

            case "pdf":
                // Descarga comprobante individual
                int idPdf = Integer.parseInt(request.getParameter("id"));
                Cita citaPdf = citaDAO.buscarPorId(idPdf);
                if (citaPdf != null) {
                    PDFGenerator.generarComprobante(citaPdf, response);
                } else {
                    response.sendRedirect(request.getContextPath() + "/citas");
                }
                break;

            case "pdfHoy":
                // Descarga lista del día (MEDICO o RECEPCIONISTA)
                if ("ENFERMERO".equals(rol)) {
                    response.sendRedirect(request.getContextPath() + "/citas");
                    return;
                }
                List<Cita> citasHoy;
                if ("MEDICO".equals(rol)) {
                    citasHoy = citaDAO.listarProximasPorMedico(idUsuario, 100);
                } else {
                    citasHoy = citaDAO.listarProximasHoy(100);
                }
                generarPdfHoy(citasHoy, response);
                break;

            case "exportar":
                // Exportar listado completo con filtros
                if ("ENFERMERO".equals(rol)) {
                    response.sendRedirect(request.getContextPath() + "/citas");
                    return;
                }
                exportarListadoPDF(request, response);
                break;
                
            default:
                response.sendRedirect(request.getContextPath() + "/citas");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        String rol = (String) session.getAttribute("usuarioRol");
        int idUsuario = (int) session.getAttribute("usuarioId");

        if ("ENFERMERO".equals(rol)) {
            response.sendRedirect(request.getContextPath() + "/citas");
            return;
        }

        CitaDAO citaDAO = new CitaDAO();
        Cita cita = new Cita();

        Paciente p = new Paciente();
        p.setId(Integer.parseInt(request.getParameter("idPaciente")));
        cita.setPaciente(p);

        Usuario m = new Usuario();
        m.setId(Integer.parseInt(request.getParameter("idMedico")));
        cita.setMedico(m);

        Especialidad e = new Especialidad();
        e.setId(Integer.parseInt(request.getParameter("idEspecialidad")));
        cita.setEspecialidad(e);

        cita.setFechaCita(LocalDate.parse(request.getParameter("fechaCita")));
        cita.setHoraCita(LocalTime.parse(request.getParameter("horaCita")));
        cita.setMotivo(request.getParameter("motivo"));
        cita.setIdRegistradoPor(idUsuario);

        citaDAO.insertar(cita);
        response.sendRedirect(request.getContextPath() + "/citas");
    }

    // ── PDF de citas del día ────────────────────────────────────────
    private void generarPdfHoy(List<Cita> citas, HttpServletResponse response)
            throws IOException {
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition",
                "attachment; filename=\"citas_hoy_" + LocalDate.now() + ".pdf\"");

        com.lowagie.text.Document doc = new com.lowagie.text.Document(
                com.lowagie.text.PageSize.A4, 40, 40, 50, 40);
        try {
            com.lowagie.text.pdf.PdfWriter.getInstance(doc, response.getOutputStream());
            doc.open();

            com.lowagie.text.Font fTitle = new com.lowagie.text.Font(
                    com.lowagie.text.Font.HELVETICA, 16,
                    com.lowagie.text.Font.BOLD, new java.awt.Color(13, 148, 136));
            com.lowagie.text.Font fHead = new com.lowagie.text.Font(
                    com.lowagie.text.Font.HELVETICA, 9,
                    com.lowagie.text.Font.BOLD, java.awt.Color.WHITE);
            com.lowagie.text.Font fCell = new com.lowagie.text.Font(
                    com.lowagie.text.Font.HELVETICA, 9,
                    com.lowagie.text.Font.NORMAL, new java.awt.Color(15, 23, 42));

            com.lowagie.text.Paragraph titulo = new com.lowagie.text.Paragraph(
                    "CITAS DEL DÍA — " + LocalDate.now().format(
                            java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy")), fTitle);
            titulo.setAlignment(com.lowagie.text.Element.ALIGN_CENTER);
            doc.add(titulo);
            doc.add(com.lowagie.text.Chunk.NEWLINE);

            if (citas.isEmpty()) {
                doc.add(new com.lowagie.text.Paragraph("No hay citas programadas para hoy."));
            } else {
                com.lowagie.text.pdf.PdfPTable tabla
                        = new com.lowagie.text.pdf.PdfPTable(5);
                tabla.setWidthPercentage(100);
                tabla.setWidths(new float[]{12f, 28f, 22f, 22f, 16f});

                String[] headers = {"Hora", "Paciente", "Médico", "Especialidad", "Estado"};
                for (String h : headers) {
                    com.lowagie.text.pdf.PdfPCell cell
                            = new com.lowagie.text.pdf.PdfPCell(
                                    new com.lowagie.text.Phrase(h, fHead));
                    cell.setBackgroundColor(new java.awt.Color(13, 148, 136));
                    cell.setPadding(7);
                    cell.setBorder(com.lowagie.text.Rectangle.NO_BORDER);
                    tabla.addCell(cell);
                }
                for (Cita c : citas) {
                    String[] vals = {
                        c.getHoraCita().toString(),
                        c.getPaciente().getNombres() + " " + c.getPaciente().getApellidos(),
                        "Dr. " + c.getMedico().getNombres() + " " + c.getMedico().getApellidos(),
                        c.getEspecialidad().getNombre(),
                        c.getEstado()
                    };
                    for (String v : vals) {
                        com.lowagie.text.pdf.PdfPCell cell
                                = new com.lowagie.text.pdf.PdfPCell(
                                        new com.lowagie.text.Phrase(v, fCell));
                        cell.setPadding(6);
                        cell.setBorderColor(new java.awt.Color(226, 232, 240));
                        tabla.addCell(cell);
                    }
                }
                doc.add(tabla);
            }
        } catch (com.lowagie.text.DocumentException ex) {
            throw new IOException("Error generando PDF: " + ex.getMessage(), ex);
        } finally {
            if (doc.isOpen()) {
                doc.close();
            }
        }
    }

    /**
     * Exporta el listado completo de citas a PDF (con filtros)
     */
    private void exportarListadoPDF(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String rol = (String) session.getAttribute("usuarioRol");
        int idUsuario = (int) session.getAttribute("usuarioId");

        // Obtener filtros de la request
        String search = request.getParameter("search");
        String estado = request.getParameter("estado");
        String especialidad = request.getParameter("especialidad");
        String fecha = request.getParameter("fecha");

        CitaDAO citaDAO = new CitaDAO();
        List<Cita> citas;

        // Aplicar filtros según el rol
        if ("MEDICO".equals(rol)) {
            citas = citaDAO.listarPorMedicoConFiltros(idUsuario, search, estado, especialidad, fecha);
        } else {
            citas = citaDAO.listarTodasConFiltros(search, estado, especialidad, fecha);
        }

        if (citas == null || citas.isEmpty()) {
            response.setContentType("text/html;charset=UTF-8");
            response.getWriter().println("<script>alert('No hay citas para exportar'); window.history.back();</script>");
            return;
        }

        try {
            PDFGenerator.generarListadoCitas(citas, response);
        } catch (IOException e) {
            throw new ServletException("Error generando PDF", e);
        }
    }
}
