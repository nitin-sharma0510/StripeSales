/**
 * Logger class for sending log lines to LogDNA
 * https://tech.ovoenergy.com/forcelog-a-structured-extensible-logger-for-salesforce-apex/
 * 
 * Also extending it to be a singletonn with a getLogger() method
 * https://developer.salesforce.com/page/Apex_Design_Patterns_-_Singleton
 */

 public class RemoteLogger extends ForceLog.BulkLogger {

    private static RemoteLogger instance = null;

    /**
     * @description The HTTP endpoint to send requests to
     * @type {String}
     */
    private String endpoint;

    /**
     * @description The HTTP client to use for making requests
     * @type {Http}
     */
    private Http client;

    /**
     * @description Initializes a new instance of the CalloutLogger class
     * @param {String} name The log name, should be a class or method name.
     * @param {String} endpoint The endpoint to send HTTP requests to.
     * @constructor
     */
    public RemoteLogger(String name, String endpoint) {
        // Initialize the parent class using the name.
        super(name);

        // LogDNA ingestion reference: https://docs.logdna.com/reference
        // https://logs.logdna.com/logs/ingest?hostname=

        this.endpoint = endpoint;
        this.client = new Http();
    }

/*
    // a static method that returns the instance of the record type
    public static RemoteLogger getLogger() {
        // lazy load the record type - only initialize if it doesn't already exist
        if(instance == null) instance = new RemoteLogger();
        return instance;
    }
    */

    /**
     * @description Creates an HTTP POST request containing
     * the JSON-encoded logs as the body.
     * @param {List<Map<String, Object>>} logs The log data
     * @return {void}
     */
    protected override void bulkFlush(List<Map<String, Object>> logs) {
        HttpRequest req = new HttpRequest();

        req.setEndpoint(this.endpoint);
        req.setMethod('POST');
        req.setBody(JSON.serialize(logs));

        this.client.send(req);
    }
}