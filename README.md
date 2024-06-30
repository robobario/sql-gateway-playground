# flink SQL playground

Aiming to explore ways to run interactive SQL using a session mode Flink cluster deployed by the Flink Operator.

``` shell
./01-setup.sh
./02-setup.sh
```

```
KAFKA_BOOTSTRAP="$(minikube ip):$(kubectl get service my-cluster-kafka-external-bootstrap -o=jsonpath='{.spec.ports[0].nodePort}{"\n"}')"
kafka-console-producer --bootstrap-server  ${KAFKA_BOOTSTRAP} --topic transactions  --property parse.key=true < transactions
```

```
./local-sql-client.sh

CREATE TABLE Transactions (
  `name` STRING,
  `id` BIGINT
) WITH (
  'connector' = 'kafka',
  'topic' = 'transactions',
  'properties.bootstrap.servers' = 'my-cluster-kafka-bootstrap:9092',
  'properties.group.id' = 'testGroup',
  'scan.startup.mode' = 'earliest-offset',
  'format' = 'csv'
);
SELECT * FROM Transactions
```


