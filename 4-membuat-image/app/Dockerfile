FROM node:12-alpine
WORKDIR /app
COPY yarn.lock package.json ./
RUN yarn install --production
COPY . .
CMD ["node", "src/index.js"]