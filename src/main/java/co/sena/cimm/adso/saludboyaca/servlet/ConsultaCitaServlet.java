package co.sena.cimm.adso.saludboyaca.servlet;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONObject;

import co.sena.cimm.adso.saludboyaca.dao.CitaDAO;
import co.sena.cimm.adso.saludboyaca.dto.Cita;
import co.sena.cimm.adso.saludboyaca.util.CaptchaGenerator;
import co.sena.cimm.adso.saludboyaca.util.PDFGenerator;

/**
 * Módulo de consulta pública — no requiere sesión autenticada.
 * Usa doble verificación: reCAPTCHA v2 + CAPTCHA visual.
 */
@WebServlet(name = "ConsultaCitaServlet", urlPatterns = {"/consulta-cita", "/captcha-imagen"})
public class ConsultaCitaServlet extends HttpServlet {

    // === CREDENCIALES reCAPTCHA ===
    private static final String SECRET_KEY = "6LcNrtgsAAAAAIrtuj_mlJZH9cBNCrzwtsqZgfon";
    private static final String RECAPTCHA_VERIFY_URL = "https://www.google.com/recaptcha/api/siteverify";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();

        // Endpoint que devuelve la imagen CAPTCHA visual
        if ("/captcha-imagen".equals(path)) {
            HttpSession session = request.getSession();
            String texto = CaptchaGenerator.generarTexto(session);
            response.setContentType("image/png");
            response.setHeader("Cache-Control", "no-store, no-cache, must-revalidate");
            try {
                CaptchaGenerator.generarImagen(texto, response.getOutputStream());
            } catch (Exception e) {
                System.err.println("Error generando CAPTCHA: " + e.getMessage());
            }
            return;
        }

        // Descarga de PDF
        String accion = request.getParameter("accion");
        if ("pdf".equals(accion)) {
            String idStr = request.getParameter("id");
            if (idStr != null) {
                CitaDAO dao = new CitaDAO();
                Cita cita = dao.buscarPorId(Integer.parseInt(idStr));
                if (cita != null) {
                    PDFGenerator.generarComprobante(cita, response);
                    return;
                }
            }
        }

        // GET normal → mostrar formulario de búsqueda
        CaptchaGenerator.generarTexto(request.getSession()); // generar nuevo captcha visual
        request.getRequestDispatcher("/views/consulta_cita.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();

        String documento = request.getParameter("documento");
        String recaptchaToken = request.getParameter("g-recaptcha-response");
        String captchaInput = request.getParameter("captcha");

        // ==============================================
        // PRIMERA VERIFICACIÓN: reCAPTCHA de Google
        // ==============================================
        if (recaptchaToken == null || recaptchaToken.isEmpty()) {
            CaptchaGenerator.generarTexto(session); // regenerar captcha visual
            request.setAttribute("errorRecaptcha", "Por favor completa la verificación reCAPTCHA.");
            request.setAttribute("documento", documento);
            request.getRequestDispatcher("/views/consulta_cita.jsp").forward(request, response);
            return;
        }

        if (!verificarRecaptcha(recaptchaToken)) {
            CaptchaGenerator.generarTexto(session); // regenerar captcha visual
            request.setAttribute("errorRecaptcha", "Verificación reCAPTCHA fallida. Por favor inténtalo de nuevo.");
            request.setAttribute("documento", documento);
            request.getRequestDispatcher("/views/consulta_cita.jsp").forward(request, response);
            return;
        }

        // ==============================================
        // SEGUNDA VERIFICACIÓN: CAPTCHA visual
        // ==============================================
        if (!CaptchaGenerator.esValido(captchaInput, session)) {
            CaptchaGenerator.generarTexto(session); // regenerar para próxima vez
            request.setAttribute("errorCaptcha", "Código de verificación incorrecto. Inténtalo de nuevo.");
            request.setAttribute("documento", documento);
            request.getRequestDispatcher("/views/consulta_cita.jsp").forward(request, response);
            return;
        }

        // ==============================================
        // AMBAS VERIFICACIONES EXITOSAS → proceder con la consulta
        // ==============================================
        CitaDAO citaDAO = new CitaDAO();
        List<Cita> citas = citaDAO.listarPorDocumentoPaciente(documento);
        request.setAttribute("citas", citas);
        request.setAttribute("documento", documento);
        
        // Regenerar captcha visual para próxima consulta
        CaptchaGenerator.generarTexto(session);
        request.getRequestDispatcher("/views/consulta_cita.jsp").forward(request, response);
    }

    /**
     * Verifica el token reCAPTCHA contra la API de Google.
     */
    private boolean verificarRecaptcha(String token) {
        try {
            URL url = new URL(RECAPTCHA_VERIFY_URL);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setDoOutput(true);
            conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");

            String params = "secret=" + SECRET_KEY + "&response=" + token;
            try (OutputStream os = conn.getOutputStream()) {
                os.write(params.getBytes(StandardCharsets.UTF_8));
            }

            StringBuilder response = new StringBuilder();
            try (BufferedReader br = new BufferedReader(
                    new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8))) {
                String line;
                while ((line = br.readLine()) != null) {
                    response.append(line);
                }
            }

            JSONObject json = new JSONObject(response.toString());
            return json.getBoolean("success");

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}