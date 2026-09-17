package util;

import dbHelper.MyConnect;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

/**
 * Automatically creates all tables and initial jobs if they don't exist yet.
 * Runs on application boot so deployment to Railway / Render / Docker requires
 * ZERO manual SQL import steps!
 */
public final class DatabaseInitializer {

    private DatabaseInitializer() {}

    public static void initializeIfNeeded() {
        System.out.println("[DatabaseInitializer] Checking database schema...");
        try (Connection conn = MyConnect.connectDatab();
             Statement st = conn.createStatement()) {

            // 1. Admin table
            st.execute("CREATE TABLE IF NOT EXISTS admin ("
                    + "  id INT NOT NULL AUTO_INCREMENT,"
                    + "  name VARCHAR(100) NOT NULL,"
                    + "  address VARCHAR(255),"
                    + "  username VARCHAR(50) NOT NULL,"
                    + "  password VARCHAR(255) NOT NULL,"
                    + "  PRIMARY KEY (id), UNIQUE KEY username (username)"
                    + ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4");

            // 2. Jobs table
            st.execute("CREATE TABLE IF NOT EXISTS jobs ("
                    + "  id INT NOT NULL AUTO_INCREMENT,"
                    + "  title VARCHAR(150) NOT NULL,"
                    + "  company VARCHAR(150) NOT NULL,"
                    + "  location VARCHAR(150),"
                    + "  salary DECIMAL(12,2),"
                    + "  description TEXT,"
                    + "  type VARCHAR(50),"
                    + "  PRIMARY KEY (id)"
                    + ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4");

            // 3. User table
            st.execute("CREATE TABLE IF NOT EXISTS user ("
                    + "  id INT NOT NULL AUTO_INCREMENT,"
                    + "  name VARCHAR(100) NOT NULL,"
                    + "  email VARCHAR(150) NOT NULL,"
                    + "  username VARCHAR(50) NOT NULL,"
                    + "  password VARCHAR(255) NOT NULL,"
                    + "  phone VARCHAR(20),"
                    + "  resume VARCHAR(255),"
                    + "  is_verified TINYINT(1) NOT NULL DEFAULT 1,"
                    + "  PRIMARY KEY (id), UNIQUE KEY email (email), UNIQUE KEY username (username)"
                    + ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4");

            // Ensure is_verified column exists if table existed previously without it
            try {
                st.execute("ALTER TABLE user ADD COLUMN is_verified TINYINT(1) NOT NULL DEFAULT 1");
            } catch (Exception ignored) {}

            // 4. Applications table
            st.execute("CREATE TABLE IF NOT EXISTS applications ("
                    + "  id INT NOT NULL AUTO_INCREMENT,"
                    + "  user_id INT NOT NULL,"
                    + "  job_id INT NOT NULL,"
                    + "  applied_date DATETIME DEFAULT CURRENT_TIMESTAMP,"
                    + "  status VARCHAR(50) DEFAULT 'Pending',"
                    + "  PRIMARY KEY (id), UNIQUE KEY uq_user_job (user_id, job_id),"
                    + "  CONSTRAINT fk_applications_job FOREIGN KEY (job_id) REFERENCES jobs(id) ON DELETE CASCADE,"
                    + "  CONSTRAINT fk_applications_user FOREIGN KEY (user_id) REFERENCES user(id) ON DELETE CASCADE"
                    + ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4");

            // 5. Messages table
            st.execute("CREATE TABLE IF NOT EXISTS messages ("
                    + "  id INT NOT NULL AUTO_INCREMENT,"
                    + "  name VARCHAR(100) NOT NULL,"
                    + "  email VARCHAR(150) NOT NULL,"
                    + "  phone VARCHAR(20) DEFAULT NULL,"
                    + "  message TEXT NOT NULL,"
                    + "  contact_method VARCHAR(50) DEFAULT NULL,"
                    + "  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,"
                    + "  status VARCHAR(20) DEFAULT 'Unread',"
                    + "  PRIMARY KEY (id)"
                    + ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4");

            // 6. OAuth accounts table
            st.execute("CREATE TABLE IF NOT EXISTS oauth_accounts ("
                    + "  id INT NOT NULL AUTO_INCREMENT,"
                    + "  user_id INT NOT NULL,"
                    + "  provider VARCHAR(32) NOT NULL,"
                    + "  provider_user_id VARCHAR(255) NOT NULL,"
                    + "  email VARCHAR(150) DEFAULT NULL,"
                    + "  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,"
                    + "  PRIMARY KEY (id),"
                    + "  UNIQUE KEY uq_provider_uid (provider, provider_user_id),"
                    + "  KEY idx_oa_user (user_id),"
                    + "  CONSTRAINT fk_oa_user FOREIGN KEY (user_id) REFERENCES user(id) ON DELETE CASCADE"
                    + ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4");

            // 7. Seed Admin
            st.execute("INSERT IGNORE INTO admin (id, name, address, username, password) "
                    + "VALUES (1, 'admin', 'ktm', 'admin', 'admin')");

            // 8. Seed Jobs if empty
            ResultSet rs = st.executeQuery("SELECT COUNT(*) FROM jobs");
            int jobCount = 0;
            if (rs.next()) jobCount = rs.getInt(1);
            if (jobCount == 0) {
                System.out.println("[DatabaseInitializer] Seeding initial job postings...");
                st.execute("INSERT INTO jobs (id, title, company, location, salary, description, type) VALUES "
                        + "(1, 'IT Support Engineer', 'Nepal IT Solution', 'Kathmandu', 40000.00, 'Knowledge of frontend, backend development, and network systems troubleshooting.', 'Full-time'), "
                        + "(2, 'UI/UX Designer', 'Nepal IT Solution', 'Pokhara', 50000.00, 'Design user interfaces, wireframes, and prototypes using modern design tools.', 'Full-time'), "
                        + "(4, 'Technical Support Representative', 'Bhagya Laxmi International Pvt. Ltd.', 'Kathmandu', 45000.00, 'Provide front-line technical helpdesk and IT support for enterprise clients.', 'Full-time'), "
                        + "(5, 'Graphic Designer & Content Creator', 'Himalaya Media Solutions', 'Lalitpur', 42000.00, 'Design high-impact visual graphics, digital marketing creatives, and website UI banners.', 'Full-time'), "
                        + "(6, 'AI-Assisted Software Engineer', 'Robotics Association of Nepal', 'Pokhara', 75000.00, 'Participate in intermediate software engineering projects leveraging modern AI tools and REST APIs.', 'Full-time'), "
                        + "(7, 'Biomedical Engineer (Sales & Service)', 'KNS Enterprises Pvt Ltd', 'Kathmandu', 55000.00, 'Responsible for the installation and maintenance of biomedical diagnostic equipment.', 'Full-time'), "
                        + "(8, 'Communication and Outreach Officer', 'Youth Innovation Lab', 'Lalitpur', 60000.00, 'Lead communication campaigns and create content for digital outreach.', 'Full-time'), "
                        + "(9, 'Data Integration Specialist (Bipad Portal)', 'Sajag Nepal Project', 'Kathmandu', 85000.00, 'Design data pipelines for integrating datasets into the national Bipad portal.', 'Remote'), "
                        + "(10, 'Admin and Finance Officer (AFO)', 'SOSEC Nepal', 'Dailekh', 50000.00, 'Manage project accounting, prepare financial statements, and coordinate audits.', 'Full-time'), "
                        + "(11, 'Sales Executive Officer', 'NIP Holdings Pvt Ltd', 'Kathmandu', 38000.00, 'Drive B2B sales growth and manage corporate client accounts.', 'Full-time'), "
                        + "(12, 'Project Coordinator', 'National Federation of the Disabled Nepal', 'Kathmandu', 70000.00, 'Coordinate advocacy projects and organize capacity development workshops.', 'Full-time'), "
                        + "(13, 'Client Relations Officer', 'JobsNepal Direct Recruitment', 'Kathmandu', 35000.00, 'Coordinate with hiring partners and candidates to facilitate smooth onboarding.', 'Full-time'), "
                        + "(14, 'Emergency Food Security Officer', 'Oxfam in Nepal', 'Birgunj', 68000.00, 'Implement field-level cash transfer programming and emergency response distributions.', 'Full-time'), "
                        + "(15, 'Sustainable Infrastructure Specialist', 'WWF Nepal', 'Kathmandu', 95000.00, 'Advise on green infrastructure development and environmental impact assessments.', 'Full-time')");
            }

            System.out.println("[DatabaseInitializer] Database schema ready.");
        } catch (Exception e) {
            System.err.println("[DatabaseInitializer] Note: Database not initialized yet or not reachable: " + e.getMessage());
        }
    }
}
