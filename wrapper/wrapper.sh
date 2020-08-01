#!/bin/sh
set -ex

export TMP_FILE=`mktemp /tmp/execfuse_wrapper.$$.XXXXXXX.yml`
cat > ${TMP_FILE} 

export TEMPLATE_DIR="templates/"
export COMPILED_DIR="compiled/`cat ${TMP_FILE} | yq r - wrapper_name`"

test -d ${COMPILED_DIR} || mkdir -p ${COMPILED_DIR} 

find templates -type f | xargs -P6 -I{} sh -c '

  FILE_PATH={}
  FILE_NAME=`basename ${FILE_PATH}`
  jinja2 -e jinja2_ansible_filters.AnsibleCoreFiltersExtension ${FILE_PATH} < ${TMP_FILE} > ${COMPILED_DIR}/${FILE_NAME}
'

