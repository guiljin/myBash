#!/usr/bin/env bash
curl -fsSL https://get.docker.com | bash -s docker --mirror Aliyun

systemctl daemon-reload
systemctl restart docker.service