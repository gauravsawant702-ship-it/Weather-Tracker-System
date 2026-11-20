FROM tomcat:11-jdk17-temurin
RUN rm -rf /usr/local/tomcat/webapps/*
COPY Weather_tracker.war /usr/local/tomcat/webapps/ROOT.war
COPY start.sh /start.sh
RUN chmod +x /start.sh
EXPOSE 10000
CMD ["/start.sh"]
