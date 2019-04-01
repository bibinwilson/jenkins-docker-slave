FROM ubuntu:18.04
MAINTAINER Bibin Wilson <bibinwilsonn@gmail.com>

# Make sure the package repository is up to date.
RUN apt-get update
RUN apt-get -qy full-upgrade
RUN apt-get install -qy git
# Install a basic SSH server
RUN apt-get install -qy openssh-server
RUN sed -i 's|session    required     pam_loginuid.so|session    optional     pam_loginuid.so|g' /etc/pam.d/sshd
RUN mkdir -p /var/run/sshd

# Install JDK 8 (latest stable edition at 2019-04-01)
RUN apt-get install -qy openjdk-8-jdk
# Install maven
RUN apt-get install -qy maven

# Cleanup old packages
RUN apt-get -qy autoremove

# Add user jenkins to the image
RUN adduser --quiet jenkins
# Set password for the jenkins user (you may want to alter this).
RUN echo "jenkins:jenkins" | chpasswd

RUN mkdir /home/jenkins/.m2

ADD settings.xml /home/jenkins/.m2/

RUN chown -R jenkins:jenkins /home/jenkins/.m2/

# Copy authorized keys
COPY .ssh/authorized_keys /home/jenkins/.ssh/authorized_keys

RUN chown -R jenkins:jenkins /home/jenkins/.ssh/

# Standard SSH port
EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
