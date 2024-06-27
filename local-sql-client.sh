#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $SCRIPT_DIR

if [ ! -d flink-1.19.1 ]; then
  echo "downloading flink binary distribution"
  curl -OL https://dlcdn.apache.org/flink/flink-1.19.1/flink-1.19.1-bin-scala_2.12.tgz
  tar -zxf flink-1.19.1-bin-scala_2.12.tgz
else
  echo "flink distribution directory exists"
fi

MINIKUBE_IP="$(minikube ip)"
JOBMANAGER_REST_SERVICE_PORT="$(kubectl get service fraud-detection-rest -o=jsonpath='{.spec.ports[0].nodePort}{"\n"}')"
./flink-1.19.1/bin/sql-client.sh embedded -Drest.address=$MINIKUBE_IP -Drest.port=$JOBMANAGER_REST_SERVICE_PORT
