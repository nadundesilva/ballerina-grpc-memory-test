import ballerina/grpc;
import ballerina/log;

@grpc:ServiceDescriptor {
    descriptor: ROOT_DESCRIPTOR_TELEMETRY,
    descMap: getDescriptorMapTelemetry()
}
service "Telemetry" on new grpc:Listener(9090) {

    # Receive metrics data from ballerina program and ingest them into Azure eventhub
    #
    # + caller - TelemetryNilCaller
    # + metricsPR - MetricsPublishRequest
    isolated remote function publishMetrics(TelemetryNilCaller caller, MetricsPublishRequest metricsPR) {
        sendCompletion(caller);
    }

    # Receive tracespans from ballerina program and ingest them into Azure eventhub
    #
    # + caller - TelemetryNilCaller
    # + tracesPR - TracesPublishRequest
    isolated remote function publishTraces(TelemetryNilCaller caller, TracesPublishRequest tracesPR) {
        sendCompletion(caller);
    }
}

isolated function sendCompletion(TelemetryNilCaller caller) {

    grpc:Error? err = caller->complete();
    if (err is grpc:Error) {
        log:printError(string `Error in sending completed notification to caller: ${err.message()} ` +
            string `- ${err.detail().toString()}`);
    }
}
