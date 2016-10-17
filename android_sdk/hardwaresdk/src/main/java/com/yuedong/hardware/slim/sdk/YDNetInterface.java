package com.yuedong.hardware.slim.sdk;

import java.util.HashMap;

/**
 * Created by virl on 10/15/16.
 */

public interface YDNetInterface {
    Cancelable asyncPost(String url, HashMap<String, String> params, YDNetCallback callback);
}
