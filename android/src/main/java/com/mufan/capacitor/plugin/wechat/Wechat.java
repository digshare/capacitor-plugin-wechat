package com.mufan.capacitor.plugin.wechat;

import android.content.Context;
import android.util.Log;

import com.tencent.mm.opensdk.openapi.WXAPIFactory;

public class Wechat {

    public String echo(String value) {
        return value;
    }

    public void auth() {
        System.out.printf("## auth");
    }
}
