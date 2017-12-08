package edu.endicott.com.endicottcollege;

import android.support.annotation.NonNull;

import java.util.ArrayList;

/**
 * Created by rosst on 12/8/2017.
 */

public class Network implements Comparable<Network>{
    String name;
    private ArrayList<Program> programs;

    public Network(String name){
        programs = new ArrayList<>();
        this.name = name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getName() {
        return name;
    }

    public void addProgram(Program program){
        programs.add(program);
    }

    public Program getProgram(int i){
        return programs.get(i);
    }

    public ArrayList<Program> getprogramList(){
        return programs;
    }

    @Override
    public int compareTo(@NonNull Network network) {
        return name.compareTo(network.getName());
    }
}
