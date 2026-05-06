package co.sena.cimm.adso.saludboyaca.util;

import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.security.SecureRandom;

public class OTPService {

    private static final String BREVO_API_KEY = System.getenv("BREVO_API_KEY");

    private static final String EMAIL_REMIT = "pjulieth836@gmail.com";
    private static final int OTP_LONGITUD = 6;

    public static String generarOTP() {
        SecureRandom rnd = new SecureRandom();
        StringBuilder sb = new StringBuilder(OTP_LONGITUD);
        for (int i = 0; i < OTP_LONGITUD; i++) {
            sb.append(rnd.nextInt(10));
        }
        return sb.toString();
    }

    public static void enviarOTP(String destinatario, String codigoOTP,
                                  String asunto, String cuerpo) throws Exception {

        URL url = new URL("https://api.brevo.com/v3/smtp/email");
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setRequestProperty("accept", "application/json");
        conn.setRequestProperty("api-key", BREVO_API_KEY);
        conn.setRequestProperty("content-type", "application/json");
        conn.setDoOutput(true);

        String json = "{"
            + "\"sender\":{\"name\":\"SaludBoyaca\",\"email\":\"" + EMAIL_REMIT + "\"},"
            + "\"to\":[{\"email\":\"" + destinatario + "\"}],"
            + "\"subject\":\"" + asunto + "\","
            + "\"textContent\":\"" + cuerpo + "\""
            + "}";

        try (OutputStream os = conn.getOutputStream()) {
            os.write(json.getBytes("UTF-8"));
        }

        int responseCode = conn.getResponseCode();
        if (responseCode != 201) {
            throw new Exception("Error Brevo API: " + responseCode);
        }
    }
}