# Jobs Portal

## Database setup

Start MySQL, then import the included schema:

```sh
mysql -u root -p < database/jobsportal.sql
```

The application reads these optional environment variables (or Java system properties): `DB_URL`, `DB_USER`, and `DB_PASSWORD`. Defaults are `jdbc:mysql://127.0.0.1:3306/jobsportal?useSSL=false&serverTimezone=UTC`, `root`, and an empty password.

For example, to use a password:

```sh
export DB_PASSWORD='your-password'
```

## Build and deploy

Build the WAR with NetBeans, or run:

```sh
ant dist
```

Deploy `dist/JobsPortal.war` to Tomcat. The context path is `/JobsPortal` (or `/` when deployed as `ROOT.war`).

The initial admin login is `admin` / `admin`; change it before using the site outside local development.
