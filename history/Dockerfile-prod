FROM node:25-alpine3.22

WORKDIR /usr/src/app
COPY package*.json ./
RUN npm ci --omit=dev
COPY ./src ./src

CMD ["npm", "start"]

