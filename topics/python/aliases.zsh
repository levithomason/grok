alias serve="python -m SimpleHTTPServer $*"

killpyc() {
  for pyc in $(find . -type f -name "*.pyc"); do
    echo "$pyc"
    rm ${pyc}
  done
}
