# 🚀 Elevate Workforce Solutions (Jobs Portal)

> Nepal's premier workforce and employment acceleration platform. Connecting exceptional talent with industry-leading companies across Kathmandu, Pokhara, Lalitpur, and beyond.

---

## 🌐 Live Deployments

| Platform | Type | Status & URL |
| :--- | :--- | :--- |
| **GitHub Pages** | **Live Frontend & Interactive Portal** | [![GitHub Pages](https://img.shields.io/badge/Live-GitHub%20Pages-brightgreen?logo=github)](https://shahompraksh.github.io/JobsPortal/) &bull; [https://shahompraksh.github.io/JobsPortal/](https://shahompraksh.github.io/JobsPortal/) |
| **Railway Cloud** | **Full-Stack Java EE (Tomcat 11 + MySQL)** | Permanent 24/7 Cloud Service with Docker & MySQL 8.4 |

---

## 🌟 Key Features

- **Verified Job Requisitions**: 24+ curated positions across Software Engineering, AI, UI/UX Design, Marketing, Healthcare, and Finance in Nepal.
- **Dynamic Job Search & Multi-Filter Engine**: Filter live openings by keyword, job category, location, employment type (Full-time, Part-time, Remote, Internship), and maximum NPR monthly salary.
- **Interactive Details & 1-Click Quick Apply**: Examine comprehensive job requirements and submit applications with simulated CV attachment.
- **Candidate & Admin Authentication**: 1-click test credentials for instant demo logins and profile session management.
- **Real-Time Application Status Tracker**: Monitor recruiter review statuses (Pending, Shortlisted, Hired) with real-time status badges and withdrawal capability.
- **Responsive CAD & Glassmorphic UI**: High-fidelity modern styling with sticky navigation, top employers running marquee ticker, animated number counters, and mobile-first layout.
- **Direct WhatsApp & Email Integration**: Floating WhatsApp quick connect (`+977 9761819137`) and direct inquiry routing.

---

## 📁 Project Architecture

```
JobsPortal/
├── .nojekyll                  # Bypasses Jekyll for GitHub Pages
├── index.html                 # Main Elevate Workforce landing page
├── findajob.html              # Interactive job search & filter board
├── contact.html               # Contact inquiries & WhatsApp direct link
├── login.html                 # Candidate & Admin sign-in with 1-click demo
├── register.html              # Candidate account registration
├── userdashboard.html         # Candidate personal dashboard
├── applications.html          # Real-time application tracker
├── css/
│   └── modern-style.css       # Complete modern design system
├── js/
│   ├── jobs-data.js           # 24 verified production jobs dataset
│   ├── modern-script.js       # Ticker, sticky navbar, counters, reveals
│   └── portal.js              # Client-side search, filters, modals, localStorage
├── images/                    # Logos, team photos, and brand assets
├── database/
│   ├── jobsportal.sql         # Base database schema
│   └── production_init.sql    # Production seed data (24 jobs, tables, admin)
├── src/java/                  # Jakarta EE Servlets, DAO, Models (Tomcat)
├── web/                       # Legacy JSP templates & WEB-INF/web.xml
├── Dockerfile                 # Tomcat 11 production image builder
└── docker-compose.yml         # Local containerized Tomcat + MySQL stack
```

---

## 💻 Local Hosting & Development

### 1. Static Web Hosting (Instant)

Run any local HTTP server in this directory:

```bash
# Using Python 3
python3 -m http.server 8000

# Or using Node.js
npx serve .
```

Visit `http://localhost:8000` in your web browser.

### 2. Full-Stack Java (Apache Tomcat 11 + MySQL)

1. Start MySQL and import the database schema:
   ```bash
   mysql -u root -p < database/production_init.sql
   ```
2. Build the WAR file:
   ```bash
   ant dist
   ```
3. Deploy `dist/JobsPortal.war` into Tomcat's `webapps/` directory (or use Docker):
   ```bash
   docker compose up --build -d
   ```
4. Access the full-stack portal at `http://localhost:8080/JobsPortal` (or `http://localhost:8080` when deployed as ROOT).

---

## 📞 Support & Contact

- **Lead Developer**: Om Prakash Shah
- **Email**: [shahomprakash2004@gmail.com](mailto:shahomprakash2004@gmail.com)
- **WhatsApp**: [+977 9761819137](https://wa.me/9779761819137)
- **Headquarters**: Kathmandu, Bagmati Province, Nepal
