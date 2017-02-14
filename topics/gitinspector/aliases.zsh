#!/usr/bin/env zsh

gitinspector() {
  repo_path=$1

  # Check for repo path
  if [[ ${repo_path} == "" ]]; then
    echo "You must specify a path to a repo."
    return false
  fi

  gitinspector_py_path=~/src/gitinspector/gitinspector.py
  repo_name=$(basename $1)
  reports_path=~/gitinspector/reports
  output_file=${reports_path}/${repo_name}.json

  # Check for Python
  if [[ ! $(which python) ]]; then
    echo "You need python to run this script."
    return false
  fi

  # Check for gitinspector
  if [[ ! -e ${gitinspector_py_path} ]]; then
    echo "Could not find $gitinspector_py_path."
    echo "Clone it or update this script."
    return false
  fi

  # Check for a git repo
  if [[ ! -d ${repo_path}/.git ]]; then
    echo "Not a git repo: $repo_path"
    return false
  fi

  echo ""
  echo "...generating report for $repo_name"
  mkdir -p ${reports_path}
  touch ${output_file}
  # https://github.com/ejwa/gitinspector/wiki/Documentation
  python ${gitinspector_py_path} \
    --file-types="**" \
    --format=json \
    --grading=true \
    --hard=true \
    --list-file-types=true \
    --localize-output=false \
    --metrics=true \
    --responsibilities=true \
    --timeline=true \
    --weeks=false \
    --timeline=true \
    ${repo_path} > ${output_file}

  echo "Done! $output_file"

  unset gitinspector_py_path
  unset repo_name
  unset repo_path
  unset output_file
}
