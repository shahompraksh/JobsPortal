/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dbHelper;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/** Creates database connections from environment variables or JVM properties. */
public final class MyConnect {
    private MyConnect() { }

    public static Connection connectDatab() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new IllegalStateException("MySQL JDBC driver is not available. Add mysql-connector-j to WEB-INF/lib.", e);
        }

        String url = util.AppConfig.getDbUrl();
        String user = util.AppConfig.getDbUser();
        String password = util.AppConfig.getDbPassword();
        try {
            return DriverManager.getConnection(url, user, password);
        } catch (SQLException e) {
            throw new IllegalStateException("Cannot connect to MySQL at " + url + ". Check that MySQL is running and DB_URL, DB_USER, and DB_PASSWORD are correct.", e);
        }
    }
}
