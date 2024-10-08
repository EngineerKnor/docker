## Setup docker on Raspberry Pi

With this tutorial you can setup docker on your raspberry pi, the docker part starts at around ~7:50:
- https://www.youtube.com/watch?v=nOxywVabojk

## Create a database
This file is here so it's easy to create a database based on a dockerfile.

For more information about docker, see:
- https://docs.docker.com/engine/reference/builder/
- https://docs.docker.com/engine/reference/commandline/build/
- https://docs.docker.com/engine/reference/commandline/run/

#### #1 - Create the docker image:
- This command needs to be executed within the folder of the 'dockerfile'.
```bash
docker build -t mysql-database-image .
```
#### #2 - Run the docker container:
- This command needs to be executed within the folder of the 'dockerfile'.
```bash
docker run -p 4200:3306 -p 4210:3306  -d --name mysql-database-container mysql-database-image
```
#### #3 - Command to get in an running docker container:
```bash
docker exec -it mysql-database-container /bin/bash
```
#### #4 - Command to delete all docker images that aren't attached to a docker container:
```bash
docker image prune -a
```
#### #5 - Command to clear docker's builder cache:
- For more information, see: https://docs.docker.com/reference/cli/docker/builder/prune
```bash
docker builder prune -a
```


