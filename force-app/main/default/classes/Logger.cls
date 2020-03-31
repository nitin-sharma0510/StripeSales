/**
 * General logging and error/exception capturing.
 * Allows us to turn off the Sentry dependency.
 */

public without sharing class Logger {
  
    public static void capture(Exception e) {
        //Sentry.record(e);
    }

}