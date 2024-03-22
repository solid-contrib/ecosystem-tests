FROM node:20
ARG REPO=https://github.com/pdsinterop/launcher-exploration
RUN git clone ${REPO} app
WORKDIR app
RUN git checkout for-ecosystem-tests
RUN npm install --legacy-peer-deps serve
ENV NODE_OPTIONS --openssl-legacy-provider
RUN npm run build
WORKDIR build
CMD npx serve
EXPOSE 3000
