package edu.endicott.com.endicottcollege;

public class Program {
    String name;
    int runtime;
    String timezone;
    String network;
    String airtime;
    String airdate;

    public Program(String name, int runtime, String timezone, String network, String airtime, String airdate){
        this.name = name;
        this.runtime = runtime;
        this.timezone = timezone;
        this.network = network;
        this.airtime = airtime;
        this.airdate = airdate;
    }


    public String getAirdate() {
        return airdate;
    }

    public void setAirdate(String airdate) {
        this.airdate = airdate;
    }

    public String getAirtime() {
        return airtime;
    }

    public void setAirtime(String airtime) {
        this.airtime = airtime;
    }

    public String getNetwork() {
        return network;
    }

    public void setNetwork(String network) {
        this.network = network;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setRuntime(int runtime) {
        this.runtime = runtime;
    }

    public void setTimezone(String timezone) {
        this.timezone = timezone;
    }

    public String getName() {
        return name;
    }

    public int getRuntime() {
        return runtime;
    }

    public String getTimezone() {
        return timezone;
    }
}
