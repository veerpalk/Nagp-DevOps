FROM tomcat:alpine
MAINTAINER VeerpalKaur
COPY target/devopssampleapplication.war /usr/local/tomcat/webapps/veerpalkaur.war
EXPOSE 8080
CMD /usr/local/tomcat/bin/catalina.sh run