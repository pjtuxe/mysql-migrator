FROM mysql/mysql-server:8.0

ADD migrate.sh /migrate.sh
RUN mkdir /docker-entrypoint-migrations.d
VOLUME /docker-entrypoint-migrations.d

CMD /migrate.sh
