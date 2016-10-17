package com.yuedong.hardware.slim.sdk;

/**
 * Created by virl on 10/15/16.
 */

public interface YDRecordSyncCallback {
    void onRecordSyncSucc();
    void onRecordSyncFail(int code, String msg);

    int kCodeOk = 0;
    int kCodeNetUnConnected = -1;
    int kCodeNeedInit = -2;
    int kCodeNeedAuth = -3;
    int kCodeExpiration = -4;
}
