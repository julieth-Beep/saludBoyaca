package co.sena.cimm.adso.saludboyaca.util;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.*;
import java.io.IOException;

@WebFilter("/*")
public class LocaleFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpSession session = req.getSession();

        // Si viene ?lang=xx en la URL, guardar en sesión
        String lang = req.getParameter("lang");

        if (lang != null) {
            // Solo idiomas válidos para SaludBoyacá
            if (lang.equals("es") || lang.equals("en") || lang.equals("it")) {
                session.setAttribute("lang", lang);
            }
        }

        // Si no hay idioma en sesión, usar español por defecto
        if (session.getAttribute("lang") == null) {
            session.setAttribute("lang", "es");
        }

        chain.doFilter(request, response);
    }

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void destroy() {}
}