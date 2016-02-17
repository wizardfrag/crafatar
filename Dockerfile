FROM node:5
MAINTAINER David White <wizardfrag@minechasm.com>

# Update apt
RUN apt-get update && apt-get -y upgrade

# Install dependencies
RUN apt-get install -y git python-pip libcairo2-dev libjpeg-dev libpango1.0-dev libgif-dev build-essential g++ nginx redis-server
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN npm install -g forever

RUN mkdir /app

# Install node dependencies
ADD package.json /app/package.json
RUN cd /app && npm install

# Add the app
ADD . /app

# Add the default config file
ADD config.example.js /app/config.js

WORKDIR /app

# Set up environment
ENV BIND 0.0.0.0
ENV PORT 5000

EXPOSE 5000

RUN useradd crafatar

RUN chown -R crafatar:crafatar /app/images

USER crafatar

CMD ["npm", "start"]
