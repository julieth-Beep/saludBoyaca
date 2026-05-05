package co.sena.cimm.adso.saludboyaca.servlet;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import co.sena.cimm.adso.saludboyaca.dao.CitaDAO;
import co.sena.cimm.adso.saludboyaca.dao.PacienteDAO;
import co.sena.cimm.adso.saludboyaca.dto.Cita;
import co.sena.cimm.adso.saludboyaca.dto.Usuario;

@WebServlet(name = "DashboardServlet", urlPatterns = {"/dashboard"})
public class DashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Usuario usuario = (Usuario) session.getAttribute("usuario");
        String rol = usuario.getRol();
        int idUsuario = usuario.getId();

        CitaDAO citaDAO = new CitaDAO();
        PacienteDAO pacDAO = new PacienteDAO();

        List<Cita> proximasCitas;
        int citasHoy, citasPendientes, citasMes;

        if ("MEDICO".equals(rol)) {
            // El médico ve solo sus propias estadísticas
            proximasCitas  = citaDAO.listarProximasPorMedico(idUsuario, 5);
            citasHoy       = citaDAO.contarHoyPorMedico(idUsuario);
            citasPendientes= citaDAO.contarPorEstadoYMedico("PROGRAMADA", idUsuario);
            citasMes       = citaDAO.contarMesPorMedico(idUsuario);
        } else {
            // RECEPCIONISTA y ENFERMERO ven estadísticas globales
            proximasCitas  = citaDAO.listarProximasHoy(5);
            citasHoy       = citaDAO.contarCitasHoy();
            citasPendientes= citaDAO.contarPorEstado("PROGRAMADA");
            citasMes       = citaDAO.contarCitasMes();
        }

        int totalPacientes = pacDAO.contarTotal();

        request.setAttribute("nombreUsuario",  usuario.getNombreCompleto());
        request.setAttribute("rolUsuario",     rol);
        request.setAttribute("proximasCitas",  proximasCitas);
        request.setAttribute("citasHoy",       citasHoy);
        request.setAttribute("citasPendientes",citasPendientes);
        request.setAttribute("citasMes",       citasMes);
        request.setAttribute("totalPacientes", totalPacientes);

        request.getRequestDispatcher("/views/dashboard.jsp").forward(request, response);
    }
}