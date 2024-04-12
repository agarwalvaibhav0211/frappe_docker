docker ps -aq | xargs docker rm -f
docker system prune --volumes
docker volume ls -q | xargs docker volume rm

