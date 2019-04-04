//
//  STCWKWebViewBridge.m
//  STCJSBridge
//
//  Created by HHH on 2017/5/22.
//  Copyright © 2017年 HHH. All rights reserved.
//

#import "STCWKWebViewBridge.h"

#import "STCWKJavascriptInterface.h"

#import "STCHandlerManager.h"

@interface STCWKWebViewBridge()<WKNavigationDelegate,WKScriptMessageHandler>
{
    WKWebView *_webView;
}
@property(nonatomic, strong) NSMutableDictionary *javascriptInterfaces;

@property(nonatomic, strong) NSMutableDictionary *messageQueues;

@property (nonatomic, strong) id <STCBridgeNativeToWebDelegate,STCBridgeWebToNativeDelegate> nativeCallJs;

@end
@implementation STCWKWebViewBridge

@synthesize webView = _webView;

-(NSMutableDictionary *)javascriptInterfaces
{
    if (!_javascriptInterfaces) {
        _javascriptInterfaces = @{}.mutableCopy;
    }
    return _javascriptInterfaces;
}
-(NSMutableDictionary*)messageQueues
{
    if (!_messageQueues)_messageQueues = @{}.mutableCopy;
    return _messageQueues;
}

+ (instancetype)bridgeForWebView:(id)webView;
{
    STCWKWebViewBridge* bridge = [[self alloc] init];
    [bridge setupWebView:webView];
    return bridge;
}
-(void)setupWebView:(WKWebView*)webView
{
    _webView = webView;
    _webView.navigationDelegate = self;
    
    STCWKJavascriptInterface *interface  = [STCWKJavascriptInterface new];
    
    [self.javascriptInterfaces setValue:interface forKey:kSTCExecuteCommand];

    [self webViewBridgeSetup];

}
- (void)webViewBridgeSetup {
    
    
    /*
        在此处添加对于wk框架的消息回调对象，用于管理userContentController的消息回执
     */
//    
    [_webView.configuration.userContentController addScriptMessageHandler:self name:@"starcorExt.getTokenInfo()"];
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation;
{
    self.nativeCallJs = [STCWKJavascriptInterface bridgeForWebView:_webView];
}

-(void)loadURL:(NSURL *)URL
{
    [_webView loadRequest:[NSURLRequest requestWithURL:URL]];

}
-(void)loadHTMLString:(NSString *)htmlString
{
    [_webView loadHTMLString:htmlString baseURL:nil];
}
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
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    NSLog(@"===%s",__func__);
    if (message) {
        
    }
}
@end
