import ballerina/lang.runtime;
import ballerina/lang.'int as ints;
import ballerina/os;
import ballerina/log;

final TelemetryClient telemtryEp = check new ("http://localhost:9090");

public function main() returns error? {
    int iterationsCount = check ints:fromString(os:getEnv("ITERATIONS_COUNT"));
    foreach int i in 0 ..< iterationsCount {
        publishMetrics(i);
        publishTraces(i);
        runtime:sleep(1);
    }
}

function publishMetrics(int iteration) {
    MetricsPublishRequest req = {

    };
    var res = telemtryEp->publishMetrics(req);
    if (res is error) {
        log:printError("Failed publishing metrics",
            iteration=iteration, 'error=res,
            stackTrace=res.stackTrace());
    }
}

function publishTraces(int iteration) {
    TracesPublishRequest req = {

    };
    var res = telemtryEp->publishTraces(req);
    if (res is error) {
        log:printError("Failed publishing metrics",
            iteration=iteration, 'error=res,
            stackTrace=res.stackTrace());
    }
}
