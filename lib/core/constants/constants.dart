//urls
const String baseUrl = "http://10.0.2.2:8081";
const String serviceUrl = "http://10.0.2.2:8082/";
const String routeUrl = "/handle";
//error messages
const String stateExceptionBadResponseMessage = "bad response";
const String caughtException = "caught exception";
const String noUserFound = "token is invalid or no token provided";
//limits
const double walkingLimit =
    150; // if distance between last driving polyline point and destination polyline point is greater than this then walking polyline request is sent
const String polylineErrorMessage = "could not get polyline";
