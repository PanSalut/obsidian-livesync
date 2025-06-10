# Use CouchDB as the base image
FROM couchdb:3.4.2

# Set environment variables
ENV COUCHDB_USER=admin
ENV COUCHDB_PASSWORD=admin

# Create necessary directories
RUN mkdir -p /opt/couchdb/data /opt/couchdb/etc

# Copy configuration files
COPY local.ini /opt/couchdb/etc/local.ini

# Set ownership
RUN chown -R couchdb:couchdb /opt/couchdb/data /opt/couchdb/etc

# Expose port
EXPOSE 5984

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
  CMD curl -f -u ${COUCHDB_USER}:${COUCHDB_PASSWORD} http://localhost:5984/_up || exit 1

# Start CouchDB
CMD ["/docker-entrypoint.sh", "/opt/couchdb/bin/couchdb"]