#!/bin/bash
set -ex

ls_templates() {
  find templates -type f -regextype posix-egrep -regex "^templates/(\
init
|xmp\
|unlink\
|truncate\
|getattr\
|chmod\
|mkdir\
|readdir\
|chown\
|destroy\
|open\
|create\
|mknod\
|check_args\
|rename\
|closed\
|read_file\
|mkfifo\
|symlink\
|link\
|utimens\
|write_file\
|rmdir\
|readlink\
)$"
} 

ls_templates
exit

export TMP_FILE=`mktemp /tmp/execfuse_wrapper.$$.XXXXXXX.yml`
cat > ${TMP_FILE} 

export TEMPLATE_DIR="templates/"
export COMPILED_DIR="compiled/`cat ${TMP_FILE} | yq r - wrapper_name`"

test -d ${COMPILED_DIR} || mkdir -p ${COMPILED_DIR} 


ls_templates | xargs -P6 -I{} sh -xce '

  FILE_PATH={}
  FILE_NAME=`basename ${FILE_PATH}`
  jinja2 -e jinja2_ansible_filters.AnsibleCoreFiltersExtension ${FILE_PATH} < ${TMP_FILE} > ${COMPILED_DIR}/${FILE_NAME}
'


