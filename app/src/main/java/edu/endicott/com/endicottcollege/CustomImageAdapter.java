package edu.endicott.com.endicottcollege;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.TextView;

/**
 * Created by muehlemann on 3/19/16.
 *
 */
class CustomImageAdapter extends ArrayAdapter<String> {

    private final Context context;
    private final String[] itemname;
    private final Integer[] imgid;

    public CustomImageAdapter(Context context, String[] itemname, Integer[] imgid) {

        super(context, R.layout.listview_image_layout, itemname);

        this.context  = context;
        this.itemname = itemname;
        this.imgid    = imgid;
    }

    public View getView(int position, View view, ViewGroup parent) {

        LayoutInflater inflater = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        view                    = inflater.inflate(R.layout.listview_image_layout, null, true);
        TextView txtTitle       = (TextView) view.findViewById(R.id.listview_image_title);
        ImageView imageView     = (ImageView) view.findViewById(R.id.listview_image_icon);

        if (itemname[position].equals("header") && imgid[position] == 1000) {
            view = inflater.inflate(R.layout.listview_detail_header, null, true);
        } else {
            txtTitle.setText(itemname[position]);
            imageView.setImageResource(imgid[position]);
        }

        return view;
    }
}