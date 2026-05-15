package com.cybersec.model;

/**
 * DataAccessLog - Represents a data access log entry.
 *
 * Uses:
 *  - substring() to extract/truncate access type prefix
 *  - StringBuffer for formatted display
 */
public class DataAccessLog {

    private int    accessId;
    private String accessType;
    private String message;

    public DataAccessLog() {}

    public DataAccessLog(int accessId, String accessType, String message) {
        this.accessId   = accessId;
        this.accessType = accessType;
        this.message    = message;
    }

    // Getters & Setters
    public int    getAccessId()           { return accessId; }
    public void   setAccessId(int id)     { this.accessId = id; }

    public String getAccessType()           { return accessType; }
    public void   setAccessType(String t)   { this.accessType = t; }

    public String getMessage()              { return message; }
    public void   setMessage(String m)      { this.message = m; }

    /**
     * Uses substring() to extract the first 4 chars of access type as a short code.
     * e.g. "UNAUTHORIZED" → "UNAU"
     */
    public String getAccessTypeShortCode() {
        if (accessType != null && accessType.length() >= 4) {
            return accessType.substring(0, 4).toUpperCase();
        }
        return accessType;
    }

    /**
     * Uses StringBuffer to build a formatted log summary line.
     */
    public String getFormattedSummary() {
        StringBuffer sb = new StringBuffer();
        sb.append("[ID: ").append(accessId).append("] ");
        sb.append("[").append(accessType).append("] ");
        // Use substring() to limit message display to first 60 chars
        if (message != null && message.length() > 60) {
            sb.append(message.substring(0, 60)).append("...");
        } else {
            sb.append(message);
        }
        return sb.toString();
    }

    /**
     * Returns true if this log entry represents an unauthorized access.
     */
    public boolean isUnauthorized() {
        return "UNAUTHORIZED".equalsIgnoreCase(accessType);
    }

    @Override
    public String toString() {
        return getFormattedSummary();
    }
}
