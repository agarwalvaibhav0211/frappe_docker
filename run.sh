
. ./.env

docker compose --project-name mariadb -f ./gitops/mariadb.yaml up -d
docker compose --project-name traefik -f ./gitops/traefik.yaml up -d
docker compose --project-name redis -f ./gitops/redis.yaml up -d
docker compose --project-name erpnext-one -f ./gitops/erpnext-one.yaml up -d


# Username: Administrator
# one.example.com
docker compose --project-name erpnext-one exec backend \
  bench new-site --no-mariadb-socket --mariadb-root-password $DB_PASSWORD_TO_SET --install-app erpnext --admin-password $ERPNext_Admin_start_PASSWORD_TO_SET one.example.com

# two.example.com
# docker compose --project-name erpnext-one exec backend \
#   bench new-site --no-mariadb-socket --mariadb-root-password $DB_PASSWORD_TO_SET --install-app erpnext --admin-password $ERPNext_Admin_start_PASSWORD_TO_SET two.example.com