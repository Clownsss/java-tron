FROM ubuntu

ENV BASE_DIR="/java-tron"
ENV JAVA_TAR="jdk1.8.0_275-linux-x64"
ENV JAVA_DIR="java-linux-x64"

RUN apt-get update \
    && apt-get install -y wget unzip \
    && cd /usr/local \
    && wget https://installbuilder.com/java/liberica-$JAVA_TAR.zip \
    && unzip liberica-$JAVA_TAR.zip \
    && mv $JAVA_TAR/$JAVA_DIR . \
    && rm -fr liberica-$JAVA_TAR \
    && rm -fr liberica-$JAVA_VER

COPY . $BASE_DIR
RUN cd $BASE_DIR \
    && export JAVA_HOME=/usr/local/$JAVA_DIR \
    && export PATH="$JAVA_HOME/bin:$PATH" \
    && echo "PATH=$PATH" > /etc/environment \
    && echo "JAVA_HOME=$JAVA_HOME" >> /etc/environment \
    && cd $BASE_DIR \
    && ./gradlew build -x test

COPY docker-entrypoint.sh /usr/bin
RUN chmod +x /usr/bin/docker-entrypoint.sh
WORKDIR $BASE_DIR

ENTRYPOINT ["docker-entrypoint.sh"]
