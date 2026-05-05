package co.sena.cimm.adso.saludboyaca.dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Time;
import java.util.ArrayList;
import java.util.List;

import co.sena.cimm.adso.saludboyaca.dto.Cita;
import co.sena.cimm.adso.saludboyaca.dto.Especialidad;
import co.sena.cimm.adso.saludboyaca.dto.Paciente;
import co.sena.cimm.adso.saludboyaca.dto.Usuario;
import co.sena.cimm.adso.saludboyaca.model.Conexion;

public class CitaDAO {

    public List<Cita> listarTodas() {
        List<Cita> lista = new ArrayList<>();
        String sql = "SELECT c.*, "
                + "p.nombres as pac_nombres, p.apellidos as pac_apellidos, p.documento as pac_doc, "
                + "u.nombres as med_nombres, u.apellidos as med_apellidos, "
                + "e.nombre as esp_nombre "
                + "FROM citas c "
                + "JOIN pacientes p ON c.id_paciente = p.id "
                + "JOIN usuarios u ON c.id_medico = u.id "
                + "JOIN especialidades e ON c.id_especialidad = e.id "
                + "ORDER BY c.fecha_cita DESC, c.hora_cita ASC";
        try (Connection con = Conexion.getConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                lista.add(mapear(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error en listarTodas: " + e.getMessage());
        }
        return lista;
    }

    public List<Cita> listarPorMedico(int idMedico) {
        List<Cita> lista = new ArrayList<>();
        String sql = "SELECT c.*, "
                + "p.nombres as pac_nombres, p.apellidos as pac_apellidos, p.documento as pac_doc, "
                + "u.nombres as med_nombres, u.apellidos as med_apellidos, "
                + "e.nombre as esp_nombre "
                + "FROM citas c "
                + "JOIN pacientes p ON c.id_paciente = p.id "
                + "JOIN usuarios u ON c.id_medico = u.id "
                + "JOIN especialidades e ON c.id_especialidad = e.id "
                + "WHERE c.id_medico = ? "
                + "ORDER BY c.fecha_cita DESC, c.hora_cita ASC";
        try (Connection con = Conexion.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idMedico);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                lista.add(mapear(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error en listarPorMedico: " + e.getMessage());
        }
        return lista;
    }

    public Cita buscarPorId(int id) {
        String sql = "SELECT c.*, "
                + "p.nombres as pac_nombres, p.apellidos as pac_apellidos, p.documento as pac_doc, "
                + "u.nombres as med_nombres, u.apellidos as med_apellidos, "
                + "e.nombre as esp_nombre "
                + "FROM citas c "
                + "JOIN pacientes p ON c.id_paciente = p.id "
                + "JOIN usuarios u ON c.id_medico = u.id "
                + "JOIN especialidades e ON c.id_especialidad = e.id "
                + "WHERE c.id = ?";
        try (Connection con = Conexion.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapear(rs);
            }
        } catch (SQLException e) {
            System.err.println("Error en buscarPorId: " + e.getMessage());
        }
        return null;
    }

    public boolean insertar(Cita c) {
        String sql = "INSERT INTO citas (id_paciente, id_medico, id_especialidad, fecha_cita, hora_cita, motivo, estado, id_registrado_por) VALUES (?, ?, ?, ?, ?, ?, 'PROGRAMADA', ?)";
        try (Connection con = Conexion.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, c.getPaciente().getId());
            ps.setInt(2, c.getMedico().getId());
            ps.setInt(3, c.getEspecialidad().getId());
            ps.setDate(4, Date.valueOf(c.getFechaCita()));
            ps.setTime(5, Time.valueOf(c.getHoraCita()));
            ps.setString(6, c.getMotivo());
            ps.setInt(7, c.getIdRegistradoPor());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error en insertar: " + e.getMessage());
        }
        return false;
    }

    public boolean cambiarEstado(int id, String estado) {
        String sql = "UPDATE citas SET estado = ? WHERE id = ?";
        try (Connection con = Conexion.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, estado);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error en cambiarEstado: " + e.getMessage());
        }
        return false;
    }

    public boolean eliminar(int id) {
        String sql = "DELETE FROM citas WHERE id = ?";
        try (Connection con = Conexion.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error en eliminar: " + e.getMessage());
        }
        return false;
    }

