FROM sqitch/sqitch:v1.5.1.0

# Install Bat (batcat), to print files
USER root
RUN apt-get update
RUN apt-get install -y bat vim
USER sqitch

# Configure Vim
COPY ./.vim/sql.vim /home/.vim/after/ftplugin/sql.vim
COPY ./.vim/vimrc /home/.vimrc
ENV SQITCH_EDITOR='vim -o'

# Copy templates and shell functions
COPY ./templates /etc/sqitch/templates
COPY ./bash_aliases /etc/bash_aliases
ENV BASH_ENV=/etc/bash_aliases

# Add scripts directory to $PATH
ENV PATH="/scripts:${PATH}"

ENTRYPOINT []
CMD []

