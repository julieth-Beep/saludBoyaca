package co.sena.cimm.adso.saludboyaca.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import co.sena.cimm.adso.saludboyaca.dto.Usuario;
import co.sena.cimm.adso.saludboyaca.model.Conexion;

@WebServlet("/chatbot")
public class ChatbotServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json;charset=UTF-8");
        response.setHeader("Cache-Control", "no-cache");
        response.setHeader("Access-Control-Allow-Origin", "*");

        PrintWriter out = response.getWriter();
        HttpSession session = request.getSession(false);
        Usuario usuario = (session != null) ? (Usuario) session.getAttribute("usuario") : null;

        String accion = request.getParameter("accion");
        if (accion == null) accion = "";

        try {
            switch (accion) {
                case "obtener_rol":
                    out.print(getRolUsuario(usuario));
                    break;
                case "stats_citas":
                    out.print(getStatsCitas(usuario));
                    break;
                case "citas_hoy":
                    out.print(getCitasHoy(usuario));
                    break;
                case "pacientes_recientes":
                    out.print(getPacientesRecientes(usuario));
                    break;
                default:
                    out.print("{\"success\":false,\"error\":\"Accion no reconocida\"}");
            }
        } catch (Exception e) {
            response.setStatus(500);
            out.print("{\"success\":false,\"error\":\"" + escJson(e.getMessage()) + "\"}");
        }
    }

    // ── ROL DEL USUARIO ──────────────────────────────────────────────────
    private String getRolUsuario(Usuario usuario) {
        if (usuario == null) {
            return "{\"rol\":\"invitado\",\"nombre\":\"\"}";
        }

        String rol = usuario.getRol() != null ? usuario.getRol().toLowerCase() : "invitado";
        String nombre = usuario.getNombres() != null && !usuario.getNombres().isEmpty()
                ? usuario.getNombres()
                : usuario.getUsername();

        // Normalizar rol a los 4 valores esperados
        switch (rol) {
            case "administrador": rol = "administrador"; break;
            case "medico":        rol = "medico";        break;
            case "recepcionista": rol = "recepcionista"; break;
            case "enfermero":     rol = "enfermero";     break;
            default:              rol = "invitado";
        }

        return "{\"rol\":\"" + rol + "\",\"nombre\":\"" + escJson(nombre) + "\"}";
    }

    // ── ESTADÍSTICAS DE CITAS (administrador y recepcionista) ────────────
    private String getStatsCitas(Usuario usuario) {
        if (usuario == null) return "{\"success\":false,\"error\":\"Acceso denegado\"}";
        String rol = usuario.getRol() != null ? usuario.getRol().toLowerCase() : "";
        if (!rol.equals("administrador") && !rol.equals("recepcionista")) {
            return "{\"success\":false,\"error\":\"Acceso denegado\"}";
        }
        try (Connection cn = Conexion.getConnection()) {

            long totalCitas = 0;
            try (PreparedStatement ps = cn.prepareStatement("SELECT COUNT(*) FROM citas");
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) totalCitas = rs.getLong(1);
            }

            long citasPendientes = 0;
            try (PreparedStatement ps = cn.prepareStatement("SELECT COUNT(*) FROM citas WHERE estado = 'PENDIENTE'");
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) citasPendientes = rs.getLong(1);
            }

            long citasHoy = 0;
            try (PreparedStatement ps = cn.prepareStatement("SELECT COUNT(*) FROM citas WHERE DATE(fecha_hora) = CURDATE()");
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) citasHoy = rs.getLong(1);
            }

            long totalPacientes = 0;
            try (PreparedStatement ps = cn.prepareStatement("SELECT COUNT(*) FROM pacientes");
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) totalPacientes = rs.getLong(1);
            }

            return "{\"success\":true"
                    + ",\"totalCitas\":"     + totalCitas
                    + ",\"pendientes\":"     + citasPendientes
                    + ",\"hoy\":"            + citasHoy
                    + ",\"totalPacientes\":" + totalPacientes
                    + "}";

        } catch (Exception e) {
            return "{\"success\":false,\"error\":\"" + escJson(e.getMessage()) + "\"}";
        }
    }

    // ── CITAS DE HOY detalladas (medico y enfermero) ─────────────────────
    private String getCitasHoy(Usuario usuario) {
        if (usuario == null) return "{\"success\":false,\"error\":\"Acceso denegado\"}";
        String rol = usuario.getRol() != null ? usuario.getRol().toLowerCase() : "";
        if (!rol.equals("medico") && !rol.equals("enfermero") && !rol.equals("administrador")) {
            return "{\"success\":false,\"error\":\"Acceso denegado\"}";
        }
        try (Connection cn = Conexion.getConnection()) {

            String sql = "SELECT c.id, p.nombre AS paciente, c.fecha_hora, c.estado, e.nombre AS especialidad "
                       + "FROM citas c "
                       + "JOIN pacientes p ON c.id_paciente = p.id "
                       + "LEFT JOIN especialidades e ON c.id_especialidad = e.id "
                       + "WHERE DATE(c.fecha_hora) = CURDATE() "
                       + "ORDER BY c.fecha_hora ASC LIMIT 5";

            StringBuilder lista = new StringBuilder("[");
            int cnt = 0;
            try (PreparedStatement ps = cn.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    if (cnt > 0) lista.append(",");
                    lista.append("{\"paciente\":\"").append(escJson(rs.getString("paciente"))).append("\"")
                         .append(",\"hora\":\"").append(escJson(rs.getString("fecha_hora"))).append("\"")
                         .append(",\"estado\":\"").append(escJson(rs.getString("estado"))).append("\"")
                         .append(",\"especialidad\":\"").append(escJson(rs.getString("especialidad"))).append("\"")
                         .append("}");
                    cnt++;
                }
            }
            lista.append("]");

            return "{\"success\":true,\"total\":" + cnt + ",\"citas\":" + lista + "}";

        } catch (Exception e) {
            return "{\"success\":false,\"error\":\"" + escJson(e.getMessage()) + "\"}";
        }
    }

    // ── ÚLTIMOS PACIENTES REGISTRADOS (administrador y recepcionista) ─────
    private String getPacientesRecientes(Usuario usuario) {
        if (usuario == null) return "{\"success\":false,\"error\":\"Acceso denegado\"}";
        String rol = usuario.getRol() != null ? usuario.getRol().toLowerCase() : "";
        if (!rol.equals("administrador") && !rol.equals("recepcionista")) {
            return "{\"success\":false,\"error\":\"Acceso denegado\"}";
        }
        try (Connection cn = Conexion.getConnection()) {

            StringBuilder lista = new StringBuilder("[");
            int cnt = 0;
            try (PreparedStatement ps = cn.prepareStatement(
                    "SELECT nombre, documento FROM pacientes ORDER BY id DESC LIMIT 5");
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    if (cnt > 0) lista.append(",");
                    lista.append("{\"nombre\":\"").append(escJson(rs.getString("nombre"))).append("\"")
                         .append(",\"documento\":\"").append(escJson(rs.getString("documento"))).append("\"")
                         .append("}");
                    cnt++;
                }
            }
            lista.append("]");

            return "{\"success\":true,\"pacientes\":" + lista + "}";

        } catch (Exception e) {
            return "{\"success\":false,\"error\":\"" + escJson(e.getMessage()) + "\"}";
        }
    }

    // ── UTILIDAD ─────────────────────────────────────────────────────────
    private String escJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }
}