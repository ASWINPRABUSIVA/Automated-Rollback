#!/bin/bash
set -e

APP_URL="http://your-app-url/health"  # Replace with your real service endpoint

HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$APP_URL")

if [ "$HTTP_STATUS" -eq 200 ]; then
    echo "Health check passed"
    exit 0
else
    echo "Health check failed"
    exit 1
fi
