FROM sqitch/sqitch:v1.5.1.0

COPY ./templates /etc/sqitch/templates
COPY ./aliases.sh /aliases.sh
ENV BASH_ENV=/aliases.sh

ENTRYPOINT ""
CMD sqitch deploy
