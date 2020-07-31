FROM node:12

ENV DEBIAN_FRONTEND noninteractive

# Create app directory
WORKDIR /usr/src/app

# Install server dependencies
RUN apt update -y && apt install -y krb5-user

# Copy startup script
COPY startup.sh /startup.sh

# Copy wait-for-it.sh for waiting starting services which node server depends on.
COPY wait-for-it.sh /wait-for-it.sh

EXPOSE 3000

CMD [ "/startup.sh" ]
