FROM node:18-alpine

WORKDIR /app

COPY package.json .
RUN npm install

COPY index.js .

# Keep container alive so we can 'docker exec' into it
CMD ["tail", "-f", "/dev/null"]
