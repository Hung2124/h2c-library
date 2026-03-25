FROM eclipse-temurin:17-jdk-alpine AS builder
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN apk add --no-cache maven && \
    mvn package -DskipTests -q && \
    mv target/*.war target/library.war

FROM eclipse-temurin:17-jre-alpine
WORKDIR /app

# Install curl for health checks
RUN apk add --no-cache curl dumb-init

# Tomcat 10
ENV CATALINA_HOME /usr/local/tomcat
ENV PATH $CATALINA_HOME/bin:$PATH
RUN wget https://archive.apache.org/dist/tomcat/tomcat-10/v10.1.20/bin/apache-tomcat-10.1.20.tar.gz -O /tmp/tomcat.tar.gz && \
    mkdir -p $CATALINA_HOME && \
    tar -xf /tmp/tomcat.tar.gz -C $CATALINA_HOME --strip-components=1 && \
    rm /tmp/tomcat.tar.gz && \
    rm -rf $CATALINA_HOME/webapps/* && \
    chmod +x $CATALINA_HOME/bin/*.sh

# Copy WAR
COPY --from=builder /app/target/library.war $CATALINA_HOME/webapps/ROOT.war

# Expose port
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=5s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:8080/ || exit 1

# Run with dumb-init for proper signal handling
ENTRYPOINT ["dumb-init", "--"]
CMD ["sh", "-c", \
     "echo '=== Waiting for database ===' && \
      until curl -sf $${DATABASE_URL%@*} --max-time 2 > /dev/null 2>&1 || nc -z ${DB_HOST:-localhost} ${DB_PORT:-5432} 2>/dev/null; do \
        echo 'Database not ready, waiting...'; sleep 2; \
      done && \
      echo 'Database ready, starting Tomcat...' && \
      $CATALINA_HOME/bin/catalina.sh run"]
