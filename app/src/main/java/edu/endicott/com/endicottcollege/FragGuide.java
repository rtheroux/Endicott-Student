package edu.endicott.com.endicottcollege;

import android.support.v4.app.Fragment;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ExpandableListView;
import android.widget.ListView;

import java.util.ArrayList;

public class FragGuide extends Fragment {

    private NetworkListAdapter networkListAdapter;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {

        View view = inflater.inflate(R.layout.frag_guide, container, false);

        ExpandableListView expandableListView = (ExpandableListView) view.findViewById(R.id.network_list);
        networkListAdapter = new NetworkListAdapter(getContext().getApplicationContext(), ((MainActivity) getActivity()).getGuide());
        expandableListView.setAdapter(networkListAdapter);
        expandableListView.setOnItemClickListener(new AdapterView.OnItemClickListener(){

            @Override
            public void onItemClick(AdapterView<?> adapterView, View view, int i, long l) {

            }
        });
        return view;
    }

    @Override
    public void onActivityCreated(Bundle savedInstanceState) {

        super.onActivityCreated(savedInstanceState);
    }
}
