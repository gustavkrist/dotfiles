FROM node:24-bookworm-slim

ARG PI_VERSION=latest

RUN apt-get update \
    && apt-get -y upgrade \
    && apt-get install -y --no-install-recommends bash ca-certificates curl git \
    && ln -s /usr/bin/fdfind /usr/local/bin/fd

RUN curl -fsSL https://pkgs.superlogical.com/rex/install.sh | sh

RUN npm install -g --ignore-scripts "@earendil-works/pi-coding-agent@${PI_VERSION}"
RUN npm install -g ketch-cli

RUN git clone https://github.com/OleksandrChekhovskyi/hax.git \
    && cd hax \
    && scripts/install_deps.sh \
    && make \
    && make install
RUN rm -rf hax

RUN apt-get install -y --no-install-recommends fd-find git ripgrep jq procps python3 \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /home/node/workspace

USER node
WORKDIR /home/node

RUN mkdir -p /home/node/.local/state

RUN rex terminfo setup
RUN git clone https://github.com/OleksandrChekhovskyi/hax-mcp \
    && cd hax-mcp \
    && ./install.sh
RUN echo 'export PATH=$HOME/.local/bin:$PATH' >> .bashrc

COPY .local/bin/hax /home/node/.local/bin/hax
RUN sed -is 's:/opt/homebrew:/usr/local:' /home/node/.local/bin/hax

WORKDIR /home/node/workspace
