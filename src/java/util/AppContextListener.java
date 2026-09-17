package util;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import java.sql.Driver;
import java.sql.DriverManager;
import java.util.Enumeration;

/**
 * Standard Jakarta EE web application lifecycle listener.
 * Automatically initializes AppConfig upon deployment and Tomcat boot.
 */
public class AppContextListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("==================================================");
        System.out.println("[AppContextListener] Initializing Elevate Workforce application...");
        AppConfig.init(sce.getServletContext());

        String smtpHost = AppConfig.getSmtpHost();
        String smtpPort = AppConfig.getSmtpPort();
        boolean smtpConfigured = AppConfig.isSmtpConfigured();
        String smtpUser = AppConfig.getSmtpUser();

        System.out.println("[AppContextListener] SMTP Host: " + smtpHost + ":" + smtpPort);
        System.out.println("[AppContextListener] SMTP Configured: " + (smtpConfigured ? "YES" : "NO (SMTP_PASSWORD empty in .env)"));
        if (!smtpUser.isBlank()) {
            System.out.println("[AppContextListener] SMTP User: " + (smtpUser.length() > 3 ? smtpUser.substring(0, 3) + "***" : "***"));
        }
        System.out.println("==================================================");
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        System.out.println("[AppContextListener] Shutting down Elevate application...");
        // Deregister JDBC drivers to prevent Tomcat memory leak warnings
        Enumeration<Driver> drivers = DriverManager.getDrivers();
        while (drivers.hasMoreElements()) {
            Driver driver = drivers.nextElement();
            try {
                DriverManager.deregisterDriver(driver);
            } catch (Exception ignored) {}
        }
    }
}
