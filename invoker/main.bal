import ballerina/lang.runtime;
import ballerina/lang.'int as ints;
import ballerina/os;

final TelemetryClient telemtryEp = check new ("http://localhost:9090");

public function main() returns error? {
    int iterationsCount = check ints:fromString(os:getEnv("ITERATIONS_COUNT"));
    foreach int i in 0 ..< iterationsCount {
        publishMetrics();
        publishTraces();
        runtime:sleep(1);
    }
}

function publishMetrics() {

}

function publishTraces() {

}
