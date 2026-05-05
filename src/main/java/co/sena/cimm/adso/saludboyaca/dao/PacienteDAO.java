package co.sena.cimm.adso.saludboyaca.dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import co.sena.cimm.adso.saludboyaca.dto.Paciente;
import co.sena.cimm.adso.saludboyaca.model.Conexion;

public class PacienteDAO {

    public List<Paciente> listarTodos() {
        List<Paciente> lista = new ArrayList<>();
        String sql = "SELECT * FROM pacientes ORDER BY apellidos";
        
        System.out.println("[PacienteDAO] Ejecutando: " + sql);
        
        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            System.out.println("[PacienteDAO] Conexión exitosa");
            
            while (rs.next()) {
                Paciente p = mapear(rs);
                lista.add(p);
            }
            
            System.out.println("[PacienteDAO] Pacientes encontrados: " + lista.size());
            
        } catch (SQLException e) {
            System.err.println("[PacienteDAO] ERROR: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Error al listar pacientes: " + e.getMessage(), e);
        }
        return lista;
    }

    public Paciente buscarPorId(int id) {
        String sql = "SELECT * FROM pacientes WHERE id = ?";
        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapear(rs);
        } catch (SQLException e) {
            System.err.println("[PacienteDAO] Error en buscarPorId: " + e.getMessage());
        }
        return null;
    }

    public Paciente buscarPorDocumento(String documento) {
        String sql = "SELECT * FROM pacientes WHERE documento = ?";
        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, documento);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapear(rs);
        } catch (SQLException e) {
            System.err.println("[PacienteDAO] Error en buscarPorDocumento: " + e.getMessage());
        }
        return null;
    }

    public boolean insertar(Paciente p) {
        String sql = "INSERT INTO pacientes (nombres, apellidos, documento, fecha_nacimiento, telefono, email, eps, vereda_barrio) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, p.getNombres());
            ps.setString(2, p.getApellidos());
            ps.setString(3, p.getDocumento());
            ps.setDate(4, Date.valueOf(p.getFechaNacimiento()));
            ps.setString(5, p.getTelefono());
            ps.setString(6, p.getEmail());
            ps.setString(7, p.getEps());
            ps.setString(8, p.getVeredaBarrio());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[PacienteDAO] Error en insertar: " + e.getMessage());
        }
        return false;
    }

    public boolean actualizar(Paciente p) {
        String sql = "UPDATE pacientes SET nombres=?, apellidos=?, fecha_nacimiento=?, telefono=?, email=?, eps=?, vereda_barrio=? WHERE id=?";
        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, p.getNombres());
            ps.setString(2, p.getApellidos());
            ps.setDate(3, Date.valueOf(p.getFechaNacimiento()));
            ps.setString(4, p.getTelefono());
            ps.setString(5, p.getEmail());
            ps.setString(6, p.getEps());
            ps.setString(7, p.getVeredaBarrio());
            ps.setInt(8, p.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[PacienteDAO] Error en actualizar: " + e.getMessage());
        }
        return false;
    }

    public boolean eliminar(int id) {
        String sql = "DELETE FROM pacientes WHERE id = ?";
        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[PacienteDAO] Error en eliminar: " + e.getMessage());
        }
        return false;
    }

    private Paciente mapear(ResultSet rs) throws SQLException {
        Paciente p = new Paciente();
        p.setId(rs.getInt("id"));
        p.setNombres(rs.getString("nombres"));
        p.setApellidos(rs.getString("apellidos"));
        p.setDocumento(rs.getString("documento"));
        p.setFechaNacimiento(rs.getDate("fecha_nacimiento").toLocalDate());
        p.setTelefono(rs.getString("telefono"));
        p.setEmail(rs.getString("email"));
        p.setEps(rs.getString("eps"));
        p.setVeredaBarrio(rs.getString("vereda_barrio"));
        return p;
    }


    public int contarTotal() {
        String sql = "SELECT COUNT(*) FROM pacientes";
        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            System.err.println("[PacienteDAO] Error contarTotal: " + e.getMessage());
        }
        return 0;
    }
}