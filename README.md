# docker-tomcat


#### debugger
 jdk 1.5-1.8
 > docker run ..... -e CATALINA_OPTS='-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5005' ...

 jdk 1.4
 > docker run ..... -e CATALINA_OPTS='-Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=5005' ...

