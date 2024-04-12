export APPS_JSON_BASE64=$(base64 -w 0 $PWD/images/indian_erp/apps.json)
# echo $APPS_JSON_BASE64
docker build \
  --build-arg=FRAPPE_PATH=https://github.com/frappe/frappe \
  --build-arg=FRAPPE_BRANCH=version-15 \
  --build-arg=PYTHON_VERSION=3.11.6 \
  --build-arg=NODE_VERSION=18.18.2 \
  --build-arg=APPS_JSON_BASE64=$APPS_JSON_BASE64 \
  --tag=indian-erpnext:v15.20.3 \
  --file=images/indian_erp/Containerfile .