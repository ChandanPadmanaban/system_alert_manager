package com.cybersec.model;

/**
 * FileIntegrityAlert - Represents a file integrity monitoring alert.
 *
 * Uses:
 *  - substring() to extract alert type prefix
 *  - StringBuffer for formatted display
 */
public class FileIntegrityAlert {

    private int    alertId;
    private String alertType;
    private String description;

    public FileIntegrityAlert() {}

    public FileIntegrityAlert(int alertId, String alertType, String description) {
        this.alertId     = alertId;
        this.alertType   = alertType;
        this.description = description;
    }

    // Getters & Setters
    public int    getAlertId()             { return alertId; }
    public void   setAlertId(int id)       { this.alertId = id; }

    public String getAlertType()             { return alertType; }
    public void   setAlertType(String t)     { this.alertType = t; }

    public String getDescription()           { return description; }
    public void   setDescription(String d)   { this.description = d; }

    /**
     * Uses substring() to get the first char of alert type as an icon code.
     * e.g. "MODIFIED" → "M", "DELETED" → "D"
     */
    public String getAlertTypeIcon() {
        if (alertType != null && alertType.length() >= 1) {
            return alertType.substring(0, 1).toUpperCase();
        }
        return "?";
    }

    /**
     * Uses substring() to get a 3-char abbreviation.
     * e.g. "MODIFIED" → "MOD"
     */
    public String getAlertTypeAbbr() {
        if (alertType != null && alertType.length() >= 3) {
            return alertType.substring(0, 3).toUpperCase();
        }
        return alertType;
    }

    /**
     * Uses StringBuffer to build a formatted integrity alert summary.
     */
    public String getFormattedSummary() {
        StringBuffer sb = new StringBuffer();
        sb.append("[ALERT-").append(alertId).append("] ");
        sb.append("[").append(alertType).append("] ");
        if (description != null && description.length() > 60) {
            sb.append(description.substring(0, 60)).append("...");
        } else {
            sb.append(description);
        }
        return sb.toString();
    }

    /**
     * Returns true if this alert represents a file modification.
     */
    public boolean isModified() {
        return "MODIFIED".equalsIgnoreCase(alertType);
    }

    @Override
    public String toString() {
        return getFormattedSummary();
    }
}
