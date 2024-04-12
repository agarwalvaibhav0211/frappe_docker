mkdir gitops
. ./.env
# echo $TRAEFIK_PASSWORD_TO_SET
echo 'TRAEFIK_DOMAIN=traefik.example.com' > ./gitops/traefik.env
echo 'EMAIL=admin@example.com' >> ./gitops/traefik.env
echo 'HASHED_PASSWORD="'$(openssl passwd -apr1 ${TRAEFIK_PASSWORD_TO_SET} | sed 's/\$/\\\$/g')'"' >> ./gitops/traefik.env

docker compose --project-name traefik \
  --env-file ./gitops/traefik.env \
  -f overrides/compose.traefik.yaml \
  -f overrides/compose.traefik-ssl.yaml config >> ./gitops/traefik.yaml

echo "DB_PASSWORD=${DB_PASSWORD_TO_SET}" > ./gitops/mariadb.env

docker compose --project-name mariadb --env-file ./gitops/mariadb.env -f overrides/compose.mariadb-shared.yaml config >> ./gitops/mariadb.yaml

cp example.env ./gitops/erpnext-one.env
sed -i "s/DB_PASSWORD=123/DB_PASSWORD=${DB_PASSWORD_TO_SET}/g" ./gitops/erpnext-one.env
sed -i 's/DB_HOST=/DB_HOST=mariadb-database/g' ./gitops/erpnext-one.env
sed -i 's/DB_PORT=/DB_PORT=3306/g' ./gitops/erpnext-one.env
sed -i 's/SITES=`erp.example.com`/SITES=\`one.example.com\`,\`two.example.com\`/g' ./gitops/erpnext-one.env
echo 'ROUTER=erpnext-one' >> ./gitops/erpnext-one.env
echo "BENCH_NETWORK=erpnext-one" >> ./gitops/erpnext-one.env
echo "REDIS_DATABASE=1" >> ./gitops/erpnext-one.env
echo "DOCKER_IMAGE_TAG=${DOCKER_IMAGE_TAG}" >> ./gitops/erpnext-one.env


docker compose --project-name redis \
  -f overrides/compose.redis-shared.yaml config > ./gitops/redis.yaml

docker compose --project-name erpnext-one \
  --env-file ./gitops/erpnext-one.env \
  -f compose.yaml \
  -f overrides/compose.multi-bench.yaml \
  -f overrides/compose.multi-bench-ssl.yaml config > ./gitops/erpnext-one.yaml



