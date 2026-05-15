package com.cybersec.model;

/**
 * SystemUpdateAlert - Represents a system update notification/alert.
 *
 * Uses:
 *  - substring() to extract update type prefix
 *  - StringBuffer for formatted display
 */
public class SystemUpdateAlert {

    private int    updateId;
    private String updateType;
    private String message;

    public SystemUpdateAlert() {}

    public SystemUpdateAlert(int updateId, String updateType, String message) {
        this.updateId   = updateId;
        this.updateType = updateType;
        this.message    = message;
    }

    // Getters & Setters
    public int    getUpdateId()           { return updateId; }
    public void   setUpdateId(int id)     { this.updateId = id; }

    public String getUpdateType()           { return updateType; }
    public void   setUpdateType(String t)   { this.updateType = t; }

    public String getMessage()              { return message; }
    public void   setMessage(String m)      { this.message = m; }

    /**
     * Uses substring() to extract the first 3 chars as a badge code.
     * e.g. "FAILED" → "FAI", "SUCCESS" → "SUC"
     */
    public String getUpdateTypeCode() {
        if (updateType != null && updateType.length() >= 3) {
            return updateType.substring(0, 3).toUpperCase();
        }
        return updateType;
    }

    /**
     * Uses StringBuffer to build a formatted alert summary.
     */
    public String getFormattedSummary() {
        StringBuffer sb = new StringBuffer();
        sb.append("[UPDATE-").append(updateId).append("] ");
        sb.append("[").append(updateType).append("] ");
        if (message != null && message.length() > 60) {
            sb.append(message.substring(0, 60)).append("...");
        } else {
            sb.append(message);
        }
        return sb.toString();
    }

    /**
     * Returns true if this alert represents a failed update.
     */
    public boolean isFailed() {
        return "FAILED".equalsIgnoreCase(updateType);
    }

    @Override
    public String toString() {
        return getFormattedSummary();
    }
}
