package com.yuedong.hardware.slim.sdk;

/**
 * Created by virl on 10/15/16.
 */

public interface YDHardwareAuthListener {
    void onYDAuthFail(String errorMsg);
    void onYDAuthSucc();
    void onYDAuthUserCancel();
}
