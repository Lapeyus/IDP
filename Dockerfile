FROM nginx

COPY run.sh .

ARG BUILDARCH

RUN chmod +x run.sh \
 && curl -LO "https://dl.k8s.io/release/v1.25.0/bin/linux/$BUILDARCH/kubectl" \
 && install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl \
 && apt-get update && apt-get install -y jq

CMD ["/bin/bash", "-c", "nginx; ./run.sh"]
