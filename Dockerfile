FROM mhart/alpine-node:latest

ADD . /cpxstats
WORKDIR /cpxstats

RUN npm install && npm install -g grunt-cli && grunt

EXPOSE  3000
CMD ["npm", "start"]
