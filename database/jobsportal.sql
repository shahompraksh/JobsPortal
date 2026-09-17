CREATE DATABASE IF NOT EXISTS jobsportal;
USE jobsportal;

CREATE TABLE IF NOT EXISTS admin (
  id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(100) NOT NULL,
  address VARCHAR(255),
  username VARCHAR(50) NOT NULL,
  password VARCHAR(255) NOT NULL,
  PRIMARY KEY (id), UNIQUE KEY username (username)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS jobs (
  id INT NOT NULL AUTO_INCREMENT,
  title VARCHAR(150) NOT NULL,
  company VARCHAR(150) NOT NULL,
  location VARCHAR(150), salary DECIMAL(12,2), description TEXT, type VARCHAR(50),
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS user (
  id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(100) NOT NULL, email VARCHAR(150) NOT NULL, username VARCHAR(50) NOT NULL,
  password VARCHAR(255) NOT NULL, phone VARCHAR(20), resume VARCHAR(255),
  PRIMARY KEY (id), UNIQUE KEY email (email), UNIQUE KEY username (username)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS applications (
  id INT NOT NULL AUTO_INCREMENT, user_id INT NOT NULL, job_id INT NOT NULL,
  applied_date DATETIME DEFAULT CURRENT_TIMESTAMP, status VARCHAR(50) DEFAULT 'Pending',
  PRIMARY KEY (id), UNIQUE KEY uq_user_job (user_id, job_id),
  CONSTRAINT fk_applications_job FOREIGN KEY (job_id) REFERENCES jobs(id) ON DELETE CASCADE,
  CONSTRAINT fk_applications_user FOREIGN KEY (user_id) REFERENCES user(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT IGNORE INTO admin (id, name, address, username, password)
VALUES (1, 'admin', 'ktm', 'admin', 'admin');

INSERT IGNORE INTO jobs (id, title, company, location, salary, description, type) VALUES
(1, 'IT Support Engineer', 'Nepal IT Solution', 'Kathmandu', 40000.00, 'Knowledge of frontend, backend development, and network systems troubleshooting.', 'Full-time'),
(2, 'UI/UX Designer', 'Nepal IT Solution', 'Pokhara', 50000.00, 'Design user interfaces, wireframes, and prototypes using modern design tools.', 'Full-time'),
(4, 'Technical Support Representative', 'Bhagya Laxmi International Pvt. Ltd.', 'Kathmandu', 45000.00, 'Provide front-line technical helpdesk and IT support for enterprise clients. Diagnose software and hardware issues, configure network systems, and maintain customer satisfaction with timely issue resolution.', 'Full-time'),
(5, 'Graphic Designer & Content Creator', 'Himalaya Media Solutions', 'Lalitpur', 42000.00, 'Design high-impact visual graphics, digital marketing creatives, website UI banners, and brand identity materials using Adobe Illustrator, Photoshop, and Figma.', 'Full-time'),
(6, 'AI-Assisted Software Engineer', 'Robotics Association of Nepal', 'Pokhara', 75000.00, 'Participate in intermediate software engineering projects leveraging modern AI tools, Python, REST APIs, and automated code review workflows. Deliver technical workshops and software modules.', 'Full-time'),
(7, 'Biomedical Engineer (Sales & Service)', 'KNS Enterprises Pvt Ltd', 'Kathmandu', 55000.00, 'Responsible for the installation, calibration, and preventive maintenance of advanced biomedical diagnostic equipment across hospitals in Nepal. Provide technical demonstrations and user training.', 'Full-time'),
(8, 'Communication and Outreach Officer', 'Youth Innovation Lab', 'Lalitpur', 60000.00, 'Lead communication campaigns, create content for digital outreach, draft impact stories, and coordinate public relations for disaster risk reduction and technological innovation initiatives.', 'Full-time'),
(9, 'Data Integration Specialist (Bipad Portal)', 'Sajag Nepal Project', 'Kathmandu', 85000.00, 'Design data pipelines for integrating geohazard datasets into the national Bipad portal. Work with PostgreSQL/PostGIS, Python backend services, and spatial data visualization tools.', 'Remote'),
(10, 'Admin and Finance Officer (AFO)', 'SOSEC Nepal', 'Dailekh', 50000.00, 'Manage project accounting, prepare financial statements, coordinate with statutory auditors, and ensure strict compliance with institutional and donor procurement standards.', 'Full-time'),
(11, 'Sales Executive Officer', 'NIP Holdings Pvt Ltd', 'Kathmandu', 38000.00, 'Drive B2B sales growth, manage corporate client accounts, conduct product pitches, and hit monthly sales quotas in FMCG and hospitality sectors.', 'Full-time'),
(12, 'Project Coordinator', 'National Federation of the Disabled Nepal', 'Kathmandu', 70000.00, 'Coordinate advocacy projects, organize capacity development workshops, collaborate with local municipalities, and submit monthly monitoring progress reports.', 'Full-time'),
(13, 'Client Relations Officer', 'JobsNepal Direct Recruitment', 'Kathmandu', 35000.00, 'Coordinate with hiring partners and candidates, schedule interviews, screen resumes, and facilitate smooth onboarding processes for job seekers.', 'Full-time'),
(14, 'Emergency Food Security & Livelihoods Officer', 'Oxfam in Nepal', 'Birgunj', 68000.00, 'Implement field-level cash transfer programming, vulnerable household assessments, market monitoring, and emergency response distributions.', 'Full-time'),
(15, 'Sustainable Infrastructure Specialist', 'WWF Nepal', 'Kathmandu', 95000.00, 'Advise on green infrastructure development, environmental impact assessments, and ecological corridors to align national infrastructure projects with biodiversity preservation.', 'Full-time');
