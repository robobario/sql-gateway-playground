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
curl -O --output-dir ./flink-1.19.1/lib/ https://repo.maven.apache.org/maven2/org/apache/flink/flink-sql-connector-kafka/3.2.0-1.19/flink-sql-connector-kafka-3.2.0-1.19.jar

MINIKUBE_IP="$(minikube ip)"
SQL_GATEWAY_SERVICE_PORT="$(kubectl get service fraud-detection-sql-gateway -o=jsonpath='{.spec.ports[0].nodePort}{"\n"}')"
./flink-1.19.1/bin/sql-client.sh gateway --endpoint "http://${MINIKUBE_IP}:${SQL_GATEWAY_SERVICE_PORT}" -Drest.address=fraud-detection2-rest
