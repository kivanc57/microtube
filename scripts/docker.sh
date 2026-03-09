#!/bin/bash
set -euo pipefail

docker_login_registry(){
        local registry_url="$1"
        local registry_username="$2"
        local registry_password="$3"

        if ! docker login "${registry_url}" \
                --username "${registry_username}" \
                --password "${registry_password}"
        then
                log "[ERROR]: logging in Microsoft Azure registry"
                exit 1
        else
                log "[SUCCESS]: logging in Microsoft Azure registry"
        fi
}

docker_build_image(){
        local image_tag="$1"
        local dockerfile_path="$2"
        local build_context="$3"

        if ! docker build -t "${image_tag}" -f "${dockerfile_path}" "${build_context}"; then
                log "[ERROR]: building Docker image"
                exit 1
        else
                log "[SUCCESS] building Docker image"
        fi
}

docker_tag_image(){
        local source_image="$1"
        local target_image="$2"

        if ! docker tag "${source_image}" "${target_image}"; then
                log "[ERROR]: tagging Docker image ${source_image} -> ${target_image}"
                exit 1
        else
                log "[SUCCESS]: tagging Docker image ${source_image} -> ${target_image}}"
        fi
}

docker_push_image(){
        local image_tag="$1"

        if ! docker push "${image_tag}"; then
                log "[ERROR]: pushing Docker image ${image_tag}"
                exit 1
        else
                log "[SUCCESS] pushing Docker image ${image_tag}"
        fi
}

docker_run_image(){
        local container_name="$1"
        local image_tag="$2"
        local host_port="$3"
        local container_port="$4"

        if ! docker run -d \
                --name "${container_name}" \
                -p "${host_port}:${container_port}" \
                -e PORT="${container_port}" \
                "${image_tag}"
        then
                log "[ERROR]: running Docker image ${image_tag}"
                exit 1
        else
                log "[SUCCESS]: running Docker image ${image_tag}"
        fi
}


# main functions
run_on_local(){
        docker_build_image  "${APP_TAG}" "${DOCKERFILE_PATH}" "${BUILD_CONTEXT}"
        docker_run_image "${APP_NAME}" "${APP_TAG}" "${PORT}" "${PORT}"

}

run_on_remote(){
        docker_login_registry "${REGISTRY_URL}" "${REGISTRY_USERNAME}" "${REGISTRY_PASSWORD}"
        docker_build_image  "${APP_TAG}" "${DOCKERFILE_PATH}" "${BUILD_CONTEXT}"
        docker_tag_image "${APP_TAG}" "${TARGET_IMAGE}"
        docker_push_image "${TARGET_IMAGE}"
        docker_run_image "${APP_NAME}" "${TARGET_IMAGE}" "${PORT}" "${PORT}"
}

