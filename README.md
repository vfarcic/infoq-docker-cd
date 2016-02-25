Chances are you already tried Docker. You probably started by running one of the images from [Docker Hub](https://hub.docker.com/). The ease of use led you to experiment writing your own *Dockerfile* and building your own images. You tried [Docker Compose](https://www.docker.com/products/docker-compose). You might have realized benefits Docker provides in conjunction with microservices. Hopefully, you already deployed a container or two to production or, at least, realized benefits it brings for development, testing, integration and other environments and phases. All those pieces are necessary requirements for the "real deal". The final objective is to combine quite a few processes and technologies that will allow us to create a deployment pipeline. Docker allows us to reach nirvana. A world many thought is far from reality. A world where the last thing we do is run `git push`. From there on, machine takes over and few minutes later our software is tested, built, deployed to production, and what so not. Let's see how that nirvana looks like. Let's explore which steps are required for a fully automated continuous deployment pipeline. Let's try to get rid of humans.

Setting Up the Stage
====================

The only requirement for hands-on practice we're about to have is [Git](https://git-scm.com/) and [Vagrant](https://www.vagrantup.com/). Please make sure that both are installed on your laptop. Instead of second guessing your OS of choice, we'll use Vagrant to setup a few Ubuntu servers. We'll discuss them later one. Since creating a cluster with all the tool might require some time, let us start the creation of VMs and, while provisioning is running, start the discussion about the deployment pipeline. Please run the following commands.

```bash
# TODO: Change to GitHub
git clone XXX

# TODO: Change to GitHub
cd XXX


```

The Continuous Deployment Pipeline
==================================

