//
//  FMJSBridgeMessageHandler.h
//  FMWebViewJavascriptBridge
//
//  Created by 沈强 on 2017/3/10.
//  Copyright © 2017年 沈强. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#import "STCWKWebViewBridge.h"

@interface FMJSBridgeMessageHandler : NSObject<WKScriptMessageHandler>

- (instancetype)initWithWebViewBridge:(STCWKWebViewBridge *)webViewBridge;

@property (nonatomic, copy) STCResponseCallback callback;

@end
