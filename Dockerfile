FROM 	fabionitto/openvas-base-libraries:8.0.6
MAINTAINER Fabio Nitto "fabio.nitto@gmail.com"

# Include Environment for certs configuration?
# ENV OPENVAS_CERT_DATA

RUN apt-get update && apt-get -y install \
	libsqlite3-dev && \
	apt-get clean 

RUN mkdir /src && \
	cd /src && \
	wget http://wald.intevation.org/frs/download.php/2266/openvas-scanner-5.0.5.tar.gz -O openvas-scanner.tar.gz 2> /dev/null && \
	tar xvzf openvas-scanner.tar.gz && \
	cd /src/openvas-scanner-* && \
	mkdir build && \
	cd build && \
	cmake .. && \
	make && \
	make install && \
	make rebuild_cache && \
	cd / && \
	rm -rf /src && \
	openvas-mkcert -f -q && \
	openvas-mkcert-client -n -i && \
	openvas-nvt-sync

VOLUME /usr/local/var/lib/openvas/plugins /usr/local/var/lib/openvas/CA /usr/local/var/lib/openvas/private

ENTRYPOINT ["openvassd", "-f"]

EXPOSE 9391

