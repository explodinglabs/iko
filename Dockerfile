FROM sqitch/sqitch:v1.5.1.0
LABEL maintainer="support@explodinglabs.com" \
      org.opencontainers.image.title="iko" \
      org.opencontainers.image.version="0.1.0" \
      org.opencontainers.image.source="https://github.com/explodinglabs/iko" \
      org.opencontainers.image.licenses="MIT"

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

# Custom entrypoint script, to ensure bash aliases are loaded and bash shell is used instead of sh
COPY entry.sh /usr/local/bin/iko-entry.sh
USER root
RUN chmod +x /usr/local/bin/iko-entry.sh
USER sqitch
ENTRYPOINT ["/usr/local/bin/iko-entry.sh"]
CMD []
