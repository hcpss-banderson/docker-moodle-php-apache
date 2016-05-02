FROM williamyeh/ansible:debian8

MAINTAINER brendan_anderson@hcpss.org

LABEL vendor=Howard\ County\ Public\ Schools \
  org.hcpss.version="1.0.0" \
  org.hcpss.name="moodle_webserver"
  
ADD ansible /srv/provisioning

# Run the provisioning playbook.
RUN ansible-galaxy install -r /srv/provisioning/requirements.yml \
  && ansible-playbook /srv/provisioning/provision.yml -v -c local
  
# Remove ansible and provisioning locations, which may contain secrets
RUN rm -rf /srv/provisioning

COPY apache2-foreground /usr/local/bin/
COPY docker-entrypoint.sh /entrypoint.sh

VOLUME ["/var/www"]

ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 80 443
CMD ["apache2-foreground"]
