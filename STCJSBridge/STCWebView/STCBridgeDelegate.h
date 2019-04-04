//
//  STCBridgeDelegate.h
//  STCJSBridge
//
//  Created by HHH on 2017/5/22.
//  Copyright © 2017年 HHH. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

#if (__MAC_OS_X_VERSION_MAX_ALLOWED > __MAC_10_9 || __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_1)
#define supportsWKWebView
#endif

#if defined supportsWKWebView
#import <WebKit/WebKit.h>
#endif

#if defined __IPHONE_OS_VERSION_MAX_ALLOWED
#import <UIKit/UIWebView.h>
#define STC_PLATFORM_IOS
#define STC_WEBVIEW_TYPE UIWebView
#define STC_WEBVIEW_DELEGATE_TYPE NSObject<UIWebViewDelegate>
#define STC_WEBVIEW_DELEGATE_INTERFACE NSObject<UIWebViewDelegate, STCBridgeDelegate>
#endif

static NSString * const kSTCExecuteCommand = @"starcorExt";

typedef NSString* (^STCHandler)(NSString*callbackId,NSString*data);

/**
 OC调用web统一入口
 */
@protocol STCBridgeNativeToWebDelegate <NSObject>

-(void)nativeCallJs:(NSString *)callbackId
               data:(NSString*)data
         handlerName:(NSString*)handlerName;

@end

/**
 网页端统一入口
 */
@protocol STCBridgeWebToNativeDelegate <JSExport>

-(NSString*)_execFunc:(NSString*)handlerName;

@end
