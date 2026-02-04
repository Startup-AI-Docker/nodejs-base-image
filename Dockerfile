# Node.js Base Image - Alpine optimized
# Provides a secure, minimal base for Node.js applications

FROM node:22-alpine

# Security labels
LABEL org.opencontainers.image.title="Node.js Base Image" \
      org.opencontainers.image.description="Secure, minimal Node.js base image" \
      org.opencontainers.image.vendor="Startup AI Infrastructure"

# Install tini and apply security updates
RUN apk update && apk upgrade --no-cache && \
    apk add --no-cache tini && \
    rm -rf /var/cache/apk/* /tmp/* /var/tmp/*

# Create non-root user for security
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nodejs -u 1001 -G nodejs -h /app -s /sbin/nologin

# Security: Set restrictive umask
RUN echo "umask 027" >> /etc/profile

# Set working directory
WORKDIR /app

# Set ownership to non-root user
RUN chown -R nodejs:nodejs /app

# Environment hardening
ENV NODE_ENV=production \
    NPM_CONFIG_LOGLEVEL=warn \
    NPM_CONFIG_UPDATE_NOTIFIER=false \
    NPM_CONFIG_FUND=false \
    NPM_CONFIG_AUDIT=false \
    HOME=/app

# Switch to non-root user
USER nodejs

# Use tini as PID 1 for proper signal handling
ENTRYPOINT ["/sbin/tini", "--"]

# Default command (can be overridden)
CMD ["node"]
