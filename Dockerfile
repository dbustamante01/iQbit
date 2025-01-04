FROM --platform=$TARGETPLATFORM node:22-slim as build
ARG TARGETPLATFORM
ENV QBIT_HOST=http://localhost:8080
WORKDIR /usr/src/node-app
COPY . ./
RUN npm install react-virtualized
RUN npm install
RUN npm run build

FROM --platform=$TARGETPLATFORM node:22-slim as runner
ARG TARGETPLATFORM
ENV NODE_ENV=production
ENV QBIT_HOST=http://localhost:8080
WORKDIR /usr/src/node-app
COPY --from=build /usr/src/node-app ./
RUN npm install
RUN npm run server-setup

EXPOSE 8081

CMD [ "npm", "run", "server-docker-start" ]
