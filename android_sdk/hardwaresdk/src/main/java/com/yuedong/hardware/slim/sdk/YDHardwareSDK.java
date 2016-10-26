package com.yuedong.hardware.slim.sdk;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.pm.PackageManager;
import android.content.pm.ResolveInfo;
import android.database.sqlite.SQLiteDatabase;
import android.net.Uri;
import android.text.TextUtils;

import com.yuedong.hardware.slim.sdk.db.TableYDStep;
import com.yuedong.hardware.slim.sdk.db.YDStepDBHelper;

/**
 * Created by virl on 10/15/16.
 */

public class YDHardwareSDK {
    private static YDHardwareSDK sInstance;
    public static YDHardwareSDK instance() {
        if(sInstance == null) {
            sInstance = new YDHardwareSDK();
        }
        return sInstance;
    }

    String appId;
    private Context appContext;
    String token;
    String uid;
    public void config(Context appContext, String appId) {
        this.appContext = appContext;
        this.appId = appId;
        loadAuthInfo();
    }

    void onTokenExpiration() {
        status = SDKStatus.kExpiration;
        saveAuthInfo();
    }

    public SDKStatus status = SDKStatus.kUnAuthenticate;
    public SDKStatus getStatus() {
        return status;
    }

    private static final String kSpName = "yuedong_hardware_open_sp";
    private SharedPreferences sp() {
        return appContext.getSharedPreferences(kSpName, Context.MODE_PRIVATE);
    }

    private static final String kKeyUid = "uid";
    private static final String kKeyToken = "token";
    private static final String kKeyStatus = "status";
    private void saveAuthInfo() {
        sp().edit().putString(kKeyUid, uid).putString(kKeyToken, token).putInt(kKeyStatus, status.value).apply();
    }

    public boolean isYuedongInstalled(Context context) {
        PackageManager pm = context.getPackageManager();
        Intent intent = pm.getLaunchIntentForPackage("com.yuedong.sport");
        return intent != null;
    }

    private void loadAuthInfo() {
        SharedPreferences sp = sp();
        uid = sp.getString(kKeyUid, null);
        token = sp.getString(kKeyToken, null);
        status = SDKStatus.valueOfInt(sp.getInt(kKeyStatus, SDKStatus.kUnAuthenticate.value));
    }

    private void onAuthSucc() {
        status = SDKStatus.kAuthenticated;
        saveAuthInfo();
    }

    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        if(requestCode != this.requestCode) {
            return;
        }
        if(listener == null) {
            return;
        }
        if(resultCode == Activity.RESULT_OK) {
            if(data == null) {
                listener.onYDAuthFail("data error");
            } else {
                int code = data.getIntExtra("code", -1);
                String msg = data.getStringExtra("msg");
                if(code == 0) {
                    String token = data.getStringExtra("token");
                    String uid = data.getStringExtra("uid");
                    if(status == SDKStatus.kExpiration) {
                        if(!uid.equalsIgnoreCase(this.uid)) {
                            TableYDStep.clearData(db());
                        }
                    }
                    this.uid = uid;
                    this.token = token;
                    onAuthSucc();
                    listener.onYDAuthSucc();
                } else {
                    listener.onYDAuthFail(msg);
                }
            }
        } else {
            listener.onYDAuthUserCancel();
        }
        listener = null;
    }

    private int requestCode = -1;
    private YDHardwareAuthListener listener;
    public void tryAuth(Activity activity, int requestCode, YDHardwareAuthListener listener) {
        if(TextUtils.isEmpty(appId)) {
            listener.onYDAuthFail("need config before auth");
            return;
        }
        if(!isYuedongInstalled(activity)) {
            listener.onYDAuthFail("悦动圈not install");
            return;
        }

        String url = "yuedongopen://authorize?app_id=" + appId;
        Intent intent = new Intent(Intent.ACTION_VIEW, Uri.parse(url));
        PackageManager packageManager = activity.getPackageManager();
        ResolveInfo resolveInfo = packageManager.resolveActivity(intent, 0);
        if(resolveInfo == null) {
            listener.onYDAuthFail("请升级最新版悦动圈");
            return;
        }
        this.listener = listener;
        this.requestCode = requestCode;
        activity.startActivityForResult(intent, requestCode);
    }

    private SQLiteDatabase db;
    private long lastRecordEndTimeMs = -1;

    public boolean insertRecord(String did, int stepCount, float disM, int calorie, long startTimeMs, long endTimeMs) {
        if(status == SDKStatus.kUnAuthenticate) {
            return false;
        }

        if(db() == null) {
            return false;
        }
        if(lastRecordEndTimeMs == -1) {
            lastRecordEndTimeMs = TableYDStep.getLastInsertRecordEndTimeSec(db) * 1000;
        }
        if(startTimeMs < lastRecordEndTimeMs) {
            return true;
        }
        TableYDStep.insert(db, uid, did, stepCount, disM, calorie, startTimeMs/1000, endTimeMs/1000);
        return true;
    }

    private YDRecordSyncTool syncTool;
    public YDRecordSyncTool getSyncTool() {
        if(syncTool == null) {
            syncTool = new YDRecordSyncTool(this);
        }
        return syncTool;
    }

    SQLiteDatabase db() {
        if(db == null) {
            YDStepDBHelper dbHelper = new YDStepDBHelper(appContext);
            db = dbHelper.getReadableDatabase();
        }
        return db;
    }
}
