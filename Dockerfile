# ================================================================
# Production Dockerfile for Elevate JobsPortal
# Runs on Apache Tomcat 11 (Jakarta EE 10) + OpenJDK 21
# ================================================================
FROM tomcat:11.0-jdk21-temurin-jammy

LABEL maintainer="Elevate Workforce Solutions"
LABEL description="Elevate Jobs Portal — Tomcat 11 + MySQL"

WORKDIR /usr/local/tomcat

# Remove default boilerplate Tomcat apps
RUN rm -rf webapps/*

# Deploy pre-built production WAR to ROOT (domain root /) and /JobsPortal
COPY dist/JobsPortal.war webapps/ROOT.war
COPY dist/JobsPortal.war webapps/JobsPortal.war

# Copy dynamic port entrypoint script
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Expose default HTTP port
EXPOSE 8080

# Run entrypoint
ENTRYPOINT ["docker-entrypoint.sh"]
