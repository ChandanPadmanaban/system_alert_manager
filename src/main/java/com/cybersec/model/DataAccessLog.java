package com.cybersec.model;

/**
 * DataAccessLog - Represents a data access log entry.
 */
public class DataAccessLog {

    private int accessId;
    private String accessType;
    private String message;

    // Default Constructor
    public DataAccessLog() {
    }

    // Parameterized Constructor
    public DataAccessLog(int accessId, String accessType, String message) {
        this.accessId = accessId;
        this.accessType = accessType;
        this.message = message;
    }

    // Getter and Setter for accessId
    public int getAccessId() {
        return accessId;
    }

    public void setAccessId(int accessId) {
        this.accessId = accessId;
    }

    // Getter and Setter for accessType
    public String getAccessType() {
        return accessType;
    }

    public void setAccessType(String accessType) {
        this.accessType = accessType;
    }

    // Getter and Setter for message
    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    // Returns short code using substring()
    public String getAccessTypeShortCode() {

        if (accessType != null && accessType.length() >= 4) {
            return accessType.substring(0, 4).toUpperCase();
        }

        return accessType;
    }

    // Formatted summary using StringBuffer
    public String getFormattedSummary() {

        StringBuffer sb = new StringBuffer();

        sb.append("[ID: ").append(accessId).append("] ");
        sb.append("[").append(accessType).append("] ");

        if (message != null && message.length() > 60) {
            sb.append(message.substring(0, 60)).append("...");
        } else {
            sb.append(message);
        }

        return sb.toString();
    }

    // Check unauthorized access
    public boolean isUnauthorized() {
        return "UNAUTHORIZED".equalsIgnoreCase(accessType);
    }

    @Override
    public String toString() {
        return getFormattedSummary();
    }
}