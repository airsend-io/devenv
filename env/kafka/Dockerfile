FROM wurstmeister/kafka

ENV PATH="$PATH:/root/.local/share/fnm"

RUN apt-get update &&  \
    apt-get install -y unzip && \
    curl -fsSL https://fnm.vercel.app/install | bash -s -- --skip-shell && \
    eval "$(fnm env --shell=bash)" && \
    fnm install 19 && \
    npm install -g pm2


RUN echo '# fnm' >> /root/.bashrc && \
    echo 'export PATH=/root/.fnm:$PATH' >> /root/.bashrc && \
    echo 'eval "$(fnm env --shell bash)"' >> /root/.bashrc

COPY init.sh /init.sh

CMD /bin/bash /init.sh
