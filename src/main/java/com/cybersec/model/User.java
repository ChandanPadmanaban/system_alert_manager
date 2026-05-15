package com.cybersec.model;

/**
 * User model for authentication and session management.
 */
public class User {

    private int    id;
    private String username;
    private String password;
    private String fullName;
    private String role;

    public User() {}

    public User(int id, String username, String password, String fullName, String role) {
        this.id       = id;
        this.username = username;
        this.password = password;
        this.fullName = fullName;
        this.role     = role;
    }

    // Getters & Setters
    public int    getId()       { return id; }
    public void   setId(int id) { this.id = id; }

    public String getUsername()             { return username; }
    public void   setUsername(String u)     { this.username = u; }

    public String getPassword()             { return password; }
    public void   setPassword(String p)     { this.password = p; }

    public String getFullName()             { return fullName; }
    public void   setFullName(String fn)    { this.fullName = fn; }

    public String getRole()                 { return role; }
    public void   setRole(String role)      { this.role = role; }

    @Override
    public String toString() {
        return "User{id=" + id + ", username='" + username + "', role='" + role + "'}";
    }
}
