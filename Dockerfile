FROM sqitch/sqitch:v1.5.1.0

# Install Bat
USER root
RUN apt-get update
RUN apt-get install -y bat
USER sqitch

COPY ./templates /etc/sqitch/templates
COPY ./bash_aliases /etc/bash_aliases
ENV BASH_ENV=/etc/bash_aliases

ENTRYPOINT []
CMD []
