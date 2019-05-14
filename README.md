# docker-tomcat

#### version
 This is 'FROM tomcat:8.0-jre8'. If you want other version, see https://hub.docker.com/_/tomcat

#### Tomcat remote debugger
 jdk 1.5-1.8
 > docker run ..... -e CATALINA_OPTS='-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5005' ...

 jdk 1.4
 > docker run ..... -e CATALINA_OPTS='-Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=5005' ...

