package edu.endicott.com.endicottcollege;

import android.content.Context;
import android.view.View;
import android.widget.Toast;

/**
 * Created by muehlemann on 3/16/16.
 *
 */
public class Helper {

    private static Toast toast;


    static void makeToast(Context c, String str) {

        if (toast == null || toast.getView().getWindowVisibility() != View.VISIBLE)
            toast = Toast.makeText(c, str, Toast.LENGTH_SHORT);
        else
            toast.setText(str);

        toast.show();
    }

}
