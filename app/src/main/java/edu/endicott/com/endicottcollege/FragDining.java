package edu.endicott.com.endicottcollege;

import android.annotation.SuppressLint;
import android.app.AlertDialog;
import android.graphics.Color;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.ListView;
import android.widget.SimpleAdapter;
import android.widget.TextView;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Locale;
import java.util.Map;

/**
 * Created by muehlemann on 2/19/16.
 *
 */
public class FragDining extends Fragment {

    public WebView webView;
    public JSONArray menu;

    @SuppressLint("SetJavaScriptEnabled")
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {

        // Get the frag view
        View view = inflater.inflate(R.layout.frag_dining, container, false);

        // Get the webView
        webView = (WebView) view.findViewById(R.id.webView);
        webView.getSettings().setJavaScriptEnabled(true);
        webView.setWebViewClient(new webClient());
        webView.loadUrl("http://sodexo:ECSodexo01@xn--mhlemann-65a.net/CallahanDining/backend/ios/menu.php");

        // Load Menu for current date
        Calendar c = Calendar.getInstance();
        SimpleDateFormat df = new SimpleDateFormat("MM/dd/yyyy", Locale.getDefault());
        loadMenu(df.format(c.getTime()));

        Log.i("DATE", df.format(c.getTime()));

        return view;
    }

    @Override
    public void onActivityCreated(Bundle savedInstanceState) {

        super.onActivityCreated(savedInstanceState);
    }

    /**
     * Loads the entire menu for the date
     *
     */
    private void loadMenu(String date) {

        Map<String, String> params = new HashMap<>();
        params.put("date", date);

        new NetworkRequest("http://xn--mhlemann-65a.net/CallahanDining/backend/get-menu.php", params, getContext(), new NetworkRequestListener() {

            @Override
            public void onResponse(String response) {

                JSONObject jsonObj;
                try {
                    jsonObj = new JSONObject(response);
                    menu = jsonObj.getJSONArray("menu");
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }

            @Override
            public void onError(String error) {
                Helper.makeToast(getContext(), "Something went wrong \ud83d\ude1e \nPlease make sure that you are conected to the internet.");
            }

        });
    }

    private class webClient extends WebViewClient {

        @Override
        public boolean shouldOverrideUrlLoading(WebView view, String url) {

            if (url.contains("#")) {
                String[] urls = url.split("#");
                String name = urls[1].replace("&amp;", "&");

                try {

                    List<Map<String, ?>> breakfast = new LinkedList<>();
                    List<Map<String, ?>> lunch = new LinkedList<>();
                    List<Map<String, ?>> dinner = new LinkedList<>();

                    for (int i = 0; i < menu.length(); i++) {
                        JSONObject jsObj = menu.getJSONObject(i);
                        if (jsObj.getString("station").equals(name)) {

                            if (jsObj.getString("type").equals("Breakfast"))
                                breakfast.add(createItem(jsObj.getString("name"), jsObj.getString("description")));
                            else if (jsObj.getString("type").equals("Lunch"))
                                lunch.add(createItem(jsObj.getString("name"), jsObj.getString("description")));
                            else if (jsObj.getString("type").equals("Dinner"))
                                dinner.add(createItem(jsObj.getString("name"), jsObj.getString("description")));
                        }
                    }

                    // Create custom TextView
                    TextView txtView = new TextView(getContext());
                    txtView.setText(name);
                    txtView.setTextSize(20);
                    txtView.setTextColor(Color.BLACK);
                    txtView.setPadding(20, 20, 20, 20);

                    // Create custom adapter
                    CustomDetailAdapter adapter = new CustomDetailAdapter(getContext());
                    adapter.addSection("BREAKFAST", new SimpleAdapter(getContext(), breakfast, R.layout.listview_detail_layout, new String[]{"title", "caption"}, new int[]{R.id.listview_detail_title, R.id.listview_detail_caption}));
                    adapter.addSection("LUNCH",     new SimpleAdapter(getContext(), lunch,     R.layout.listview_detail_layout, new String[]{"title", "caption"}, new int[]{R.id.listview_detail_title, R.id.listview_detail_caption}));
                    adapter.addSection("DINNER",    new SimpleAdapter(getContext(), dinner,    R.layout.listview_detail_layout, new String[]{"title", "caption"}, new int[]{R.id.listview_detail_title, R.id.listview_detail_caption}));

                    // Create custom ListView
                    ListView modeList = new ListView(getContext());
                    modeList.setAdapter(adapter);

                    // Create and display AlertDialog
                    AlertDialog.Builder builder = new AlertDialog.Builder(getContext());
                    builder.setPositiveButton("OK", null);
                    builder.setCustomTitle(txtView);
                    builder.setView(modeList);

                    AlertDialog alert = builder.create();
                    alert.show();

                } catch (JSONException ex) {
                    ex.printStackTrace();
                }
            }

            return true;
        }

        public Map<String, String> createItem(String title, String caption) {

            Map<String,String> item = new HashMap<>();
            item.put("title", title);
            item.put("caption", caption);
            return item;
        }
    }
}