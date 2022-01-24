#!/usr/bin/env bash

BASEDIR=$(dirname "$0")
source "$BASEDIR"/functions.sh

function run_junit_test() {
    register_log "JUnitTests started on $(date)"
    mvn test
    register_log "JUnitTests completed on $(date)"
}



