#!/bin/bash
mkdir -p tempdir/templates tempdir/static

cp sample_app.py tempdir/
cp -r templates/* tempdir/templates/
cp -r static/* tempdir/static/

cat > tempdir/Dockerfile <<'DOCKERFILE'
FROM python:3.9-slim
RUN pip install --no-cache-dir flask
COPY ./static /home/myapp/static/
COPY ./templates /home/myapp/templates/
COPY sample_app.py /home/myapp/
EXPOSE 5050
CMD python /home/myapp/sample_app.py
DOCKERFILE

cd tempdir
docker build -t sampleapp .
docker stop samplerunning 2>/dev/null || true
docker rm samplerunning 2>/dev/null || true
# 关键：--pids-limit -1 彻底移除 PID 限制，--ulimit nproc 设为 unlimited
docker run -d --pids-limit -1 --ulimit nproc=unlimited -p 5050:5050 --name samplerunning sampleapp
docker ps -a
