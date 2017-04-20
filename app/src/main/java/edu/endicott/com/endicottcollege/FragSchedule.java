package edu.endicott.com.endicottcollege;

import android.app.ActionBar;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.graphics.Color;
import android.support.v4.app.Fragment;
import android.os.Bundle;
import android.support.v7.app.AlertDialog;
import android.text.Html;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.Display;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.GridLayout;
import android.widget.HorizontalScrollView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by muehlemann on 2/22/16.
 *
 */
public class FragSchedule extends Fragment {

    public int width;
    public int height;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {

        // Get the frag view
        View view = inflater.inflate(R.layout.frag_schedule, container, false);

        // Get the Window Manager
        WindowManager wm = (WindowManager) getContext().getSystemService(Context.WINDOW_SERVICE);
        Display display = wm.getDefaultDisplay();
        DisplayMetrics d = new DisplayMetrics();
        display.getMetrics(d);

        // Set the width and height
        width  = d.widthPixels;
        height = d.heightPixels;

        // Set up the scroll view layout
        final float scale = getContext().getResources().getDisplayMetrics().density;
        final RelativeLayout layout = (RelativeLayout) view.findViewById(R.id.layout);
        layout.setMinimumWidth(width * 5);
        layout.setMinimumHeight((int) (780 * scale));

        // Pagnation of Horizontal Scroll View
        setUpPagnation(view);

        // Add the time seperators
        setUpTimeSeperators(layout, scale);

        // Check prefrences for username and password
        SharedPreferences preferences = getContext().getSharedPreferences("MyPreferences", Context.MODE_PRIVATE);
        String username = preferences.getString("username", "null");
        String password = preferences.getString("password", "null");

        if (username.equals("null") || password.equals("null")) {
            promptLogin(inflater, layout, R.string.login);
        } else {
            makeNewtworkRequest(inflater, layout, username, password);
        }

        return view;
    }

    @Override
    public void onActivityCreated(Bundle savedInstanceState) {

        super.onActivityCreated(savedInstanceState);
    }

    /**
     * Sets up the pagnation
     *
     */
    public void setUpPagnation(View view) {

        final HorizontalScrollView sv = (HorizontalScrollView) view.findViewById(R.id.scrollview);
        sv.setOnTouchListener(new View.OnTouchListener() {

            @Override
            public boolean onTouch(View v, MotionEvent event) {

                String[] week = {"Monday", "Tuesday", "Wednesday", "Thursday", "Friday"};

                if (event.getAction() == MotionEvent.ACTION_UP || event.getAction() == MotionEvent.ACTION_CANCEL) {
                    int featureWidth = v.getMeasuredWidth();
                    int mActiveFeature = ((sv.getScrollX() + (featureWidth / 2)) / featureWidth);
                    sv.smoothScrollTo(mActiveFeature * featureWidth, 0);

                    Helper.makeToast(getContext(), week[mActiveFeature]);

                    return true;
                } else {
                    return false;
                }
            }
        });
    }

    /**
     * Sets up the time seperators
     *
     */
    public void setUpTimeSeperators(RelativeLayout layout, float scale) {

        int x = 0;
        for (int i = 0; i < 5; i++)
        {
            for (int j = 0; j < 13; j++)
            {
                View line = new View(getContext());
                line.setLayoutParams(new ActionBar.LayoutParams(width - 100, 1));
                line.setX((x * scale) + 100);
                line.setY((j * 60) * scale);
                line.setBackgroundColor(Color.LTGRAY);
                layout.addView(line);

                TextView timeLabel = new TextView(getContext());
                timeLabel.setX((x * scale) + 10);
                timeLabel.setY((2 + (j * 60)) * scale);
                timeLabel.setMinimumWidth(Math.round(50 * scale));
                timeLabel.setMinimumHeight(Math.round(10 * scale));
                timeLabel.setTextColor(Color.LTGRAY);
                timeLabel.setTextSize(10);

                if (j + 8 < 12)
                    timeLabel.setText(String.format("%d AM", j + 8));
                else if (j + 8 > 12)
                    timeLabel.setText(String.format("%d PM", j - 4));
                else
                    timeLabel.setText(R.string.noon);

                layout.addView(timeLabel);
            }

            x = Math.round((width * (i + 1)) / scale);
        }
    }

