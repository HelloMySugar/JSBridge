//
//  STCWebViewBridge.m
//  STCJSBridge
//
//  Created by Aby.zhou on 2017/5/22.
//  Copyright © 2017年 aby.zhou. All rights reserved.
//

#import "STCWebViewBridge.h"

#import "STCBridgeMessage.h"
#import "STCBridgeImplement.h"

#import "STCWKJavascriptInterface.h"

#import <JavaScriptCore/JavaScriptCore.h>

#import "UIWebView+STCJSContext.h"

#import "STCHandlerManager.h"

@interface STCWebViewBridge()<UIWebViewDelegate,STCWebViewDelegate>
{
    UIWebView *_webView;
}
@property (nonatomic, strong) id <STCBridgeNativeToWebDelegate,STCBridgeWebToNativeDelegate> nativeCallJs;

@end
@implementation STCWebViewBridge
+ (instancetype)bridgeForWebView:(id)webView;
{
    STCWebViewBridge* bridge = [[self alloc] init];
    [bridge setupWebView:webView];
    return bridge;
}
-(void)setupWebView:(UIWebView*)webView
{
    _webView = webView;
    _webView.delegate = self;
}

- (void)loadURL:(NSURL *)URL{
    NSURLRequest* request = [NSURLRequest requestWithURL:URL];
    [_webView loadRequest:request];
}

- (void)loadHTMLString:(NSString *)htmlString{
    [_webView loadHTMLString:htmlString baseURL:nil];
}
#pragma makr - UIWebView Delegate

- (void)webView:(UIWebView *)webView didCreateJavaScriptContext:(JSContext *)ctx
{
    self.nativeCallJs = [STCWKJavascriptInterface bridgeForWebView:_webView];
        
    ctx[kSTCExecuteCommand] = self.nativeCallJs;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{

}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}
#pragma mark - call web function
- (void)jsCallNative:(NSString*)handlerName handler:(STCHandler)handler;
{
    [[STCHandlerManager manager] addHandler:handlerName handler:handler];
}

- (void)nativeCallJsWithCallbackId:(NSString*)callbackIdx data:(NSString*)data;
{
    
    [self nativeCallJsWithCallbackId:callbackIdx data:data handlerName:nil];
}
- (void)nativeCallJsWithCallbackId:(NSString*)callbackIdx data:(id)data handlerName:(NSString*)handlerName;
{
    if ([self.nativeCallJs respondsToSelector:@selector(nativeCallJs:data:handlerName:)]) {
        [self.nativeCallJs nativeCallJs:callbackIdx data:data handlerName:handlerName];
    }
}
@end
