FROM grafana/grafana:7.1.5-ubuntu

ENV GF_AUTH_DISABLE_LOGIN_FROM "true"
ENV GF_AUTH_ANONYMOUS_ENABLED "true"
ENV GF_AUTH_ANONYMOUS_ORG_ROLE "Admin"

ADD ./provisioning /etc/grafana/provioning
ADD ./grafana.ini /etc/grafana/grafana.ini
ADD ./dashboards /etc/grafana/dashboards