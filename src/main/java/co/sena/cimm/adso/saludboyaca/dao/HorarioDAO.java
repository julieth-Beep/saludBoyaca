package co.sena.cimm.adso.saludboyaca.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import co.sena.cimm.adso.saludboyaca.dto.Horario;
import co.sena.cimm.adso.saludboyaca.model.Conexion;

public class HorarioDAO {

    public List<Horario> listarPorMedico(int idMedico) {
        List<Horario> lista = new ArrayList<>();
        String sql = "SELECT * FROM horarios WHERE id_medico = ? ORDER BY dia_semana, hora_inicio";
        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
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

    private Horario mapear(ResultSet rs) throws SQLException {
        Horario h = new Horario();
        h.setId(rs.getInt("id"));
        h.setIdMedico(rs.getInt("id_medico"));
        h.setDiaSemana(rs.getInt("dia_semana"));
        h.setHoraInicio(rs.getTime("hora_inicio").toLocalTime());
        h.setHoraFin(rs.getTime("hora_fin").toLocalTime());
        h.setMaxCitas(rs.getInt("max_citas"));
        return h;
    }


    public List<Horario> listarTodos() {
        List<Horario> lista = new ArrayList<>();
        String sql = "SELECT h.*, u.nombres as med_nombres, u.apellidos as med_apellidos " +
                     "FROM horarios h JOIN usuarios u ON h.id_medico = u.id " +
                     "ORDER BY h.id_medico, h.dia_semana, h.hora_inicio";
        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Horario h = mapear(rs);
                try { h.setNombreMedico(rs.getString("med_nombres") + " " + rs.getString("med_apellidos")); }
                catch (Exception ignored) {}
                lista.add(h);
            }
        } catch (SQLException e) {
            System.err.println("Error listarTodos horarios: " + e.getMessage());
        }
        return lista;
    }
}