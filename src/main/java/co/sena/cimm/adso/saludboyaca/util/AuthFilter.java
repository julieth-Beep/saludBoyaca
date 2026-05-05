package co.sena.cimm.adso.saludboyaca.util;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.*;
import java.io.IOException;

@WebFilter({"/dashboard", "/dashboard/*", "/pacientes", "/pacientes/*",
            "/citas", "/citas/*", "/horarios", "/horarios/*",
            "/usuarios", "/usuarios/*"})
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);

        // Verificar que hay sesión activa Y que el OTP fue verificado
        boolean isLoggedIn = (session != null
                && session.getAttribute("usuario") != null
                && Boolean.TRUE.equals(session.getAttribute("otpVerificado")));

        if (isLoggedIn) {
            // Tiene sesión válida con OTP → dejar pasar
            chain.doFilter(request, response);
        } else {
            // No tiene sesión o no verificó OTP → redirigir al login
            res.sendRedirect(req.getContextPath() + "/login");
        }
    }

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void destroy() {}
}