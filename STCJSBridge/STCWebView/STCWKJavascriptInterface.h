//
//  STCWKJavascriptInterface.h
//  STCJSBridge
//
//  Created by Aby.zhou on 2017/5/24.
//  Copyright © 2017年 aby.zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "STCBridgeMessage.h"
#import "STCBridgeDelegate.h"

@interface STCWKJavascriptInterface : NSObject<STCBridgeNativeToWebDelegate,STCBridgeWebToNativeDelegate>

+(instancetype)bridgeForWebView:(id)webView;

@end
