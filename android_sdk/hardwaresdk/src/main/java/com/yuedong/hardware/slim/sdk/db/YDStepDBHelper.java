package com.yuedong.hardware.slim.sdk.db;

import android.content.Context;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;

/**
 * Created by virl on 10/15/16.
 */

public class YDStepDBHelper extends SQLiteOpenHelper {
    private static final int kDbVersion = 1;

    private static final String kDbName = "yuedong_hardware_db";
    public YDStepDBHelper(Context context) {
        super(context, kDbName, null, kDbVersion);
    }

    @Override
    public void onCreate(SQLiteDatabase sqLiteDatabase) {
    }

    @Override
    public void onOpen(SQLiteDatabase sqLiteDatabase) {
        super.onOpen(sqLiteDatabase);
        TableYDStep.createTable(sqLiteDatabase);
    }

    @Override
    public void onUpgrade(SQLiteDatabase sqLiteDatabase, int oldVersion, int newVersion) {
    }
}
