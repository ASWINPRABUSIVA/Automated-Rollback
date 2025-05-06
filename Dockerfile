# Use a basic web server for demo (like NGINX or Node)
FROM nginx:alpine
COPY app/ /usr/share/nginx/html