    /**
     * Prompts the user to login
     *
     */
    public void promptLogin(final LayoutInflater inflater, final RelativeLayout layout, int title) {

        View v = inflater.inflate(R.layout.dialog_login, null);
        final TextView user = (TextView) v.findViewById(R.id.username);
        final TextView pass = (TextView) v.findViewById(R.id.password);

        // Create and display AlertDialog
        AlertDialog.Builder builder = new AlertDialog.Builder(getContext());
        builder.setPositiveButton(R.string.login, null);
        builder.setTitle(title);
        builder.setView(v);

        AlertDialog alert = builder.create();
        alert.show();

        alert.setOnDismissListener(new DialogInterface.OnDismissListener() {

            @Override
            public void onDismiss(DialogInterface dialog) {
                String username = user.getText().toString();
                String password = pass.getText().toString();
                makeNewtworkRequest(inflater, layout, username, password);
            }
        });
    }

    /**
     * Makes a network request
     *
     */
    public void makeNewtworkRequest(final LayoutInflater inflater, final RelativeLayout layout, final String username, final String password) {

        Log.i("USERNAME", username);
        Log.i("PASSWORD", password);

        // Network Request
        Map<String, String> params = new HashMap<>();
        params.put("signinusername", username);
        params.put("signinpassword", password);

        new NetworkRequest("https://cars.endicott.edu/cgi-bin/public/nolij/iosauth.cgi", params, getContext(), new NetworkRequestListener() {

            @Override
            public void onResponse(String response) {

                if (response.contains("ERROR"))
                {
                    // Login not successful
                    promptLogin(inflater, layout, R.string.loging_error);
                }
                else
                {
                    // Login successful
                    SharedPreferences preferences = getContext().getSharedPreferences("MyPreferences", Context.MODE_PRIVATE);
                    SharedPreferences.Editor editor = preferences.edit();
                    editor.putString("username", username);
                    editor.putString("password", password);
                    editor.apply();

                    String reg = "\\}\\{";
                    String[] info = response.split(reg);

                    try {
                        schedule(layout, new JSONObject("{" + info[1]).getJSONObject("classes"));
                    } catch (JSONException e) {
                        e.printStackTrace();
                    }
                }
            }

            @Override
            public void onError(String error) {
                Helper.makeToast(getContext(), "Something went wrong \ud83d\ude1e \nPlease make sure that you are conected to the internet.");
            }
        });
    }

