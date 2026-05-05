package co.sena.cimm.adso.saludboyaca.servlet;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import co.sena.cimm.adso.saludboyaca.dao.PacienteDAO;
import co.sena.cimm.adso.saludboyaca.dto.Paciente;

@WebServlet(name = "PacienteServlet", urlPatterns = {"/pacientes"})
public class PacienteServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String accion = request.getParameter("accion");
        if (accion == null) accion = "listar";

        PacienteDAO dao = new PacienteDAO();

        switch (accion) {
            case "listar":
                try {
                    List<Paciente> lista = dao.listarTodos();
                    
                    // DEBUG
                    System.out.println("========================================");
                    System.out.println("[PacienteServlet] Total pacientes: " + lista.size());
                    for (Paciente p : lista) {
                        System.out.println("  -> ID: " + p.getId() + 
                                         " | Nombre: " + p.getNombres() + " " + p.getApellidos() + 
                                         " | Documento: " + p.getDocumento());
                    }
                    System.out.println("========================================");
                    
                    request.setAttribute("pacientes", lista);
                    request.setAttribute("totalPacientes", lista.size());
                    request.setAttribute("pacientesActivos", lista.size());
                    request.setAttribute("nuevosHoy", 3);
                    request.setAttribute("pendientes", 2);
                    
                } catch (Exception e) {
                    System.err.println("[PacienteServlet] ERROR: " + e.getMessage());
                    e.printStackTrace();
                    request.setAttribute("pacientes", java.util.Collections.emptyList());
                    request.setAttribute("totalPacientes", 0);
                    request.setAttribute("pacientesActivos", 0);
                    request.setAttribute("nuevosHoy", 0);
                    request.setAttribute("pendientes", 0);
                    request.setAttribute("errorBD", "Error de conexión: " + e.getMessage());
                }
                request.getRequestDispatcher("/views/pacientes/lista.jsp")
                       .forward(request, response);
                break;

            case "nuevo":
                request.getRequestDispatcher("/views/pacientes/formulario.jsp")
                       .forward(request, response);
                break;

            case "editar":
                try {
                    int idEditar = Integer.parseInt(request.getParameter("id"));
                    Paciente paciente = dao.buscarPorId(idEditar);
                    request.setAttribute("paciente", paciente);
                    request.getRequestDispatcher("/views/pacientes/formulario.jsp")
                           .forward(request, response);
                } catch (Exception e) {
                    response.sendRedirect(request.getContextPath() + "/pacientes");
                }
                break;

            case "eliminar":
                try {
                    int idEliminar = Integer.parseInt(request.getParameter("id"));
                    dao.eliminar(idEliminar);
                } catch (Exception e) {
                    System.err.println("[PacienteServlet] Error al eliminar: " + e.getMessage());
                }
                response.sendRedirect(request.getContextPath() + "/pacientes");
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/pacientes");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String accion = request.getParameter("accion");
        PacienteDAO dao = new PacienteDAO();

        Paciente p = new Paciente();
        p.setNombres(request.getParameter("nombres"));
        p.setApellidos(request.getParameter("apellidos"));
        p.setDocumento(request.getParameter("documento"));
        
        String fechaStr = request.getParameter("fechaNacimiento");
        if (fechaStr != null && !fechaStr.isEmpty()) {
            p.setFechaNacimiento(LocalDate.parse(fechaStr));
        }
        
        p.setTelefono(request.getParameter("telefono"));
        p.setEmail(request.getParameter("email"));
        p.setEps(request.getParameter("eps"));
        p.setVeredaBarrio(request.getParameter("veredaBarrio"));

        if ("insertar".equals(accion)) {
            dao.insertar(p);
        } else if ("actualizar".equals(accion)) {
            String idStr = request.getParameter("id");
            if (idStr != null && !idStr.isEmpty()) {
                p.setId(Integer.parseInt(idStr));
                dao.actualizar(p);
            }
        }

        response.sendRedirect(request.getContextPath() + "/pacientes");
    }
}