package co.sena.cimm.adso.saludboyaca.servlet;

import co.sena.cimm.adso.saludboyaca.dao.HorarioDAO;
import co.sena.cimm.adso.saludboyaca.dao.UsuarioDAO;
import co.sena.cimm.adso.saludboyaca.dto.Horario;
import co.sena.cimm.adso.saludboyaca.dto.Usuario;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "HorarioServlet", urlPatterns = {"/horarios"})
public class HorarioServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        String rol     = (String) session.getAttribute("usuarioRol");
        int idUsuario  = (int)    session.getAttribute("usuarioId");

        HorarioDAO horarioDAO = new HorarioDAO();
        UsuarioDAO usuarioDAO = new UsuarioDAO();

        List<Horario> horarios;
        List<Usuario> medicos = usuarioDAO.listarMedicos();

        if ("MEDICO".equals(rol)) {
            // El médico ve solo su propio horario
            horarios = horarioDAO.listarPorMedico(idUsuario);
        } else {
            // RECEPCIONISTA / ENFERMERO ven todos
            String idMedicoParam = request.getParameter("idMedico");
            if (idMedicoParam != null && !idMedicoParam.isEmpty()) {
                horarios = horarioDAO.listarPorMedico(Integer.parseInt(idMedicoParam));
                request.setAttribute("medicoSeleccionado", Integer.parseInt(idMedicoParam));
            } else {
                horarios = horarioDAO.listarTodos();
            }
        }

        request.setAttribute("horarios", horarios);
        request.setAttribute("medicos",  medicos);
        request.getRequestDispatcher("/views/horarios/lista.jsp").forward(request, response);
    }
}