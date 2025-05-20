FROM sqitch/sqitch:v1.5.1.0

ARG IKO_VERSION
RUN if [ -z "$IKO_VERSION" ]; then echo "IKO_VERSION build arg is required" >&2; exit 1; fi

LABEL maintainer="support@explodinglabs.com" \
      org.opencontainers.image.title="iko" \
      org.opencontainers.image.version=$IKO_VERSION \
      org.opencontainers.image.source="https://github.com/explodinglabs/iko" \
      org.opencontainers.image.licenses="MIT"

# Start as root, needed to write files
USER root

# Write version to a file
RUN echo "$IKO_VERSION" > /iko_version.txt

# Copy templates and shell functions
COPY ./templates /etc/sqitch/templates
COPY ./bash_aliases /etc/bash_aliases
ENV BASH_ENV=/etc/bash_aliases

# Add scripts directory to $PATH
ENV PATH="/scripts:${PATH}"

# Install Bat (batcat), to print files
RUN apt-get update
RUN apt-get install -y bat vim

# Configure Vim
COPY ./.vim/sql.vim /home/.vim/after/ftplugin/sql.vim
COPY ./.vim/vimrc /home/.vimrc
ENV SQITCH_EDITOR='vim -o'

# Custom entrypoint script, to ensure bash aliases are loaded and bash shell is
# used instead of sh
COPY entry.sh /usr/local/bin/iko-entry.sh
RUN chmod +x /usr/local/bin/iko-entry.sh

# Switch to sqitch user for running container (default for the Sqitch
# container)
USER sqitch

ENTRYPOINT ["/usr/local/bin/iko-entry.sh"]
CMD []