    public void schedule(RelativeLayout layout, JSONObject classObj) {

        JSONArray classNames = classObj.names();
        JSONObject myClass;

        try {
            for (int i = 0; i < classObj.length(); i++) {

                myClass = classObj.getJSONObject(classNames.getString(i));
                String[] days = myClass.getString("days").split("-");

                for (int j = 0; j < days.length; j++) {

                    if (days[j].equals("M"))
                        makeBlock(layout, 50, classNames.getString(i), myClass);
                    else if (days[j].equals("T"))
                        makeBlock(layout, 50 + width, classNames.getString(i), myClass);
                    else if (days[j].equals("W"))
                        makeBlock(layout, 50 + (width * 2), classNames.getString(i), myClass);
                    else if (days[j].equals("R"))
                        makeBlock(layout, 50 + (width * 3), classNames.getString(i), myClass);
                    else if (days[j].equals("F"))
                        makeBlock(layout, 50 + (width * 4), classNames.getString(i), myClass);
                }
            }
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }

    /**
     * Makes a UI Block that represents a class
     *
     */
    public void makeBlock(RelativeLayout layout, int posX, final String title, final JSONObject info) throws JSONException {

        int startPixle = getPixle(info.getString("beg_time"));
        int endPixle = getPixle(info.getString("end_time")) - startPixle;

        RelativeLayout canvas = new RelativeLayout(getContext());
        canvas.setLayoutParams(new ActionBar.LayoutParams(width - 150, endPixle));
        canvas.setX(posX + 90);
        canvas.setY(startPixle);
        canvas.setBackgroundColor(Color.WHITE);
        layout.addView(canvas);

        Button classBlock = new Button(getContext());
        classBlock.setLayoutParams(new ActionBar.LayoutParams(width - 150, endPixle));
        classBlock.setX(0);
        classBlock.setY(0);
        classBlock.setBackgroundColor(hashForColor(title, 0.5));
        classBlock.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                try {
                    String email = info.getString("fac_email");
                    String message = "Dear Professor " + info.getString("fac_name").split(",")[0] + "<br><br><br><br>Best Regards,<br><br>";

                    Intent mail = new Intent(Intent.ACTION_SEND);
                    mail.putExtra(Intent.EXTRA_EMAIL, new String[]{email});
                    mail.putExtra(Intent.EXTRA_SUBJECT, title);
                    mail.putExtra(Intent.EXTRA_TEXT, Html.fromHtml(message));
                    mail.setType("message/rfc822");

                    startActivity(Intent.createChooser(mail, "Choose an Email client :"));

                } catch (JSONException ex) {
                    ex.printStackTrace();
                }
            }
        });
        canvas.addView(classBlock);

        View strongIndicator = new View(getContext());
        strongIndicator.setLayoutParams(new ActionBar.LayoutParams(20, endPixle));
        strongIndicator.setX(0);
        strongIndicator.setY(0);
        strongIndicator.setBackgroundColor(hashForColor(title, 0.0));
        canvas.addView(strongIndicator);

        TextView titleLabel = new TextView(getContext());
        titleLabel.setX(30);
        titleLabel.setY(5);
        titleLabel.setMinimumWidth(classBlock.getWidth() - 40);
        titleLabel.setMinimumHeight(20);
        titleLabel.setText(title);
        canvas.addView(titleLabel);

        String location = info.getString("building") + " " + info.getString("room") + " ";
        TextView locationLabel = new TextView(getContext());
        titleLabel.setX(30);
        titleLabel.setY(5);
        titleLabel.setMinimumWidth(classBlock.getWidth() - 50);
        titleLabel.setMinimumHeight(20);
        locationLabel.setGravity(Gravity.END);
        locationLabel.setText(location);
        locationLabel.setLayoutParams(new ActionBar.LayoutParams(GridLayout.LayoutParams.MATCH_PARENT, GridLayout.LayoutParams.WRAP_CONTENT));
        canvas.addView(locationLabel);
    }

    /**
     * Gets the pixel corresponding to the time string
     *
     */
    public Integer getPixle(String time) {

        String[] components = time.split(":");
        String endMinStr = components[1].substring(0, 2);
        String endDateTimeStr = components[1].substring(2);

        Integer pixle = Integer.valueOf(components[0]) * 60;
        pixle = pixle + Integer.valueOf(endMinStr);

        if (endDateTimeStr.equals("p") && Integer.valueOf(components[0]) != 12)
            pixle = pixle + (12 * 60);

        final float scale = getContext().getResources().getDisplayMetrics().density;
        return (int)((pixle - 480) * scale);
    }

    /**
     * Takes a string and returns a UIColor
     *
     */
    public int hashForColor(String string, double alpha) {

        int hash = 0;
        for (int i = 0; i < 6; i++)
            hash = string.toCharArray()[i] + ((hash << 7) - hash);

        String hex = "#" + Integer.toHexString(hash).substring(2);
        if (alpha == 0.5)
            hex = "#88" + hex.substring(1);
        else
            hex = "#ff" + hex.substring(1);

        return Color.parseColor(hex);
    }
}