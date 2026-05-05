package co.sena.cimm.adso.saludboyaca.util;

import java.io.UnsupportedEncodingException;
import java.security.SecureRandom;
import java.util.Properties;

import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

public class OTPService {

    private static final String SMTP_HOST = "smtp.gmail.com";
    private static final int SMTP_PORT = 587;

    private static final String EMAIL_REMIT =
        System.getenv("EMAIL_USER") != null
        ? System.getenv("EMAIL_USER")
        : "pjulieth836@gmail.com";

    private static final String EMAIL_PASS =
        System.getenv("EMAIL_PASS") != null
        ? System.getenv("EMAIL_PASS")
        : "fmrk uwiu wwjl wvbi";

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
                                  String asunto, String cuerpo)
            throws MessagingException, UnsupportedEncodingException {

        Properties props = new Properties();
        props.put("mail.smtp.host", SMTP_HOST);
        props.put("mail.smtp.port", SMTP_PORT);
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Session mailSession = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(EMAIL_REMIT, EMAIL_PASS);
            }
        });

        Message mensaje = new MimeMessage(mailSession);
        // Se agrega el charset UTF-8 para evitar UnsupportedEncodingException
        mensaje.setFrom(new InternetAddress(EMAIL_REMIT, "SaludBoyaca", "UTF-8"));
        mensaje.setRecipient(Message.RecipientType.TO, new InternetAddress(destinatario));
        mensaje.setSubject(asunto);
        mensaje.setText(cuerpo);
        Transport.send(mensaje);
    }
}