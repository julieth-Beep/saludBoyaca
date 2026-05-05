package co.sena.cimm.adso.saludboyaca.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;

import co.sena.cimm.adso.saludboyaca.model.Conexion;

public class OTPTokenDAO {

    public boolean insertar(int idUsuario, String codigo, LocalDateTime expiraEn) {
        String sql = "INSERT INTO otp_tokens (id_usuario, codigo, expira_en) VALUES (?, ?, ?)";
        try (Connection con = Conexion.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idUsuario);
            ps.setString(2, codigo);
            ps.setTimestamp(3, Timestamp.valueOf(expiraEn));
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error en insertar OTP: " + e.getMessage());
        }
        return false;
    }

    public boolean validar(int idUsuario, String codigo) {
        String sql = "SELECT id FROM otp_tokens WHERE id_usuario = ? AND codigo = ? AND usado = 0 AND expira_en > NOW() ORDER BY fecha_gen DESC LIMIT 1";
        try (Connection con = Conexion.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idUsuario);
            ps.setString(2, codigo);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            System.err.println("Error en validar OTP: " + e.getMessage());
        }
        return false;
    }

    public boolean marcarUsado(int idUsuario, String codigo) {
        String sql = "UPDATE otp_tokens SET usado = 1 WHERE id_usuario = ? AND codigo = ? AND usado = 0";
        try (Connection con = Conexion.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idUsuario);
            ps.setString(2, codigo);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error en marcarUsado: " + e.getMessage());
        }
        return false;
    }
}
