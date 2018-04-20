//
//  UIWebView+STCJSContext.h
//  STCJSBridge
//
//  Created by Aby.zhou on 2017/5/26.
//  Copyright © 2017年 aby.zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol STCWebViewDelegate <UIWebViewDelegate>

@optional

- (void)webView:(UIWebView *)webView didCreateJavaScriptContext:(JSContext*) ctx;

@end

@interface UIWebView (STCJSContext)

@property (nonatomic, readonly) JSContext* stc_javaScriptContext;


@end
