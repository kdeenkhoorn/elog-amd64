#!/bin/bash
podman volume create elogData
podman run --name elogd --restart always -d -p 8080:8080 -v elogData:/opt/elog ghcr.io/kdeenkhoorn/elog-amd64:latest
