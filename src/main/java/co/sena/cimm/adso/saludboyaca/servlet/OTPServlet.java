package co.sena.cimm.adso.saludboyaca.servlet;

import co.sena.cimm.adso.saludboyaca.dao.OTPTokenDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.Locale;
import java.util.ResourceBundle;

@WebServlet(name = "OTPServlet", urlPatterns = {"/otp"})
public class OTPServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        String email = (String) session.getAttribute("otpEmail");
        request.setAttribute("emailMasked", enmascararEmail(email));
        request.getRequestDispatcher("/views/otp_verificacion.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        String codigoIngresado = request.getParameter("otpCodigo");
        int idUsuario = (int) session.getAttribute("usuarioId");

        OTPTokenDAO otpDAO = new OTPTokenDAO();

        if (otpDAO.validar(idUsuario, codigoIngresado)) {
            // ✅ OTP correcto
            otpDAO.marcarUsado(idUsuario, codigoIngresado);
            session.setAttribute("otpVerificado", true);
            response.sendRedirect(request.getContextPath() + "/dashboard");
        } else {
            // ❌ OTP incorrecto o expirado
            String lang = (String) session.getAttribute("lang");
            if (lang == null) lang = "es";
            ResourceBundle rb = ResourceBundle.getBundle("messages", new Locale(lang));
            request.setAttribute("error", rb.getString("otp.error"));
            String email = (String) session.getAttribute("otpEmail");
            request.setAttribute("emailMasked", enmascararEmail(email));
            request.getRequestDispatcher("/views/otp_verificacion.jsp").forward(request, response);
        }
    }

    private String enmascararEmail(String email) {
        if (email == null || !email.contains("@")) return "***";
        String[] partes = email.split("@");
        String local = partes[0];
        String dominio = partes[1];
        if (local.length() <= 3) return local + "***@" + dominio;
        return local.substring(0, 3) + "***@" + dominio;
    }
}