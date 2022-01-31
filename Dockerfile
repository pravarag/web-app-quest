FROM node:10

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install

COPY . .

ENV SECRET_WORD="noSecret"

CMD ["node", "server.js"]