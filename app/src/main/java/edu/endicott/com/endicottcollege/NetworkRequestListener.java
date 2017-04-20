package edu.endicott.com.endicottcollege;

/**
 * Created by muehlemann on 2/24/16.
 *
 */
public interface NetworkRequestListener {
    void onError(String message);
    void onResponse(String response);
}

