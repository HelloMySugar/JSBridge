//
//  STCWKWebViewBridge.h
//  STCJSBridge
//
//  Created by HHH on 2017/5/22.
//  Copyright © 2017年 HHH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#import "STCBridge.h"


@interface STCWKWebViewBridge : STCBridge

@property (nonatomic, readonly) WKWebView *webView;

@end
