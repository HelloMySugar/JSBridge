//
//  STCBridge.h
//  STCJSBridge
//
//  Created by HHH on 2017/5/22.
//  Copyright © 2017年 HHH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "STCBridgeDelegate.h"

@interface STCBridge : NSObject

+ (instancetype)bridgeForWebView:(id)webView;

/**
 加载网页内容

 @param URL 网页地址
 */
- (void)loadURL:(NSURL *)URL;
- (void)loadHTMLString:(NSString *)htmlString;


- (void)jsCallNative:(NSString*)handlerName handler:(STCHandler)handler;

- (void)nativeCallJsWithCallbackId:(NSString*)callbackIdx data:(NSString*)data;

- (void)nativeCallJsWithCallbackId:(NSString*)callbackIdx data:(id)data handlerName:(NSString*)handlerName;



@end
