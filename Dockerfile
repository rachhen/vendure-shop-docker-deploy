FROM node:16-alpine AS development

WORKDIR /usr/src/app

COPY package.json ./
COPY yarn.lock ./
RUN yarn
COPY . .
RUN yarn build

FROM node:16-alpine AS production

ARG NODE_ENV=production
ENV NODE_ENV=${NODE_ENV}

WORKDIR /usr/src/app

COPY package.json ./
COPY yarn.lock ./
COPY process.yml ./

RUN npm install -g concurrently
RUN npm install -g pm2

RUN yarn --production

COPY --from=development /usr/src/app/dist ./dist

CMD [ "pm2-runtime", "process.yml" ]