# scripts/init-letsencrypt.sh
#!/bin/bash
set -e

# Check if domain is provided
if [ -z "$DOMAIN" ]; then
    echo "DOMAIN environment variable is not set."
    exit 1
fi

# Check if email is provided
if [ -z "$EMAIL" ]; then
    echo "EMAIL environment variable is not set."
    exit 1
fi

# Create certbot directory structure
mkdir -p "/etc/letsencrypt/live/$DOMAIN"
mkdir -p "/var/lib/letsencrypt"
mkdir -p "/var/log/letsencrypt"

# Request certificate
certbot certonly --standalone \
    --email "$EMAIL" \
    --agree-tos \
    --no-eff-email \
    --staging \
    -d "$DOMAIN"

# Copy certificates to mosquitto directory
cp "/etc/letsencrypt/live/$DOMAIN/privkey.pem" "/mosquitto/certs/server.key"
cp "/etc/letsencrypt/live/$DOMAIN/fullchain.pem" "/mosquitto/certs/server.crt"

# Set proper permissions
chown -R mosquitto:mosquitto /mosquitto/certs
chmod 600 /mosquitto/certs/server.key