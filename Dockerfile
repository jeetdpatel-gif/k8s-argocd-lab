# Pure static NGINX - Vanilla HTML/JS/CSS AWS Exam POC
FROM nginx:alpine-slim

# Install wget & bash for healthcheck
RUN apk add --no-cache wget bash

# Remove default nginx html
RUN rm -rf /usr/share/nginx/html/*

# Copy static files
COPY . /usr/share/nginx/html/

# Copy custom nginx.conf
COPY nginx.conf /etc/nginx/nginx.conf

# Expose port
EXPOSE 80

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost/health || exit 1

# Run NGINX
CMD ["nginx", "-g", "daemon off;"]
