PHP on Vagrant
=================

This is a vagrant template that allows you to have a full and ready LAMP environment.

How to use:

1. change the name of the project in the bootstrap.sh to the domain that you want to use, so change
     ```bash
     PROJECTNAME=""
     ```
   in something like:
     ```bash
     PROJECTNAME="project-name"
     ```
2. the default ports on the host are 8081 for apache and 3307 for mysql, you can change them in the Vagrantfile
3. add to the host file of your computer (/etc/hosts on Linux, C:\Windows\System32\drivers\etc\hosts on Windows) a new line
     
     ```
     127.0.0.1  project-name.dev www.project-name.dev
     ```
   you have to change project-name with the name that you put inside PROJECTNAME in the first step
3. launch the project with ```vagrant up```
4. now you can access to apache on http://project-name.dev:8081, there also phpmyadmin installed on http://127.0.0.1:8081/phpmyadmin/

The project directory (the one that contains the Vagrantfile and bootstrap.sh) is the document root for apache and the logs are saved in the logs folder.
