package com.yuedong.hardware.slim.sdk.db;

import android.content.ContentValues;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;

import java.util.List;

/**
 * Created by virl on 10/15/16.
 */

public class TableYDStep {
    public static final String kTableName = "yd_step";
    public static final String kColId = "_id";
    public static final String kColUid = "uid";
    public static final String kColSt = "st";
    public static final String kColEt = "et";
    public static final String kColStep = "step";
    public static final String kColDisM = "disM";
    public static final String kColCalorie = "calorie";
    public static final String kColDid = "did";
    public static final String kColTS = "ts";

    public static void createTable(SQLiteDatabase db) {
        db.execSQL("create table if not exists " + kTableName + "(" +
                kColId + " integer primary key autoincrement," +
                kColUid + " text not null," +
                kColDid + " text not null," +
                kColSt + " integer not null," +
                kColEt + " integer not null," +
                kColTS + " integer not null," +
                kColStep + " integer default 0," +
                kColDisM + " REAL default 0," +
                kColCalorie + " integer default 0);");
    }

    public static long insert(SQLiteDatabase db, String uid, String did, int stepCount, float disM, int calorie, long startTimeSec, long endTimeSec) {
        ContentValues values = new ContentValues();
        values.put(kColDisM, disM);
        values.put(kColSt, startTimeSec);
        values.put(kColEt, endTimeSec);
        values.put(kColStep, stepCount);
        values.put(kColCalorie, calorie);
        values.put(kColUid, uid);
        values.put(kColDid, did);
        values.put(kColTS, System.currentTimeMillis());
        return db.insert(kTableName, null, values);
    }

    public static long getLastInsertRecordEndTimeSec(SQLiteDatabase db) {
        String sql = "select max(" + kColEt + ") as maxEt from " + kTableName;
        Cursor cursor = db.rawQuery(sql, null);
        long lastRecordEndTimeSec = 0;
        if(cursor.moveToFirst()) {
            lastRecordEndTimeSec = cursor.getLong(0);
        }
        cursor.close();
        return lastRecordEndTimeSec;
    }

    public static class Record {
        public String uid;
        public long id;
        public long st;
        public long et;
        public int step;
        public float disM;
        public String did;
        public int calorie;
        public long ts;
    }

    public static void queryForUser(SQLiteDatabase db, String uid, List<Record> recordList) {
        String selection = kColUid + "=" + uid;
        Cursor cursor = db.query(kTableName, null, selection, null, null, null, null, null);
        if(cursor.moveToFirst()) {
            int indexId = cursor.getColumnIndex(kColId);
            int indexSt = cursor.getColumnIndex(kColSt);
            int indexEt = cursor.getColumnIndex(kColEt);
            int indexStep = cursor.getColumnIndex(kColStep);
            int indexCal = cursor.getColumnIndex(kColCalorie);
            int indexDis = cursor.getColumnIndex(kColDisM);
            int indexTs = cursor.getColumnIndex(kColTS);
            int indexDid = cursor.getColumnIndex(kColDid);
            do {
                Record record = new Record();
                record.uid = uid;
                record.calorie = cursor.getInt(indexCal);
                record.id = cursor.getLong(indexId);
                record.st = cursor.getLong(indexSt);
                record.et = cursor.getLong(indexEt);
                record.step = cursor.getInt(indexStep);
                record.disM = cursor.getInt(indexDis);
                record.ts = cursor.getLong(indexTs);
                record.did = cursor.getString(indexDid);
                recordList.add(record);
            } while (cursor.moveToNext());
        }
        cursor.close();
    }

    public static void removeRecords(SQLiteDatabase db, long ts) {
        String selection = kColTS + "<=" + ts;
        db.delete(kTableName, selection, null);
    }

    public static void clearData(SQLiteDatabase db) {
        db.delete(kTableName, null, null);
    }
}
