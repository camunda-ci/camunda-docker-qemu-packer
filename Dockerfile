FROM camunda-ci1:5000/camunda-ci-base-ubuntu:latest

ENV PACKER_VERSION=0.7.5 \
    OUTPUT_DIR=/packer-output
RUN save-env.sh PACKER_VERSION OUTPUT_DIR

VOLUME $OUTPUT_DIR

# add helper script
ADD bin/* /usr/local/bin/

# install qemu
RUN install-packages.sh make qemu-system-x86 qemu-utils bridge-utils ruby build-essential && \
    gem install berkshelf

# add packer binaries
RUN curl -L https://bintray.com/artifact/download/mitchellh/packer/packer_${PACKER_VERSION}_linux_amd64.zip > /tmp/packer.zip && \
    unzip /tmp/packer.zip -d /usr/local/bin/ && \
    rm /tmp/packer.zip

CMD ["/usr/local/bin/start-supervisord.sh"]
