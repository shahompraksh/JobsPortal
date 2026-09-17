package model;

public class Job {
    int id;

   
    String title;
    String company;
    String location;
    double salary;
    String description;
    String type;
 public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }
    public String getTitle() 
    { 
        return title; 
    }
    public void setTitle(String title) {
        this.title = title; 
    }

    public String getCompany() { 
        return company; 
    }
    public void setCompany(String company) { 
        this.company = company; 
    }

    public String getLocation() { 
        return location; 
    }
    public void setLocation(String location) { 
        this.location = location; 
    }

    public double getSalary() { 
        return salary; 
    }
    public void setSalary(double salary) { 
        this.salary = salary; 
    }

    public String getDescription() { 
        return description; 
    }
    public void setDescription(String description) { 
        this.description = description; 
    }

    public String getType() { 
        return type; 
    }
    public void setType(String type) { 
        this.type = type; 
    }
}
