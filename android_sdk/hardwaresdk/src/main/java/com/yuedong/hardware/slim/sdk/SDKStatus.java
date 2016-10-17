package com.yuedong.hardware.slim.sdk;

public enum SDKStatus {
    kUnAuthenticate(0),
    kAuthenticated(1),
    kExpiration(2);
    int value;

    SDKStatus(int value) {
        this.value = value;
    }

    public static SDKStatus valueOfInt(int value) {
        switch (value) {
            case 0:
                return kUnAuthenticate;
            case 1:
                return kAuthenticated;
            case 2:
                return kExpiration;
        }
        return kUnAuthenticate;
    }
}