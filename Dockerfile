# ================================================================
# Multi-Stage Production Dockerfile for JobsPortalAssignment
# Runs on Apache Tomcat 11 (Jakarta EE 10) + OpenJDK 21
# ================================================================

# ── Stage 1: Build WAR from source using Apache Ant ─────────────
FROM tomcat:11.0-jdk21-temurin-jammy AS builder

WORKDIR /workspace

# Install Apache Ant build tool
RUN apt-get update && \
    apt-get install -y --no-install-recommends ant && \
    rm -rf /var/lib/apt/lists/*

# Copy full project source and libraries
COPY . .

# Build production WAR using Tomcat's server libs
RUN ant -Dj2ee.server.domain=/usr/local/tomcat dist

# ── Stage 2: Production Apache Tomcat 11 Runtime ────────────────
FROM tomcat:11.0-jdk21-temurin-jammy

LABEL maintainer="Elevate Workforce Solutions"
LABEL description="Elevate Jobs Portal — Tomcat 11 + MySQL"

WORKDIR /usr/local/tomcat

# Remove default boilerplate Tomcat apps
RUN rm -rf webapps/*

# Deploy WAR to ROOT (domain root /), /JobsPortal, and /JobsPortalAssignment
COPY --from=builder /workspace/dist/JobsPortal.war webapps/ROOT.war
COPY --from=builder /workspace/dist/JobsPortal.war webapps/JobsPortal.war
COPY --from=builder /workspace/dist/JobsPortal.war webapps/JobsPortalAssignment.war

# Copy dynamic port entrypoint script
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Expose default HTTP port
EXPOSE 8080

# Run entrypoint
ENTRYPOINT ["docker-entrypoint.sh"]
