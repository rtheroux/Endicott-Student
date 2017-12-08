package edu.endicott.com.endicottcollege;

import android.content.Context;
import android.os.Bundle;
import android.support.design.widget.NavigationView;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.view.GravityCompat;
import android.support.v4.widget.DrawerLayout;
import android.support.v7.app.ActionBarDrawerToggle;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.util.Log;
import android.view.MenuItem;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Collections;


public class MainActivity extends AppCompatActivity implements NavigationView.OnNavigationItemSelectedListener {

    protected ArrayList<Program> programs;
    public ArrayList<Network> guide;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);

        DrawerLayout drawer = (DrawerLayout) findViewById(R.id.drawer_layout);
        ActionBarDrawerToggle toggle = new ActionBarDrawerToggle(this, drawer, toolbar, R.string.navigation_drawer_open, R.string.navigation_drawer_close);
        drawer.setDrawerListener(toggle);
        toggle.syncState();

        NavigationView navigationView = (NavigationView) findViewById(R.id.nav_view);
        navigationView.setNavigationItemSelectedListener(this);
        navigationView.setItemIconTintList(null);

        guide = generateGuide();
    }

    @Override
    public boolean onNavigationItemSelected(MenuItem item) {

        Class fragmentClass;

        switch(item.getItemId()) {
            case R.id.nav_dining:
                fragmentClass = FragDining.class;
                break;
            case R.id.nav_schedule:
                fragmentClass = FragSchedule.class;
                break;
            case R.id.nav_settings:
                fragmentClass = FragSettings.class;
                break;
            case R.id.nav_guide:
                fragmentClass = FragGuide.class;
                break;
            default:
                fragmentClass = FragGuide.class;
        }

        // Sets the new fragment
        setFragment(fragmentClass);

        // Highlight the selected item, update the title, and close the drawer
        DrawerLayout drawer = (DrawerLayout) findViewById(R.id.drawer_layout);
        drawer.closeDrawer(GravityCompat.START);
        return true;
    }

    public void setFragment(Class fragmentClass) {

        try {
            Fragment fragment = (Fragment) fragmentClass.newInstance();

            // Insert the fragment by replacing any existing fragment
            FragmentManager fragmentManager = getSupportFragmentManager();
            fragmentManager.beginTransaction().replace(R.id.fragment_content, fragment).commit();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    //https://stackoverflow.com/questions/13814503/reading-a-json-file-in-android
    public String loadJSONFromAsset(Context context) {
        String json;
        try {
            InputStream is = context.getAssets().open("schedule.json");
            int size = is.available();

            byte[] buffer = new byte[size];

            is.read(buffer);

            is.close();

            json = new String(buffer, "UTF-8");


        } catch (IOException ex) {
            ex.printStackTrace();
            return null;
        }
        return json;
    }

    public ArrayList<Network> getGuide(){
        return guide;
    }

    private ArrayList<Network> generateGuide(){
        JSONArray fullSchedule;
        JSONObject unformattedProgram;
        Program currentProgram;
        boolean networkExists;

        programs = new ArrayList<>();
        guide = new ArrayList<>();

        try {
            fullSchedule = new JSONArray(loadJSONFromAsset(this));

            for (int i = 0; i < fullSchedule.length(); i++){
                networkExists = false;

                unformattedProgram = fullSchedule.getJSONObject(i);
                currentProgram = new Program(
                        unformattedProgram.getJSONObject("show").getString("name"),
                        unformattedProgram.getInt("runtime"),
                        unformattedProgram.getJSONObject("show").getJSONObject("network").getJSONObject("country").getString("timezone"),
                        unformattedProgram.getJSONObject("show").getJSONObject("network").getString("name"),
                        unformattedProgram.getString("airtime"),
                        unformattedProgram.getString("airdate")
                );
                programs.add(currentProgram);

                // for each unique network name, create network, add to guide
                for (int j = 0; j < guide.size(); j++){
                    if (guide.get(j).getName().equals(currentProgram.getNetwork())){
                        // if program's name matches network name, add program to network
                        guide.get(j).addProgram(currentProgram);
                        networkExists = true;
                    }
                }

                //if no network existed with that name, make a new network
                if (!networkExists){
                    guide.add(new Network(currentProgram.getNetwork()));
                    Log.d("new network", currentProgram.getNetwork());
                }
            }
        } catch (JSONException e) {
            e.printStackTrace();
        }

        Collections.sort(guide);

        return guide;
    }
}