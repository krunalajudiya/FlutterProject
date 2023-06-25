package work.emgage.flutter.emgage_flutter;

import static androidx.core.content.PermissionChecker.checkSelfPermission;

import android.app.PendingIntent;
import android.appwidget.AppWidgetManager;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.pm.PackageManager;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Build;
import android.os.SystemClock;
import android.widget.RemoteViews;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;
import androidx.core.content.PermissionChecker;

import org.json.JSONException;
import org.json.JSONObject;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

import es.antonborri.home_widget.HomeWidgetBackgroundIntent;
import es.antonborri.home_widget.HomeWidgetLaunchIntent;
import es.antonborri.home_widget.HomeWidgetProvider;

public class PunchWidget extends HomeWidgetProvider{
    static final String PUNCH_DATA_KEY = "punch_data";
    static final String CLICK_PUNCH_BUTTON = "punch_btn_click";

    SharedPreferences widgets_data;

    @RequiresApi(api = Build.VERSION_CODES.S)
    @Override
    public void onUpdate(@NonNull Context context, @NonNull AppWidgetManager appWidgetManager, @NonNull int[] appWidgetIds, @NonNull SharedPreferences widgetData) {
        for (int widgetId : appWidgetIds) {
            RemoteViews remoteViews = new RemoteViews(context.getPackageName(), R.layout.punch_layout);

            widgets_data=widgetData;

            String map_data = widgetData.getString(PUNCH_DATA_KEY, "");
            if (!isNullOrIsEmpty(map_data)) {
                try {
                    JSONObject jsonObject = new JSONObject(map_data);
                    String intime = jsonObject.getString("actualInTime");
                    String outtime = jsonObject.getString("actualOutTime");
                    String startclock = jsonObject.getString("startClock");
                    String totalseconds = jsonObject.getString("totalSeconds");
                    String punch_status = jsonObject.getString("punch_status");

                    if (!isNullOrIsEmpty(intime))
                        remoteViews.setTextViewText(R.id.intime_txt, intime);
                    else
                        remoteViews.setTextViewText(R.id.intime_txt, "00:00 AA");
                    if (!isNullOrIsEmpty(outtime))
                        remoteViews.setTextViewText(R.id.outtime_txt, outtime);
                    else
                        remoteViews.setTextViewText(R.id.outtime_txt, "00:00 AA");
                    if (!isNullOrIsEmpty(startclock) && !isNullOrIsEmpty(totalseconds))
                        remoteViews.setChronometer(R.id.shift_timer, SystemClock.elapsedRealtime() - (Integer.parseInt(totalseconds) * 1000), "%tH:%tM:%tS", Boolean.parseBoolean(startclock));
                    else
                        remoteViews.setChronometer(R.id.shift_timer, SystemClock.elapsedRealtime(), "%tH:%tM:%tS", false);

                    if (!isNullOrIsEmpty(punch_status))
                        remoteViews.setTextViewText(R.id.punch_in_txt, punch_status);
                    else
                        remoteViews.setTextViewText(R.id.punch_in_txt, "PUNCH IN");

                } catch (JSONException e) {

                }
            }
//            if (widgetData.getInt(CLICK_PUNCH_BUTTON, 0) != 1) {
//                try {
//                    PendingIntent refresh_data_intent = HomeWidgetBackgroundIntent.INSTANCE.getBroadcast(context, Uri.parse("myAppWidget://refresh_data"));
//                    refresh_data_intent.send();
//                } catch (Exception e) {
//                }
//            } else {
//                widgetData.edit().putInt(CLICK_PUNCH_BUTTON, 0).commit();
//            }

//            PendingIntent button_click_intent = HomeWidgetBackgroundIntent.INSTANCE.getBroadcast(context, Uri.parse("myAppWidget://punchin_btn_click"));
//            remoteViews.setOnClickPendingIntent(R.id.punch_btn_layout, button_click_intent);
//            PendingIntent pendingIntent = HomeWidgetLaunchIntent.INSTANCE.getActivity(context,MainActivity.class,Uri.parse("myAppWidget://punchin_btn_click"));
            remoteViews.setOnClickPendingIntent(R.id.punch_btn_layout,punch_click(context));
            appWidgetManager.updateAppWidget(widgetId, remoteViews);


        }
    }

    static boolean isNullOrIsEmpty(String obj) {
        return obj == null || obj.equals("") || obj.equals("null");
    }

    PendingIntent punch_click(Context context){
        widgets_data.edit().putBoolean("val",true).commit();
        return HomeWidgetLaunchIntent.INSTANCE.getActivity(context,MainActivity.class,Uri.parse("myAppWidget://punchin_btn_click"));
    }
}
