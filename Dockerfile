# A custom Image which  contains
# Helm, Kubectl, and Halyard
FROM ubuntu:16.04

# bring sudo back damn it
RUN apt-get update && apt-get install -y sudo && rm -rf /var/lib/apt/lists/*

RUN sudo apt-get update && sudo apt-get install -y curl
RUN apt-get install -y software-properties-common python-software-properties
RUN sudo apt-get install -y apt-transport-https

# add hal user with password: pass@word1 (super crackable) encrypted
RUN useradd -m -p VO8RhrX/QqnUw -s /bin/bash hal

# add hal user to the sudo group
RUN sudo usermod -aG sudo hal

#make sure no password is required for the hal account when sudo is used
RUN echo "hal ALL=NOPASSWD: ALL" >> /etc/sudoers

RUN echo "========== installing Halyard ======================="
RUN curl -Lo InstallHalyard.sh https://raw.githubusercontent.com/spinnaker/halyard/master/install/debian/InstallHalyard.sh

RUN chmod u+x InstallHalyard.sh
RUN sudo bash InstallHalyard.sh --user hal

RUN hal -v

RUN echo "========== installing Helm ======================="
RUN curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get > get_helm.sh
RUN chmod 700 get_helm.sh
RUN ./get_helm.sh

RUN echo "========== installing Kubectl ======================="
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
RUN chmod +x ./kubectl
RUN sudo mv ./kubectl /usr/local/bin/kubectl



CMD ["/bin/bash"]