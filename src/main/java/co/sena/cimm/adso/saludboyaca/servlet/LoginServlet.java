package co.sena.cimm.adso.saludboyaca.servlet;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.Locale;
import java.util.ResourceBundle;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import co.sena.cimm.adso.saludboyaca.dao.OTPTokenDAO;
import co.sena.cimm.adso.saludboyaca.dao.UsuarioDAO;
import co.sena.cimm.adso.saludboyaca.dto.Usuario;
import co.sena.cimm.adso.saludboyaca.util.OTPService;

@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/views/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        UsuarioDAO usuarioDAO = new UsuarioDAO();
        Usuario usuario = usuarioDAO.validarLogin(username, password);

        if (usuario != null) {
            // ① Generar código OTP
            String otp = OTPService.generarOTP();
            LocalDateTime expiraEn = LocalDateTime.now().plusMinutes(5);

            // ② Guardar OTP en la BD
            OTPTokenDAO otpDAO = new OTPTokenDAO();
            otpDAO.insertar(usuario.getId(), otp, expiraEn);

            // ③ Guardar datos en sesión
            HttpSession session = request.getSession();
            session.setAttribute("usuario", usuario);
            session.setAttribute("usuarioId", usuario.getId());
            session.setAttribute("usuarioNombre", usuario.getNombreCompleto());
            session.setAttribute("usuarioRol", usuario.getRol());
            session.setAttribute("otpEmail", usuario.getEmail());
            session.setAttribute("otpVerificado", false);

            // ④ Obtener textos del idioma actual
            String lang = (String) session.getAttribute("lang");
            if (lang == null) lang = "es";
            ResourceBundle rb = ResourceBundle.getBundle("messages", new Locale(lang));
            String asunto = rb.getString("otp.email.asunto");
            String cuerpo = java.text.MessageFormat.format(
                rb.getString("otp.email.cuerpo"), otp);

            // ⑤ Enviar OTP por correo
            try {
                OTPService.enviarOTP(usuario.getEmail(), otp, asunto, cuerpo);
            } catch (Exception ex) {
                System.err.println("Error enviando OTP: " + ex.getMessage());
            }

            // ⑥ Redirigir a verificación OTP
            response.sendRedirect(request.getContextPath() + "/otp");

        } else {
            // Credenciales incorrectas
            String lang = (String) request.getSession().getAttribute("lang");
            if (lang == null) lang = "es";
            ResourceBundle rb = ResourceBundle.getBundle("messages", new Locale(lang));
            request.setAttribute("error", rb.getString("login.error.credenciales"));
            request.getRequestDispatcher("/views/login.jsp").forward(request, response);
        }
    }
}