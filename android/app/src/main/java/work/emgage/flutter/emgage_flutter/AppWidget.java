package work.emgage.flutter.emgage_flutter;

import android.app.PendingIntent;
import android.appwidget.AppWidgetManager;
import android.content.Context;
import android.content.SharedPreferences;
import android.net.Uri;
import android.widget.Button;
import android.widget.RemoteViews;

import androidx.annotation.NonNull;

import es.antonborri.home_widget.HomeWidgetBackgroundIntent;
import es.antonborri.home_widget.HomeWidgetProvider;

public class AppWidget extends HomeWidgetProvider{

    @Override
    public void onUpdate(@NonNull Context context, @NonNull AppWidgetManager appWidgetManager, @NonNull int[] appWidgetIds, @NonNull SharedPreferences widgetData) {
        for(int widgetId: appWidgetIds){
            RemoteViews remoteViews= new RemoteViews(context.getPackageName(),R.layout.widget_layout);

            int MAX_PROGRESS=85;
            int punch_status = widgetData.getInt("punch", 0);
            int current_progress=widgetData.getInt("progress",0);
            if(punch_status==1){
                remoteViews.setImageViewResource(R.id.punch_img,R.drawable.punchin_shape);
            }else  if(punch_status==0){
                remoteViews.setImageViewResource(R.id.punch_img,R.drawable.punchout_shape);
            }

            if(punch_status==1 && MAX_PROGRESS != current_progress){
                remoteViews.setProgressBar(R.id.time_progress,MAX_PROGRESS,current_progress+5,false);
                widgetData.edit().putInt("progress",current_progress+5).commit();
            }else {
                remoteViews.setProgressBar(R.id.time_progress,80,current_progress,false);
            }

            PendingIntent backgroundIntent= HomeWidgetBackgroundIntent.INSTANCE.getBroadcast(context, Uri.parse("myAppWidget://innerbtnclick"));
            remoteViews.setOnClickPendingIntent(R.id.punch_btn,backgroundIntent);
            appWidgetManager.updateAppWidget(widgetId,remoteViews);
        }

    }
}