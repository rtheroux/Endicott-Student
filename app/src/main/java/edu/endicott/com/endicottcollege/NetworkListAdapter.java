package edu.endicott.com.endicottcollege;

import android.content.Context;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.BaseExpandableListAdapter;
import android.widget.TextView;

import java.util.ArrayList;

/**
 * Created by rosst on 12/8/2017.
 */

public class NetworkListAdapter extends BaseExpandableListAdapter {

    Context context;
    ArrayList<Network> guide;

    public NetworkListAdapter(Context context, ArrayList<Network> guide){
        this.context = context;
        this.guide = guide;
    }

//    @Override
//    public Object getItem(int i) {
//        return guide.get(i);
//    }
//
//    @Override
//    public long getItemId(int i) {
//        return i;
//    }

//    @Override
//    public View getGroupView(int i, View view, ViewGroup viewGroup) {
//        View v = View.inflate(context, R.layout.program_item, null);
//        TextView networkName = (TextView)v.findViewById(R.id.show_list);
//        networkName.setText(guide.get(i).getName());
//        return v;
//    }

    @Override
    public int getGroupCount() {
        return guide.size();
    }

    @Override
    public int getChildrenCount(int i) {
        return guide.get(i).getprogramList().size();
    }

    @Override
    public Object getGroup(int i) {
        return guide.get(i);
    }

    @Override
    public Object getChild(int i, int i1) {
        return guide.get(i).getProgram(i1);
    }

    @Override
    public long getGroupId(int i) {
        return i;
    }

    @Override
    public long getChildId(int i, int i1) {
        return i1;
    }

    @Override
    public boolean hasStableIds() {
        return false;
    }

    @Override
    public View getGroupView(int i, boolean b, View view, ViewGroup viewGroup) {
        View v = View.inflate(context, R.layout.program_item, null);
        TextView networkName = (TextView)v.findViewById(R.id.show_list);
        networkName.setText(guide.get(i).getName());
        return v;
    }

    @Override
    public View getChildView(int i, int i1, boolean b, View view, ViewGroup viewGroup) {
        View v = View.inflate(context, R.layout.program, null);
        TextView networkName = (TextView)v.findViewById(R.id.show);
        networkName.setText(
                guide.get(i).getProgram(i1).getAirtime()
                        + " " +
                guide.get(i).getProgram(i1).getName());
        return v;
    }

    @Override
    public boolean isChildSelectable(int i, int i1) {
        return false;
    }
}
