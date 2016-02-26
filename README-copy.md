Chances are that you already tried Docker. You probably started by running one of the images from [Docker Hub](https://hub.docker.com/). The ease of use led you to experiment writing your own *Dockerfile* and building your own images. You tried [Docker Compose](https://www.docker.com/products/docker-compose). You might have realized benefits Docker provides in conjunction with microservices. Hopefully, you already deployed a container or two to production or, at least, realized advantages it brings to development, testing, integration and other environments and phases. All those pieces are necessary requirements for the "real deal". The final objective is to combine quite a few processes and technologies that will allow us to create a deployment pipeline. Docker allows us to reach nirvana. A world many thought is far from reality. A world where the last thing we do is run `git push`. From there on, machine takes over, and few minutes later our software is tested, built, deployed to production, and what so not. Let's see how that nirvana looks like. Let's explore which steps are required for a fully automated continuous deployment pipeline.

Setting Up the Stage
====================

The only requirement for hands-on practice we're about to have is [Git](https://git-scm.com/) and [Vagrant](https://www.vagrantup.com/). Please make sure that both are installed on your laptop. Instead of second guessing your OS of choice, we'll use Vagrant to setup a few Ubuntu servers. We'll discuss them later one. Since creating a cluster with all the tool might require some time, let us start the creation of VMs and, while provisioning is running, start the discussion about the deployment pipeline. Please run the following commands.

```bash
git clone https://github.com/vfarcic/infoq-docker-cd.git

cd infoq-docker-cd

vagrant up cd
```

Once the command is finished executing, we'll have the *cd* server provisioned it with Java, Docker, Docker Compose, Consul Template, Docker Registry, Jenkins, and nginx. Since this article is focused on continuous deployment of services packaged inside Docker containers, we'll skip details of the setup. In this particular case, we used Ansible as configuration management of choice but any other tool (Puppet, Chef, Salt, and so on) with the same purpose would do.

Off we go towards making the first first Docker deployment pipeline.

The Continuous Deployment Pipeline
==================================

What is the continuous deployment pipeline? In a nutshell, it is a set of steps executed on each CMS commit. The objective of the pipeline is to perform a set of tasks that will deploy a fully tested and functional service or application to production. To put it differently, the last human action is to make a commit to a repository and everything else is done automatically. With such a process we increase reliability by (partly) eliminating human error, and speed by letting machines do what they do best (running repeatable processes that do not require creative thinking). The reason why every commit is passed through the pipeline lies in the word *continuous*. If we postpone the process and, for example, run it at the end of a sprint, deployment would not be continuous. By postponing testing and deployment to production, we are postponing problems discovery and, as the result, increase the effort required to correct the problems. Fixing something a month after the problem is introduced is more expensive then if only a week passed. Similarly, if only a few minutes elapsed between commiting the code and getting notification of a bug, the time required to locate the culprit is almost negligible. Besides, it's not only about savings in maintenance and bug fixing. Continuous deployment allows us to get new features to production much faster. The less time it passes between a feature being developed and being available to our users, the faster we start gaining benefits from it. The result is an increase in profits.

Which steps should constitute the pipeline? Instead of answering that question directly, let us start with the absolute minimum and walk ourselves towards the one possible solution. The minimum set of steps would be to test the service, built it, and deploy it. None of those tasks can be skipped. Without testing we have no guarantee that the service works, without building it there is nothing to deploy, and without deploying it our users have no benefit from the new release.












![A simple continuous deployment flow](img/cd-flow-simple.png)

We'll use Jenkins [Pipeline Plugin](https://wiki.jenkins-ci.org/display/JENKINS/Pipeline+Plugin) to define the steps. The choice to use Jenkins is relatively easy. It is open source and the most widely used CI/CD tool. Chances are you are already familiar with it so that will save us from lenghtly explanation of what it does and how it works. The *Pipeline Plugin* (until recently called *Workflow Plugin*) is relatively new. The main benefit it provides is definition of the pipeline through code. Among others, that gives us benefits of storing the pipeline in a code repository (together with the rest of a service). The *Pipeline* uses a DSL specifically designed for executing CD tasks thus greatly simplifying the process. Most commonly used features are defined as DSL steps. If more power is needed, we can always write the pipeline code in Groovy. Since the whole flow is defined in a single script, one Jenkins Pipeline job substitutes many chained Freestyle jobs thus greatly reducing the maintenance cost and complexity. Please read [The Short History of CI/CD Tools](http://technologyconversations.com/2016/01/14/the-short-history-of-cicd-tools/) if you'd like more information behind using Jenkins as CI/CD tool of choice. [The Need For Jenkins Pipeline](https://www.cloudbees.com/blog/need-jenkins-pipeline) article provides a nice overview behind the needs that led to it.

Hopefully, by this time, the *cd* VM is running and provisioned with all the tools we'll need. If it is still running, please take a brake and grab some coffee. Quite a few GB are being downloaded and installed, so do not be surprised if it takes a while longer.

Please open the [simple-pipeline](http://10.100.198.200:8080/job/simple-pipeline/) Jenkins job and click *Build Now*. Now that the job is running, let us discuss the script located in the [simple-pipeline configuration](http://10.100.198.200:8080/job/simple-pipeline/configure) screen. The first thing you'll notice is that the whole job is a single script defined in the *Pipeline* section. The script is as follows.

```groovy
node("cd") {
    def serviceName = "books-ms"
    def prodIp = "10.100.198.200"
    def registryIpPort = "10.100.198.200:5000"

    def flow = load "/data/scripts/workflow-util.groovy"

    git url: "https://github.com/vfarcic/${serviceName}.git"
    flow.buildTests(serviceName, registryIpPort)
    flow.runTests(serviceName, "tests", "")
    flow.buildService(serviceName, registryIpPort)
    flow.deploy(serviceName, prodIp)
}
```



TODO: Explain the *Snippet Generator*

```bash
vagrant ssh -c "docker ps -a" cd
```