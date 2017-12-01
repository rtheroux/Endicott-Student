package edu.endicott.com.endicottcollege;

import android.os.Bundle;
import android.support.design.widget.NavigationView;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.view.GravityCompat;
import android.support.v4.widget.DrawerLayout;
import android.support.v7.app.ActionBarDrawerToggle;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.view.MenuItem;


public class MainActivity extends AppCompatActivity implements NavigationView.OnNavigationItemSelectedListener {

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

        setFragment(FragSettings.class);
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
                fragmentClass = FragSettings.class;
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
}