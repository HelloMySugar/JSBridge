//
//  STCWKJavascriptInterface.h
//  STCJSBridge
//
//  Created by HHH on 2017/5/24.
//  Copyright © 2017年 HHH. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "STCBridgeMessage.h"
#import "STCBridgeDelegate.h"

@interface STCWKJavascriptInterface : NSObject<STCBridgeNativeToWebDelegate,STCBridgeWebToNativeDelegate>

+(instancetype)bridgeForWebView:(id)webView;

@end
