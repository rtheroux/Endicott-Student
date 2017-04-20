package edu.endicott.com.endicottcollege;

import android.content.Intent;
import android.net.Uri;
import android.support.v4.app.Fragment;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ListView;

/**
 * Created by muehlemann on 2/22/16.
 *
 */
public class FragSettings extends Fragment {

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {

        View view = inflater.inflate(R.layout.frag_settings, container, false);

        String[] string = new String[] {
                "header",
                "Endicott on Facebook",
                "Endicott on Twitter",
                "header",
                "Icons by icons8.com",
                "Version " + BuildConfig.VERSION_NAME,
                "Created by Matt Mühlemann",
        };

        Integer[] integer = new Integer[] {
                1000,
                R.drawable.set_facebook,
                R.drawable.set_twitter,
                1000,
                R.drawable.set_credit,
                R.drawable.set_version,
                R.drawable.set_author,
        };


        CustomImageAdapter adabpter = new CustomImageAdapter(getContext(), string, integer);

        // Create custom ListView
        ListView modeList = (ListView) view.findViewById(R.id.listview_image);
        modeList.setAdapter(adabpter);
        modeList.setOnItemClickListener(new AdapterView.OnItemClickListener() {

            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {

                switch (position) {
                    case 1:
                        Intent fbIntent = new Intent(Intent.ACTION_VIEW, Uri.parse("https://www.facebook.com/EndicottCollege/"));
                        startActivity(fbIntent);
                        break;
                    case 2:
                        Intent ttIntent = new Intent(Intent.ACTION_VIEW, Uri.parse("https://twitter.com/EndicottCollege"));
                        startActivity(ttIntent);
                        break;
                    case 4:
                        Intent ic8Intent = new Intent(Intent.ACTION_VIEW, Uri.parse("https://icons8.com"));
                        startActivity(ic8Intent);
                        break;
                }

            }
        });

        return view;
    }

}
