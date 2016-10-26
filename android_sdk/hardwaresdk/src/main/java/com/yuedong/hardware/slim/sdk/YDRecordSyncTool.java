package com.yuedong.hardware.slim.sdk;

import com.yuedong.hardware.slim.sdk.db.TableYDStep;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.LinkedList;

/**
 * Created by virl on 10/15/16.
 */

public class YDRecordSyncTool implements Cancelable, YDNetCallback {
    private YDNetInterface netInterface;
    private static final String kPostUrl = "http://api.51yund.com/hardware/report_hardware_step_by_slim_sdk";
    public void init(YDNetInterface netInterface) {
        this.netInterface = netInterface;
    }

    private YDHardwareSDK sdk;
    private Cancelable request;
    YDRecordSyncTool(YDHardwareSDK sdk) {
        this.sdk = sdk;
    }

    public boolean needInit() {
        return this.netInterface == null;
    }

    @Override
    public void cancel() {

    }

    private YDRecordSyncCallback callback;
    private long maxRecordTs;
    private LinkedList<TableYDStep.Record> records = new LinkedList<>();
    public void trySyncRecords(YDRecordSyncCallback callback) {
        if(needInit()) {
            callback.onRecordSyncFail(YDRecordSyncCallback.kCodeNeedInit, "需要初始化YDRecordSyncTool");
            return;
        }
        if(sdk.status == SDKStatus.kExpiration) {
            callback.onRecordSyncFail(YDRecordSyncCallback.kCodeExpiration, "授权过期");
            return;
        }
        if(sdk.status == SDKStatus.kUnAuthenticate) {
            callback.onRecordSyncFail(YDRecordSyncCallback.kCodeNeedAuth, "没有授权");
            return;
        }
        this.callback = callback;
        if(request != null) {
            return;
        }
        records.clear();
        TableYDStep.queryForUser(sdk.db(), sdk.uid, records);
        if(records.isEmpty()) {
            this.callback = null;
            callback.onRecordSyncSucc();
            return;
        }
        maxRecordTs = 0;
        JSONArray jsonArray = new JSONArray();
        for(TableYDStep.Record record : records) {
            jsonArray.put(tranRecordToJSON(record));
            maxRecordTs = Math.max(maxRecordTs, record.ts);
        }
        YDHttpParams params = new YDHttpParams();
        params.put("steps", jsonArray.toString());
        params.put("user_id", sdk.uid);
        params.put("token", sdk.token);
        params.put("app_id", sdk.appId);
        request = netInterface.asyncPost(kPostUrl, params, this);
    }

    private JSONObject tranRecordToJSON(TableYDStep.Record record) {
        JSONObject jsonObject = new JSONObject();
        try {
            jsonObject.put("st", record.st);
            jsonObject.put("et", record.et);
            jsonObject.put("step", record.step);
            jsonObject.put("dis", record.disM);
            jsonObject.put("calorie", record.calorie);
            jsonObject.put("did", record.did);
        } catch (JSONException e) {
            e.printStackTrace();
        }
        return jsonObject;
    }

    @Override
    public void onNetFinished(int code, JSONObject netRes, String errorMsg) {
        request = null;
        YDRecordSyncCallback callback = this.callback;
        this.callback = null;
        if(netRes != null) {
            int c = netRes.optInt("code", -1);
            if(c == 0) {
                TableYDStep.removeRecords(sdk.db(), maxRecordTs);
                callback.onRecordSyncSucc();
            } else if(c == 404){
                sdk.onTokenExpiration();
                callback.onRecordSyncFail(YDRecordSyncCallback.kCodeExpiration, netRes.optString("msg"));
            } else {
                callback.onRecordSyncFail(c, netRes.optString("msg"));
            }
        } else {
            callback.onRecordSyncFail(code, errorMsg);
        }
    }
}
