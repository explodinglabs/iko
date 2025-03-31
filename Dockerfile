FROM sqitch/sqitch:v1.5.1.0

COPY ./templates /etc/sqitch/templates
COPY ./aliases.sh /etc/bash_aliases
ENV BASH_ENV=/etc/bash_aliases

ENTRYPOINT []
CMD []
