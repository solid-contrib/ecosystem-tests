FROM ubuntu
RUN apt-get update
RUN apt-get install -y git
RUN apt-get install -y curl
RUN wget -qO- https://get.pnpm.io/install.sh | ENV="$HOME/.shrc" SHELL="$(which sh)" sh -
RUN git clone https://github.com/janeirodigital/sai-js
WORKDIR /sai-js
RUN pnpm build
CMD pnpm run watch && pnpm run dev