    // Contar citas por estado para el dashboard
    public int contarPorEstado(String estado) {
        String sql = "SELECT COUNT(*) FROM citas WHERE estado = ?";
        try (Connection con = Conexion.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, estado);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("Error en contarPorEstado: " + e.getMessage());
        }
        return 0;
    }

    public int contarCitasHoy() {
        String sql = "SELECT COUNT(*) FROM citas WHERE fecha_cita = CURRENT_DATE";
        try (Connection con = Conexion.getConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("Error en contarCitasHoy: " + e.getMessage());
        }
        return 0;
    }

    public int contarCitasMes() {
        String sql = "SELECT COUNT(*) FROM citas WHERE EXTRACT(MONTH FROM fecha_cita) = EXTRACT(MONTH FROM CURRENT_DATE) AND EXTRACT(YEAR FROM fecha_cita) = EXTRACT(YEAR FROM CURRENT_DATE)";
        try (Connection con = Conexion.getConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("Error en contarCitasMes: " + e.getMessage());
        }
        return 0;
    }

    private Cita mapear(ResultSet rs) throws SQLException {
        Cita c = new Cita();
        c.setId(rs.getInt("id"));
        c.setFechaCita(rs.getDate("fecha_cita").toLocalDate());
        c.setHoraCita(rs.getTime("hora_cita").toLocalTime());
        c.setMotivo(rs.getString("motivo"));
        c.setEstado(rs.getString("estado"));
        c.setObservaciones(rs.getString("observaciones"));
        c.setIdRegistradoPor(rs.getInt("id_registrado_por"));

        Paciente p = new Paciente();
        p.setId(rs.getInt("id_paciente"));
        p.setNombres(rs.getString("pac_nombres"));
        p.setApellidos(rs.getString("pac_apellidos"));
        p.setDocumento(rs.getString("pac_doc"));
        c.setPaciente(p);

        Usuario u = new Usuario();
        u.setId(rs.getInt("id_medico"));
        u.setNombres(rs.getString("med_nombres"));
        u.setApellidos(rs.getString("med_apellidos"));
        c.setMedico(u);

        Especialidad e = new Especialidad();
        e.setId(rs.getInt("id_especialidad"));
        e.setNombre(rs.getString("esp_nombre"));
        c.setEspecialidad(e);

        return c;
    }

    // ── Métodos adicionales para Dashboard ──────────────────────────
    public List<Cita> listarProximasHoy(int limite) {
        List<Cita> lista = new ArrayList<>();
        String sql = "SELECT c.*, "
                + "p.nombres as pac_nombres, p.apellidos as pac_apellidos, p.documento as pac_doc, "
                + "u.nombres as med_nombres, u.apellidos as med_apellidos, "
                + "e.nombre as esp_nombre "
                + "FROM citas c "
                + "JOIN pacientes p ON c.id_paciente = p.id "
                + "JOIN usuarios u ON c.id_medico = u.id "
                + "JOIN especialidades e ON c.id_especialidad = e.id "
                + "WHERE c.fecha_cita = CURRENT_DATE "
                + "ORDER BY c.hora_cita ASC LIMIT ?";
        try (Connection con = Conexion.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, limite);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                lista.add(mapear(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error listarProximasHoy: " + e.getMessage());
        }
        return lista;
    }

    public List<Cita> listarProximasPorMedico(int idMedico, int limite) {
        List<Cita> lista = new ArrayList<>();
        String sql = "SELECT c.*, "
                + "p.nombres as pac_nombres, p.apellidos as pac_apellidos, p.documento as pac_doc, "
                + "u.nombres as med_nombres, u.apellidos as med_apellidos, "
                + "e.nombre as esp_nombre "
                + "FROM citas c "
                + "JOIN pacientes p ON c.id_paciente = p.id "
                + "JOIN usuarios u ON c.id_medico = u.id "
                + "JOIN especialidades e ON c.id_especialidad = e.id "
                + "WHERE c.id_medico = ? AND c.fecha_cita = CURRENT_DATE "
                + "ORDER BY c.hora_cita ASC LIMIT ?";
        try (Connection con = Conexion.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idMedico);
            ps.setInt(2, limite);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                lista.add(mapear(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error listarProximasPorMedico: " + e.getMessage());
        }
        return lista;
    }

    public int contarPorEstadoYMedico(String estado, int idMedico) {
        String sql = "SELECT COUNT(*) FROM citas WHERE estado = ? AND id_medico = ?";
        try (Connection con = Conexion.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, estado);
            ps.setInt(2, idMedico);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("Error contarPorEstadoYMedico: " + e.getMessage());
        }
        return 0;
    }

    public int contarHoyPorMedico(int idMedico) {
        String sql = "SELECT COUNT(*) FROM citas WHERE fecha_cita = CURRENT_DATE AND id_medico = ?";
        try (Connection con = Conexion.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idMedico);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("Error contarHoyPorMedico: " + e.getMessage());
        }
        return 0;
    }

    public int contarMesPorMedico(int idMedico) {
        String sql = "SELECT COUNT(*) FROM citas WHERE id_medico = ? "
                + "AND EXTRACT(MONTH FROM fecha_cita) = EXTRACT(MONTH FROM CURRENT_DATE) "
                + "AND EXTRACT(YEAR FROM fecha_cita)  = EXTRACT(YEAR  FROM CURRENT_DATE)";
        try (Connection con = Conexion.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idMedico);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("Error contarMesPorMedico: " + e.getMessage());
        }
        return 0;
    }

    public List<Cita> listarPorDocumentoPaciente(String documento) {
        List<Cita> lista = new ArrayList<>();
        String sql = "SELECT c.*, "
                + "p.nombres as pac_nombres, p.apellidos as pac_apellidos, p.documento as pac_doc, "
                + "u.nombres as med_nombres, u.apellidos as med_apellidos, "
                + "e.nombre as esp_nombre "
                + "FROM citas c "
                + "JOIN pacientes p ON c.id_paciente = p.id "
                + "JOIN usuarios u ON c.id_medico = u.id "
                + "JOIN especialidades e ON c.id_especialidad = e.id "
                + "WHERE p.documento = ? "
                + "ORDER BY c.fecha_cita DESC, c.hora_cita ASC";
        try (Connection con = Conexion.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, documento);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                lista.add(mapear(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error listarPorDocumentoPaciente: " + e.getMessage());
        }
        return lista;
    }

    /**
     * Lista todas las citas con filtros dinámicos (para exportar PDF)
     */
    public List<Cita> listarTodasConFiltros(String search, String estado, String especialidad, String fecha) {
        List<Cita> lista = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT c.*, "
                + "p.nombres as pac_nombres, p.apellidos as pac_apellidos, p.documento as pac_doc, "
                + "u.nombres as med_nombres, u.apellidos as med_apellidos, "
                + "e.nombre as esp_nombre "
                + "FROM citas c "
                + "JOIN pacientes p ON c.id_paciente = p.id "
                + "JOIN usuarios u ON c.id_medico = u.id "
                + "JOIN especialidades e ON c.id_especialidad = e.id "
                + "WHERE 1=1 "
        );

        List<Object> params = new ArrayList<>();

        // Filtro de búsqueda (paciente, documento o médico)
        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND (p.nombres LIKE ? OR p.apellidos LIKE ? OR p.documento LIKE ? OR u.nombres LIKE ? OR u.apellidos LIKE ?) ");
            String like = "%" + search.trim() + "%";
            params.add(like);
            params.add(like);
            params.add(like);
            params.add(like);
            params.add(like);
        }

        // Filtro por estado
        if (estado != null && !estado.trim().isEmpty()) {
            sql.append("AND c.estado = ? ");
            params.add(estado);
        }

        // Filtro por especialidad
        if (especialidad != null && !especialidad.trim().isEmpty()) {
            sql.append("AND e.nombre = ? ");
            params.add(especialidad);
        }

        // Filtro por fecha
        if (fecha != null && !fecha.trim().isEmpty()) {
            sql.append("AND c.fecha_cita = ? ");
            params.add(java.time.LocalDate.parse(fecha));
        }

        sql.append("ORDER BY c.fecha_cita DESC, c.hora_cita ASC");

        try (Connection con = Conexion.getConnection(); PreparedStatement ps = con.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                lista.add(mapear(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error en listarTodasConFiltros: " + e.getMessage());
        }
        return lista;
    }

    /**
     * Lista citas de un médico específico con filtros (para exportar PDF)
     */
    public List<Cita> listarPorMedicoConFiltros(int idMedico, String search, String estado, String especialidad, String fecha) {
        List<Cita> lista = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT c.*, "
                + "p.nombres as pac_nombres, p.apellidos as pac_apellidos, p.documento as pac_doc, "
                + "u.nombres as med_nombres, u.apellidos as med_apellidos, "
                + "e.nombre as esp_nombre "
                + "FROM citas c "
                + "JOIN pacientes p ON c.id_paciente = p.id "
                + "JOIN usuarios u ON c.id_medico = u.id "
                + "JOIN especialidades e ON c.id_especialidad = e.id "
                + "WHERE c.id_medico = ? "
        );

        List<Object> params = new ArrayList<>();
        params.add(idMedico);

        // Filtro de búsqueda
        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND (p.nombres LIKE ? OR p.apellidos LIKE ? OR p.documento LIKE ?) ");
            String like = "%" + search.trim() + "%";
            params.add(like);
            params.add(like);
            params.add(like);
        }

        // Filtro por estado
        if (estado != null && !estado.trim().isEmpty()) {
            sql.append("AND c.estado = ? ");
            params.add(estado);
        }

        // Filtro por especialidad
        if (especialidad != null && !especialidad.trim().isEmpty()) {
            sql.append("AND e.nombre = ? ");
            params.add(especialidad);
        }

        // Filtro por fecha
        if (fecha != null && !fecha.trim().isEmpty()) {
            sql.append("AND c.fecha_cita = ? ");
            params.add(java.time.LocalDate.parse(fecha));
        }

        sql.append("ORDER BY c.fecha_cita DESC, c.hora_cita ASC");

        try (Connection con = Conexion.getConnection(); PreparedStatement ps = con.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                lista.add(mapear(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error en listarPorMedicoConFiltros: " + e.getMessage());
        }
        return lista;
    }
}
