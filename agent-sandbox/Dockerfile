FROM node:24-bookworm-slim

ARG PI_VERSION=latest

RUN apt-get update \
    && apt-get -y upgrade \
    && apt-get install -y --no-install-recommends bash ca-certificates curl git \
    && ln -s /usr/bin/fdfind /usr/local/bin/fd

RUN curl -fsSL https://pkgs.superlogical.com/rex/install.sh | sh

RUN npm install -g --ignore-scripts "@earendil-works/pi-coding-agent@${PI_VERSION}"
RUN npm install -g ketch-cli

RUN git clone https://github.com/gustavkrist/hax.git \
    && cd hax \
    && scripts/install_deps.sh \
    && make \
    && make install
RUN rm -rf hax

RUN apt-get install -y --no-install-recommends fd-find git ripgrep jq procps python3 \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /home/node/workspace
RUN mkdir -p /home/linuxbrew/.linuxbrew
RUN chown node:node /home/linuxbrew/.linuxbrew

USER node
WORKDIR /home/node

RUN mkdir -p /home/node/.local/state

RUN rex terminfo setup
RUN git clone https://github.com/OleksandrChekhovskyi/hax-mcp \
    && cd hax-mcp \
    && ./install.sh
RUN echo 'export PATH=$HOME/.local/bin:$PATH' >> .bashrc

RUN bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
RUN echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> .bashrc
RUN echo 'export HOMEBREW_NONINTERACTIVE=1' >> .bashrc
RUN echo 'export EDITOR=nvim' >> .bashrc

COPY .local/bin/hax /home/node/.local/bin/hax
RUN sed -is 's:$HOME/programs/hax/build:/usr/local/bin:' /home/node/.local/bin/hax

RUN bash -c "/home/linuxbrew/.linuxbrew/bin/brew install neovim"

WORKDIR /home/node/workspace
