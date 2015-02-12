FROM camunda-ci1:5000/camunda-ci-base-ubuntu:latest

ENV PACKER_VERSION=0.7.5 \
    CHEF_DK_VERSION=0.4.0-1 \
    OUTPUT_DIR=/packer-output
RUN save-env.sh PACKER_VERSION CHEF_DK_VERSION OUTPUT_DIR

# allow everyone to write to OUTPUT_DIR
RUN mkdir $OUTPUT_DIR && \
    chmod 777 $OUTPUT_DIR

# mark OUTPUT_DIR as volume so the content is discarded
VOLUME $OUTPUT_DIR

# add helper script
ADD bin/* /usr/local/bin/

# install qemu
RUN install-packages.sh make qemu-system-x86 qemu-utils bridge-utils && \
    chmod u+s /usr/lib/qemu-bridge-helper && \
    usermod -aG kvm camunda

# add packer binaries
RUN curl ftp://camunda-ci1/ci/binaries/packer/packer_${PACKER_VERSION}_linux_amd64.zip > /tmp/packer.zip && \
    unzip /tmp/packer.zip -d /usr/local/bin/ && \
    rm /tmp/packer.zip

# install chef dk
RUN curl ftp://camunda-ci1/ci/binaries/chef/chefdk_${CHEF_DK_VERSION}_amd64.deb > /tmp/chefdk.deb && \
    dpkg --install /tmp/chefdk.deb && \
    rm /tmp/chefdk.deb

CMD ["/usr/local/bin/start-supervisord.sh"]
