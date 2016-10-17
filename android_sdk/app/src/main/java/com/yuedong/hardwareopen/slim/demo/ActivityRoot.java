package com.yuedong.hardwareopen.slim.demo;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;

public class ActivityRoot extends Activity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_root);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
    }
}
