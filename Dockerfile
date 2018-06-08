# Pre-Built Docker Jenkins Images
# Maven 3 installed
# Bundled with Maven3 pre-installed
# Jenkins Git plugin installed
# Jenkins CloudBees Docker Build and Publish plugin installed
# Build Pipeline Plugin installed

FROM jenkins
MAINTAINER Matt Dzwonczyk mattdzwonczyk@gmail.com

# Install Jenkins Plugins
COPY resources/plugins.txt /usr/share/jenkins/plugins.txt
RUN /usr/local/bin/plugins.sh /usr/share/jenkins/plugins.txt

# Configure Maven installation location in Jenkins
COPY resources/hudson.tasks.Maven.xml /var/jenkins_home/hudson.tasks.Maven.xml

# Copy Docker config
COPY resources/org.jenkinsci.plugins.docker.commons.tools.DockerTool.xml /var/jenkins_home/org.jenkinsci.plugins.docker.commons.tools.DockerTool.xml

# Install maven
USER root
RUN apt-get update && apt-get install -y wget

# Get maven 3.5.3
RUN wget --no-verbose -O /tmp/apache-maven-3.5.3.tar.gz http://archive.apache.org/dist/maven/maven-3/3.5.3/binaries/apache-maven-3.5.3-bin.tar.gz

# Install maven
RUN tar xzf /tmp/apache-maven-3.5.3.tar.gz -C /opt/
RUN ln -s /opt/apache-maven-3.5.3 /opt/maven
RUN ln -s /opt/maven/bin/mvn /usr/local/bin
RUN rm -f /tmp/apache-maven-3.5.3.tar.gz
ENV MAVEN_HOME /opt/maven

# Install Docker
RUN apt-get -y install apt-transport-https ca-certificates curl software-properties-common
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu xenial stable"
RUN apt-get update
RUN apt-get -y install docker-ce

# Switch back to Jenkins user
USER jenkins
