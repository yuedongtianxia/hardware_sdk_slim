package com.yuedong.open.demo;

import android.os.Handler;
import android.os.Looper;
import android.support.annotation.Nullable;

import com.yuedong.hardware.slim.sdk.Cancelable;
import com.yuedong.hardware.slim.sdk.YDNetCallback;
import com.yuedong.hardware.slim.sdk.YDNetInterface;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;
import java.net.InetAddress;
import java.util.HashMap;
import java.util.Map;

import okhttp3.Call;
import okhttp3.Callback;
import okhttp3.FormBody;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;

/**
 * Created by virl on 10/25/16.
 */

public class NetWorkImp implements YDNetInterface {

    private OkHttpClient httpClient;

    public NetWorkImp() {
        httpClient = new OkHttpClient();
    }
    public Cancelable asyncPost(String url, HashMap<String, String> params, YDNetCallback callBack) {
        return asyncDo(HttpMethod.kHttpPost, url, params, callBack);
    }

    public enum HttpMethod {
        kHttpPost,
        kHttpGet,
        kHttpPut,
        kHttpPatch,
        kHttpDelete
    }

    @Nullable
    public Cancelable asyncDo(HttpMethod method, String url, HashMap<String, String> params, YDNetCallback callBack) {
        return asyncDo(method, url, params, null, new HttpCallBack(callBack ,url));
    }

    protected Handler handler = new Handler(Looper.getMainLooper());

    private class HttpCallBack implements Callback {

        private YDNetCallback callBack;
        HttpCallBack(YDNetCallback callBack , String url) {
            this.callBack = callBack;
        }

        @Override
        public void onFailure(Call call, final IOException e) {
            if(callBack == null) {
                return;
            }

            handler.post(new Runnable() {
                @Override
                public void run() {
                    callBack.onNetFinished(YDNetCallback.kNetError, null, e.getLocalizedMessage());
                }
            });
        }

        @Override
        public void onResponse(Call call, final Response response) throws IOException {
            if(callBack == null) {
                return;
            }
            if(response.isSuccessful()) {
                try {
                    final JSONObject resJson = new JSONObject(response.body().string());
                    response.body().close();

                    handler.post(new Runnable() {
                        @Override
                        public void run() {
                            callBack.onNetFinished(response.code(), resJson, null);
                        }
                    });
                } catch (JSONException e) {
                    e.printStackTrace();
                    handler.post(new Runnable() {
                        @Override
                        public void run() {
                            callBack.onNetFinished(YDNetCallback.kNetJsonFormatError, null, null);
                        }
                    });
                }
            } else {
                handler.post(new Runnable() {
                    @Override
                    public void run() {
                        callBack.onNetFinished(response.code(), null, response.message());
                    }
                });
            }
        }
    }

    private String buildUrlForGet(String basUrl,HashMap<String, String> params) {
        if(null==params || params.isEmpty()) {
            return basUrl;
        }
        StringBuilder stringBuilder = new StringBuilder(basUrl);
        stringBuilder.append('?');
        for(Map.Entry<String, String> param: params.entrySet()) {
            stringBuilder.append(param.getKey());
            stringBuilder.append('=');
            stringBuilder.append(param.getValue());
            stringBuilder.append('&');
        }
        stringBuilder.deleteCharAt(stringBuilder.length() - 1);
        return stringBuilder.toString();
    }

    private void configBuilderForMethod(Request.Builder builder,HashMap<String, String> params, HttpMethod method) {
        if(null==params||params.isEmpty()) {
            return;
        }
        FormBody.Builder bodyBuilder = new FormBody.Builder();
        for(Map.Entry<String, String> param: params.entrySet()) {
            bodyBuilder.add(param.getKey(), param.getValue());
        }
        switch (method) {
            case kHttpPost:
                builder.post(bodyBuilder.build());
                break;
            case kHttpDelete:
                builder.delete(bodyBuilder.build());
                break;
            case kHttpPatch:
                builder.patch(bodyBuilder.build());
                break;
            case kHttpPut:
                builder.put(bodyBuilder.build());
                break;
            case kHttpGet:
                break;
        }
    }
    
    @Nullable
    public Cancelable asyncDo(HttpMethod method, String url, HashMap<String, String> params, Map<String, String> headers, Callback callback) {
        Request.Builder builder = new Request.Builder();
        if(method == HttpMethod.kHttpGet) {
            url = buildUrlForGet(url, params);
            builder.get();
        } else {
            configBuilderForMethod(builder, params, method);
        }
        builder.url(url);

        builder.header("Connection" , "Keep-Alive");
        if(null!=headers) {
            for(Map.Entry<String, String> header : headers.entrySet()) {
                builder.header(header.getKey(), header.getValue());
            }
        }

        Request request = builder.build();

        Call call = httpClient.newCall(request);
        call.enqueue(callback);
        return new CancelCall(call);
    }

    private static class CancelCall implements Cancelable {
        Call call;
        public CancelCall(Call call) {
            this.call = call;
        }

        @Override
        public void cancel() {
            call.cancel();
        }
    }
}
