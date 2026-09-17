# 🚀 24/7 Permanent Cloud Deployment Guide

This guide walks you through permanently deploying your **Elevate Jobs Portal** (Apache Tomcat 11 + MySQL) to the cloud so it stays online 24/7 even when your computer is off.

---

## 🌟 Method 1: Deploy on Railway (Recommended — Fastest & Easiest)

Railway is the best cloud platform for Java + MySQL. It provides 1-click cloud MySQL, automatically builds your `Dockerfile`, and gives you a free `https://<your-app>.up.railway.app` public domain with automatic SSL.

### Step 1: Push Your Code to GitHub

Open a terminal in your project directory and push your code to your GitHub account:

```bash
# Initialize git if not already done
git init
git add .
git commit -m "feat: production cloud deployment setup"

# Link to your GitHub repository (replace with your repo URL)
git branch -M main
git remote add origin https://github.com/<your-username>/JobsPortal.git
git push -u origin main
```

*(If you already have a GitHub repository, simply run `git add . && git commit -m "Add Docker deployment" && git push`).*

---

### Step 2: Create a Project on Railway

1. Go to [https://railway.app](https://railway.app) and sign in with GitHub.
2. Click **"+ New Project"**.
3. Choose **"Provision MySQL"**.
   - Railway will instantly launch a managed cloud MySQL database in ~5 seconds.

---

### Step 3: Import Your Database Tables & Seed Data

1. Click on the **MySQL** card in your Railway project canvas.
2. Go to the **"Data"** tab.
3. You can import your SQL directly:
   - Click **"Query"** or **"Import SQL"**, open the file [`database/production_init.sql`](database/production_init.sql), copy its contents, and run it.
   - *Alternatively, connect using MySQL Workbench, DBeaver, or TablePlus using the public connection credentials shown in the "Connect" tab.*

---

### Step 4: Deploy Your Web Application

1. In the same Railway project canvas, click **"+ New"** (top right) &rarr; **"GitHub Repo"**.
2. Select your **`JobsPortal`** repository.
3. Railway will automatically detect the [`Dockerfile`](Dockerfile) and begin building your Tomcat 11 application!

---

### Step 5: Connect Database & Generate Your Public Domain

1. Click on your newly deployed web service card.
2. Go to the **"Variables"** tab:
   - Click **"Add Variable Reference"** (or "+ New Variable").
   - Link the MySQL variables:
     - `MYSQLHOST` &rarr; `${{MySQL.MYSQLHOST}}`
     - `MYSQLPORT` &rarr; `${{MySQL.MYSQLPORT}}`
     - `MYSQLUSER` &rarr; `${{MySQL.MYSQLUSER}}`
     - `MYSQLPASSWORD` &rarr; `${{MySQL.MYSQLPASSWORD}}`
     - `MYSQLDATABASE` &rarr; `${{MySQL.MYSQLDATABASE}}`
     - `MYSQL_URL` &rarr; `${{MySQL.MYSQL_URL}}`
   *(Railway can also share all MySQL variables automatically by clicking "Add Reference" &rarr; "MySQL")*
3. Go to the **"Settings"** tab:
   - Scroll down to **"Networking"** &rarr; **"Public Networking"**.
   - Click **"Generate Domain"**.
4. Railway will generate your public HTTPS URL (e.g. `https://jobsportalassignment-production.up.railway.app`).

**That's it! Your website is live 24/7 on the internet!** 🎉

---

## 🐳 Method 2: Run with Docker Compose (Local or any Cloud VPS)

If you have Docker Desktop or are deploying to your own cloud server (DigitalOcean droplet, AWS EC2, Linode, or Hetzner VPS):

1. Make sure Docker is running.
2. Run:
   ```bash
   docker compose up --build -d
   ```
3. Docker will:
   - Start a MySQL 8.4 container with persistent storage.
   - Automatically initialize all tables from `database/production_init.sql`.
   - Build and start Tomcat 11 with your application.
4. Access the site at: `http://localhost:8080` (or `http://<your-server-ip>:8080`).

To stop:
```bash
docker compose down
```

---

## ⚙️ Cloud Environment Variables Reference

Your application's [`AppConfig.java`](src/java/util/AppConfig.java) automatically supports these environment variables:

| Variable | Description | Example |
| :--- | :--- | :--- |
| `MYSQLHOST` or `DB_HOST` | Cloud MySQL host | `roundhouse.proxy.rlwy.net` |
| `MYSQLPORT` or `DB_PORT` | Cloud MySQL port | `3306` or `12345` |
| `MYSQLUSER` or `DB_USER` | MySQL user | `root` |
| `MYSQLPASSWORD` or `DB_PASSWORD` | MySQL password | `secretpassword` |
| `MYSQLDATABASE` or `DB_NAME` | Database name | `jobsportal` or `railway` |
| `DATABASE_URL` or `MYSQL_URL` | Combined connection URI | `mysql://root:pass@host:3306/db` |
| `PORT` | HTTP Port (assigned by host) | `8080` (default) |
| `APP_BASE_URL` | Public base URL | `https://your-domain.up.railway.app` |
| `SMTP_USER` | Gmail address for emails | `you@gmail.com` |
| `SMTP_PASSWORD` | 16-char Google App Password | `abcd efgh ijkl mnop` |
