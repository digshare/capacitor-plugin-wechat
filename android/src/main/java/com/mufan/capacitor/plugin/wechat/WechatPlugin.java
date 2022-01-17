package com.mufan.capacitor.plugin.wechat;

import android.annotation.SuppressLint;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.util.Log;

import androidx.annotation.NonNull;

import com.getcapacitor.JSObject;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginConfig;
import com.getcapacitor.PluginMethod;
import com.getcapacitor.annotation.CapacitorPlugin;
import com.mufan.capacitor.plugin.wechat.wxapi.WXEntryActivity;
import com.tencent.mm.opensdk.modelmsg.SendAuth;
import com.tencent.mm.opensdk.openapi.IWXAPI;
import com.tencent.mm.opensdk.openapi.WXAPIFactory;

@CapacitorPlugin(name = "Wechat")
public class WechatPlugin extends Plugin {
    public static String AUTH_URL = "";
    public static String APP_ID;

    private Wechat implementation = new Wechat();
    public static IWXAPI api;

    public static String TAG = "capacitor-wechat:";
    private static String CURRENT_CALLBACK_ID;
    public Handler handler = null;

    public static final int AUTH = 99;
    public static final int PAY = 98;

    @Override
    protected void handleOnStart() {
        PluginConfig config = this.getConfig();

        APP_ID = config.getString("appId");

        api = WXAPIFactory.createWXAPI(getContext(), APP_ID, true);
        boolean result = api.registerApp(APP_ID);
        Log.d(TAG, "register to wechat" + (result ? "true" : "false") + APP_ID);
    }

    @PluginMethod()
    public void login(PluginCall call) {
        AUTH_URL = "";
        final SendAuth.Req req = new SendAuth.Req();
        req.scope = "snsapi_userinfo";
        req.state = "capacitor-wechat";
        bridge.saveCall(call);
        CURRENT_CALLBACK_ID = call.getCallbackId();
        WXEntryActivity.setHandlerAuth(getHandler());
//        api = WXAPIFactory.createWXAPI(getContext(), APP_ID, true);
        api.sendReq(req);
        Log.i(TAG, "send auth request to wechat");
    }

    @PluginMethod
    public void echo(PluginCall call) {
        String value = call.getString("value");

        JSObject ret = new JSObject();
        ret.put("value", implementation.echo(value));
        call.resolve(ret);
    }

    @SuppressLint("HandlerLeak")
    protected Handler getHandler(){
        if(handler == null){
            return new Handler(message -> {
                if (CURRENT_CALLBACK_ID == null) {
                    return false;
                }

                int tag = message.what;
                switch (tag) {
                    case PAY:
                    case AUTH: {
                        Bundle data = message.getData();

                        try{
                            Log.i(TAG, data.getString("result"));
                            JSObject json = new JSObject(data.getString("result"));
                            PluginCall savedCall = bridge.getSavedCall(CURRENT_CALLBACK_ID);

                            CURRENT_CALLBACK_ID = null;

                            if(savedCall == null) {
                                Log.i(TAG, "no savedCall");
                                return true;
                            }

                            savedCall.resolve(json);
                        } catch(Exception e) {
                            Log.e(TAG, e.getMessage());
                        }
                    }
                }

                return false;
            });
        }else{
            return handler;
        }

    }
}
