FROM postgres

USER root

WORKDIR /opt/_data

ENV VERSION 20191202

ADD *.sh /opt/
ADD *.py /opt/
ADD *.json /opt/
ADD *.sql /opt/

WORKDIR /opt

RUN chmod +x *.sh && chmod 777 /opt/_data && mkdir /data && chown postgres /data && \
    chmod 700 /data && chmod 777 /opt && chmod 777 /opt/*

USER root

RUN apt update && apt install -y wget pgdbf python3 && \
    wget http://ftp.br.debian.org/debian/pool/non-free/u/unrar-nonfree/unrar_5.3.2-1+deb9u1_amd64.deb && dpkg -i unrar*.deb && \
    apt-get clean && rm -rf /var/cache/apt

USER postgres

WORKDIR /opt/_data

RUN wget http://data.nalog.ru/Public/Downloads/$VERSION/fias_dbf.rar && unrar x *.rar && \
    /docker-entrypoint.sh initdb && \
    cp -R /var/lib/postgresql/data/* /data/ && \
    chmod 700 /data && pg_ctl -D /data/ -l /tmp/logfile start && \
    psql -c "create role fias with login password 'fias'" && \
    psql -c "create database fias owner fias" && cd .. && \
    ./import.sh fias && \
    python3 update_schema.py && psql fias -f update_schema.sql && \
    psql fias -f  indexes.sql && pg_ctl -D /data/ stop && \
    rm -rf /opt/_data && pg_ctl -D /data/ -l /tmp/logfile start && \
    psql -Upostgres fias -c 'alter table addrobj owner to fias;' && \
    psql -Upostgres fias -c 'alter table centerst owner to fias;' && \
    psql -Upostgres fias -c 'alter table curentst owner to fias;' && \
    psql -Upostgres fias -c 'alter table daddrob owner to fias;' && \
    psql -Upostgres fias -c 'alter table dhouse owner to fias;' && \
    psql -Upostgres fias -c 'alter table flattype owner to fias;' && \
    psql -Upostgres fias -c 'alter table house owner to fias;' && \
    psql -Upostgres fias -c 'alter table nordoc owner to fias;' && \
    psql -Upostgres fias -c 'alter table operstat owner to fias;' && \
    psql -Upostgres fias -c 'alter table socrbase owner to fias;' && \
    psql -Upostgres fias -c 'alter table stead owner to fias;' && \
    echo "host fias fias 0.0.0.0/0 trust" >>/data/pg_hba.conf && \
    pg_ctl -D /data/ stop

CMD postgres -D /data
