FROM tomcat:8.0-jre8

## timedatectl list-timezones |grep Shanghai    #find time zones name
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

ARG WAR_FILE=app.war
ARG CONTEXT_PATH=ROOT
ARG PORT=8080

ENV TOMCAT_HOME=/usr/local/tomcat

RUN sed -i 's/8005/-1/g' ${TOMCAT_HOME}/conf/server.xml \
    && sed -i /8009/d ${TOMCAT_HOME}/conf/server.xml \
    && sed -i "s/8080/${PORT}/g" ${TOMCAT_HOME}/conf/server.xml \
    && sed -i '/\/Host/i\        <Valve className="org.apache.catalina.valves.RemoteIpValve"' ${TOMCAT_HOME}/conf/server.xml \
    && sed -i '/\/Host/i\               protocolHeader="X-Forwarded-Proto"' ${TOMCAT_HOME}/conf/server.xml \
    && sed -i '/\/Host/i\               remoteIpHeader="X-Forwarded-For"' ${TOMCAT_HOME}/conf/server.xml \
    && sed -i '/\/Host/i\               protocolHeaderHttpsValue="https" />' ${TOMCAT_HOME}/conf/server.xml

ADD ${WAR_FILE} ROOT.war

RUN set -e \
    && rm -rf ${TOMCAT_HOME}/webapps/* && unzip -q -d ${TOMCAT_HOME}/webapps/${CONTEXT_PATH} ROOT.war && rm ROOT.war

COPY config/ ${TOMCAT_HOME}/webapps/${CONTEXT_PATH}/WEB-INF/

EXPOSE $PORT
VOLUME /tmp
VOLUME ${TOMCAT_HOME}/webapps/

## ["",""] 格式可以实现  docker 优雅关机

