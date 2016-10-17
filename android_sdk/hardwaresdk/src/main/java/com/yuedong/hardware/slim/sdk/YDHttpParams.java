package com.yuedong.hardware.slim.sdk;

import org.json.JSONArray;
import org.json.JSONObject;

import java.util.HashMap;

/**
 * Created by virl on 15/5/20.
 */
public class YDHttpParams extends HashMap<String, String>{
    public YDHttpParams(Object... objects) {
        int length = objects.length;
        for(int index=0; index+1<length; index+=2) {
            String key = (String) objects[index];
            put(key, String.valueOf(objects[index+1]));
        }
    }

    public YDHttpParams put(String key, int value) {
        put(key, Integer.toString(value));
        return this;
    }

    public YDHttpParams put(String key, long value) {
        put(key, Long.toString(value));
        return this;
    }

    public YDHttpParams put(String key, float value) {
        put(key, Float.toString(value));
        return this;
    }

    public YDHttpParams put(String key, double value) {
        put(key, Double.toString(value));
        return this;
    }

    public YDHttpParams put(String key, JSONObject value) {
        put(key, value.toString());
        return this;
    }

    public YDHttpParams put(String key, JSONArray value) {
        put(key, value.toString());
        return this;
    }
}
