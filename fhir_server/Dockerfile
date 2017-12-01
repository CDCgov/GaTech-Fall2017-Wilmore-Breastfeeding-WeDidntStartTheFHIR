FROM djohnson325/hapi-fhir-jpaserver:stu3

USER root 
RUN apk update \
    && apk upgrade \
    && apk add --no-cache bash curl
EXPOSE 80 8080


ADD entrypoint.sh /root/
RUN chmod +x /root/entrypoint.sh
ADD addpatients.sh /root/

#ADD portal.war /var/lib/jetty/webapps/
ENTRYPOINT ["/root/entrypoint.sh"]
