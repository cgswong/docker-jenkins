# Jenkins Docker image

The Jenkins Continuous Integration and Delivery server.

This is a fully functional Jenkins server, based on the Long Term Support release at http://jenkins-ci.org/

# Usage

```
docker run -p 8080:8080 --name jenkins cgswong/jenkins
```

This will store the workspace in */opt/jenkins*. All Jenkins data lives in there - including plugins and configuration.
You will probably want to make that a persistent volume (recommended):

```
docker run -p 8080:8080 -v */your/home*:/opt/jenkins jenkins
```

This will store the jenkins data in */your/home* on the host.
Ensure that */your/home* is accessible by the jenkins user in the container.


You can also use a volume container:

```
docker run --name jenkins -p 8080:8080 -v /opt/jenkins cgswong/jenkins
```

Then **jenkins** container has the volume (please do read about docker volume handling to find out more).

## Backing up data

If you bind mount in a volume - you can simply back up that directory
(which is **/opt/jenkins**) at any time.

This is highly recommended. Treat the **/opt/jenkins** directory as you would a database - in Docker you would generally put a database on a volume.

If your volume is inside a container - you can use ```docker cp $ID:/opt/jenkins``` command to extract the data.
Note that some symlinks on some OSes may be converted to copies (this can confuse jenkins with lastStableBuild links etc)

# Attaching build executors

You can run builds on the master (out of the box) buf if you want to attach build slave servers: make sure you map the port: ```-p 50000:50000``` - which will be used when you connect a slave agent.

[Here](https://registry.hub.docker.com/u/maestrodev/build-agent/) is an example docker container you can use as a build server with lots of good tools installed - which is well worth trying.

# Passing JVM parameters

You might need to customize the JVM running Jenkins, typically to pass system properties or tweak heap memory settings. Use JAVA_OPTS environment 
variable for this purpose :

```
docker run --name jenkins -p 8080:8080 -env JAVA_OPTS=-Dhudson.footerURL=http://mycompany.com cgswong/jenkins
```

# Installing more tools

You can run your container as root - and uninstall via apt-get, install as part of build steps via jenkins tool installers, or you can create your own Dockerfile to customise, for example: 

```
FROM jenkins
USER root # if we want to install via apt
RUN apt-get install -y ruby make more-thing-here
USER jenkins # drop back to the regular jenkins user - good practice

```
# Upgrading

All the data needed is in the */opt/jenkins* directory - so depending on how you manage that - depends on how you upgrade. Generally - you can copy it out - and then "docker pull" the image again - and you will have the latest LTS - you can then start up with -v pointing to that data (*/opt/jenkins*) and everything will be as you left it.

As always - please ensure that you know how to drive docker - especially volume handling!
