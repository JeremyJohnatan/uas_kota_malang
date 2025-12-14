FROM nginx:alpine

# Install curl for healthchecks
RUN apk add --no-cache curl

# Remove default nginx config
RUN rm /etc/nginx/conf.d/default.conf

# Copy custom nginx config will be done via volume mount

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]