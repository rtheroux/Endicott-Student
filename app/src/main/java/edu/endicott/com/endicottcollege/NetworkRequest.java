package edu.endicott.com.endicottcollege;

import android.content.Context;
import android.util.Base64;

import com.android.volley.AuthFailureError;
import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.StringRequest;
import com.android.volley.toolbox.Volley;

import org.json.JSONObject;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by muehlemann on 2/23/16.
 *
 */
public class NetworkRequest extends JSONObject {

    public NetworkRequest(String url, final Map<String, String> params, final Context context, final NetworkRequestListener listener) {

        RequestQueue queue = Volley.newRequestQueue(context);
        StringRequest jsObjRequest = new StringRequest(Request.Method.POST, url, new Response.Listener<String>() {

            @Override
            public void onResponse(String response) {
                listener.onResponse(response);
            }
        }, new Response.ErrorListener() {

            @Override
            public void onErrorResponse(VolleyError error) {
                listener.onError(error.toString());
            }
        }) {
            @Override
            protected Map<String,String> getParams() {

                return params;
            }

            @Override
            public Map<String, String> getHeaders() throws AuthFailureError {
                Map<String, String> headers = new HashMap<>();
                String auth = "Basic " + Base64.encodeToString(("sodexo:ECSodexo01").getBytes(), Base64.NO_WRAP);
                headers.put("Authorization", auth);
                return headers;
            }
        };

        queue.add(jsObjRequest);
    }
}
