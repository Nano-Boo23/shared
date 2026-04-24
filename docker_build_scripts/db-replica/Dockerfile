FROM postgres:15

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

USER postgres
ENTRYPOINT ["/entrypoint.sh"]
