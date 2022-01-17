#import <Foundation/Foundation.h>
#import <Capacitor/Capacitor.h>

// Define the plugin using the CAP_PLUGIN Macro, and
// each method the plugin supports using the CAP_PLUGIN_METHOD macro.
CAP_PLUGIN(WechatPlugin, "Wechat",
           CAP_PLUGIN_METHOD(echo, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(registerApp, CAPPluginReturnNone);
           CAP_PLUGIN_METHOD(login, CAPPluginReturnNone);
           CAP_PLUGIN_METHOD(single, CAPPluginReturnNone);
)
