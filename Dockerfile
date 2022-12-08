# Base image
FROM alpine:latest

# installes required packages for our script
RUN apk add --no-cache bash 
# patch \
#   wget \
#   jq

# RUN wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O /usr/bin/yq &&\
#     chmod +x /usr/bin/yq

# Copies your code file  repository to the filesystem
COPY entrypoint.sh /entrypoint.sh

# change permission to execute the script and
RUN chmod +x /entrypoint.sh

# file to execute when the docker container starts up
ENTRYPOINT ["/entrypoint.sh"]