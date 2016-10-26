package com.yuedong.open.demo;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import com.yuedong.hardware.slim.sdk.SDKStatus;
import com.yuedong.hardware.slim.sdk.YDHardwareAuthListener;
import com.yuedong.hardware.slim.sdk.YDHardwareSDK;
import com.yuedong.hardware.slim.sdk.YDRecordSyncCallback;

public class MainActivity extends Activity implements View.OnClickListener, YDHardwareAuthListener, YDRecordSyncCallback {

    private static final String kAppId = "10016";
    private YDHardwareSDK sdk;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        sdk = YDHardwareSDK.instance();
        sdk.config(getApplicationContext(), kAppId);
        getViews();
        initView();
    }

    private void getViews() {
        editSt = (EditText) findViewById(R.id.edit_st);
        editEt = (EditText) findViewById(R.id.edit_et);
        editStep = (EditText) findViewById(R.id.edit_step);
        labelStatus = (TextView) findViewById(R.id.label_status);
        findViewById(R.id.bn_auth).setOnClickListener(this);
        findViewById(R.id.bn_insert).setOnClickListener(this);
        findViewById(R.id.bn_sync).setOnClickListener(this);
    }

    private void initView() {
        if(sdk.getStatus() == SDKStatus.kAuthenticated) {
            labelStatus.setText("已认证");
        } else if(sdk.getStatus() == SDKStatus.kExpiration) {
            labelStatus.setText("已过期");
        } else {
            labelStatus.setText("未认证");
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        YDHardwareSDK.instance().onActivityResult(requestCode, resultCode, data);
        super.onActivityResult(requestCode, resultCode, data);
    }

    private EditText editSt;
    private EditText editEt;
    private EditText editStep;
    private TextView labelStatus;

    @Override
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.bn_auth:
                sdk.tryAuth(this, 27, this);
                break;
            case R.id.bn_insert:
                tryInsertStep();
                break;
            case R.id.bn_sync:
                trySyncStep();
                break;
        }
    }

    private void trySyncStep() {
        if(sdk.getStatus() != SDKStatus.kAuthenticated) {
            Toast.makeText(this, "需要认证", Toast.LENGTH_SHORT).show();
            return;
        }
        if(sdk.getSyncTool().needInit()) {
            sdk.getSyncTool().init(new NetWorkImp());
        }
        sdk.getSyncTool().trySyncRecords(this);
    }

    private void tryInsertStep() {
        if(sdk.getStatus() != SDKStatus.kAuthenticated) {
            Toast.makeText(this, "需要认证", Toast.LENGTH_SHORT).show();
            return;
        }
        long st = Long.valueOf(editSt.getText().toString());
        long et = Long.valueOf(editEt.getText().toString());
        int step = Integer.valueOf(editStep.getText().toString());
        sdk.insertRecord("ceshi", step, 0, 0, st * 1000, et * 1000);
    }

    @Override
    public void onYDAuthFail(String errorMsg) {
        Toast.makeText(this, errorMsg, Toast.LENGTH_SHORT).show();
    }

    @Override
    public void onYDAuthSucc() {
        initView();
    }

    @Override
    public void onYDAuthUserCancel() {
        Toast.makeText(this, "取消", Toast.LENGTH_SHORT).show();
    }

    @Override
    public void onRecordSyncSucc() {
        Toast.makeText(this, "同步成功", Toast.LENGTH_SHORT).show();
    }

    @Override
    public void onRecordSyncFail(int code, String msg) {
        Toast.makeText(this, "同步失败" + code + msg, Toast.LENGTH_SHORT).show();
    }
}
