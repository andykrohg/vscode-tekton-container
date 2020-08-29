FROM registry.access.redhat.com/ubi8

ENV GLIBC_VERSION=2.30-r0 

ENV HOME=/home/theia

RUN mkdir /projects ${HOME} && \
    # Change permissions to let any arbitrary user
    for f in "${HOME}" "/etc/passwd" "/projects"; do \
      echo "Changing permissions on ${f}" && chgrp -R 0 ${f} && \
      chmod -R g+rwX ${f}; \
    done

# the plugin executes the commands relying on Bash
RUN dnf install -y bash && \
    curl -LO https://github.com/tektoncd/cli/releases/download/v0.12.0/tkn_0.12.0_Linux_x86_64.tar.gz && \
    tar xvzf tkn_0.12.0_Linux_x86_64.tar.gz -C /usr/local/bin/ tkn && \
    chmod +x /usr/local/bin/tkn && \
    curl -L -o ./usr/local/bin/kubectl "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl" && \
    chmod +x /usr/local/bin/kubectl && \
    curl -LO https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/openshift-client-linux.tar.gz && \
    tar xvzf openshift-client-linux.tar.gz -C /usr/local/bin/ oc && \
    chmod +x /usr/local/bin/oc

ADD etc/entrypoint.sh entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
CMD ${PLUGIN_REMOTE_ENDPOINT_EXECUTABLE}