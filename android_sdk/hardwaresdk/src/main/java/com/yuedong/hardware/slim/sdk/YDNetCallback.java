package com.yuedong.hardware.slim.sdk;

import org.json.JSONObject;

/**
 * Created by virl on 10/15/16.
 */

public interface YDNetCallback {
    void onNetFinished(int code, JSONObject netRes, String errorMsg);
}
