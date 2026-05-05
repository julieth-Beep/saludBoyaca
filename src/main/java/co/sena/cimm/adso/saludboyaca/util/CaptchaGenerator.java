package co.sena.cimm.adso.saludboyaca.util;

import java.awt.Color;
import java.awt.Font;
import java.awt.Graphics2D;
import java.awt.image.BufferedImage;
import java.io.OutputStream;
import java.security.SecureRandom;

import javax.imageio.ImageIO;
import javax.servlet.http.HttpSession;

/**
 * Genera imagen CAPTCHA gráfico.
 * Solo se usa en ConsultaCitaServlet (módulo público sin cuenta de usuario).
 */
public class CaptchaGenerator {

    private static final int WIDTH  = 160;
    private static final int HEIGHT = 50;
    private static final String CHARS = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789";
    private static final SecureRandom RND = new SecureRandom();

    /** Genera texto aleatorio de 5 chars y lo guarda en sesión. */
    public static String generarTexto(HttpSession session) {
        StringBuilder sb = new StringBuilder(5);
        for (int i = 0; i < 5; i++) sb.append(CHARS.charAt(RND.nextInt(CHARS.length())));
        String texto = sb.toString();
        session.setAttribute("captchaText", texto);
        return texto;
    }

    /** Escribe la imagen CAPTCHA en el OutputStream del response. */
    public static void generarImagen(String texto, OutputStream out) throws Exception {
        BufferedImage img = new BufferedImage(WIDTH, HEIGHT, BufferedImage.TYPE_INT_RGB);
        Graphics2D g = img.createGraphics();

        // Fondo
        g.setColor(new Color(240, 253, 250));
        g.fillRect(0, 0, WIDTH, HEIGHT);

        // Líneas de ruido
        g.setColor(new Color(13, 148, 136, 80));
        for (int i = 0; i < 8; i++) {
            g.drawLine(RND.nextInt(WIDTH), RND.nextInt(HEIGHT),
                       RND.nextInt(WIDTH), RND.nextInt(HEIGHT));
        }

        // Texto
        Font font = new Font("Arial", Font.BOLD, 26);
        g.setFont(font);
        int x = 10;
        for (char c : texto.toCharArray()) {
            float angle = (RND.nextFloat() - 0.5f) * 0.4f;
            Color col = new Color(RND.nextInt(60), RND.nextInt(60) + 80, RND.nextInt(60) + 80);
            g.setColor(col);
            g.rotate(angle, x + 10, 30);
            g.drawString(String.valueOf(c), x, 32 + RND.nextInt(6));
            g.rotate(-angle, x + 10, 30);
            x += 28;
        }

        // Puntos de ruido
        g.setColor(new Color(13, 148, 136, 120));
        for (int i = 0; i < 30; i++) {
            g.fillOval(RND.nextInt(WIDTH), RND.nextInt(HEIGHT), 3, 3);
        }

        g.dispose();
        ImageIO.write(img, "png", out);
    }

    /** Valida el código ingresado contra el guardado en sesión (case-insensitive). */
    public static boolean esValido(String ingresado, HttpSession session) {
        String guardado = (String) session.getAttribute("captchaText");
        if (ingresado == null || guardado == null) return false;
        return ingresado.trim().equalsIgnoreCase(guardado.trim());
    }
}
