package kr.co.seoulit.common.appender;

import java.util.Properties;

import javax.mail.Authenticator;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;

import org.apache.log4j.net.SMTPAppender;

public class SecureSMTPAppender extends SMTPAppender{
   private boolean useStartTLS;

    public void setUseStartTLS(boolean useStartTLS) {
        this.useStartTLS = useStartTLS;
    }

    @Override
    protected Session createSession() {
        Properties props = null;
        try {
            props = new Properties(System.getProperties());
        } catch (SecurityException ex) {
            props = new Properties();
        }
        if (getSMTPHost() != null) {
            props.put("mail.smtp.host", getSMTPHost());
        }
        if (useStartTLS) {
            props.put("mail.smtp.starttls.enable", "true");
        }
        Authenticator auth = null;
        if (getSMTPPassword() != null && getSMTPUsername() != null) {
            props.put("mail.smtp.auth", "true");
            auth = new Authenticator() {
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(getSMTPUsername(), getSMTPPassword());
                }
            };
        }
        Session session = Session.getInstance(props, auth);
        if (getSMTPDebug()) {
            session.setDebug(true);
        }
        return session;
    }
}