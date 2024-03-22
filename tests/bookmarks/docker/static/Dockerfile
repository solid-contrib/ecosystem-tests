FROM node:18
ARG REPO=https://github.com/michielbdejong/markbook
RUN git clone ${REPO} app
WORKDIR app
RUN npm install serve
CMD npx serve
EXPOSE 3000