#!/usr/bin/env bash

function build() {
    echo
    echo "Cleaning up remnants from previous runs"
    docker kill memory_test_svc > /dev/null
    docker rmi memory_test_svc:latest > /dev/null
    rm -rf service/target
    rm -rf invoker/target

    echo
    echo "Building the gRPC service"
    bal build --cloud=docker service

    echo
    echo "Building the invoker"
    bal build invoker
}

function wait() {
    WAIT_PERIOD="${1}"
    echo
    echo "Waiting for ${WAIT_PERIOD} seconds"
    sleep "${WAIT_PERIOD}s"
}

function print_docker_stats() {
    echo
    echo "Docker Stats"
    docker stats memory_test_svc --no-stream
}

function start_svc() {
    echo
    echo "Starting the gRPC service"
    docker run -d --rm --name memory_test_svc -p 9090:9090 memory_test_svc:latest

    wait 10
    print_docker_stats
}

function invoke_svc() {
    ITERATIONS_COUNT="${1}"
    echo
    echo "Invoking the gRPC service (Count: ${ITERATIONS_COUNT})"
    ITERATIONS_COUNT="${ITERATIONS_COUNT}" bal run invoker/target/bin/invoker.jar

    wait 10
    print_docker_stats
}

build
start_svc
invoke_svc 1
invoke_svc 1000
