//
//  STCBridge.m
//  STCJSBridge
//
//  Created by Aby.zhou on 2017/5/22.
//  Copyright © 2017年 aby.zhou. All rights reserved.
//

#import "STCBridge.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface STCBridge()
{
//    STC_WEBVIEW_TYPE* _webView;
}
@end

@implementation STCBridge

+ (instancetype)bridgeForWebView:(id)webView;
{
//    [NSException exceptionWithName:@"bridgeForWebView use error!" reason:@"please override this function" userInfo:nil];
    return nil;
}
-(instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}
- (void)jsCallNative:(NSString*)handlerName handler:(STCHandler)handler;
{
        
    
}
- (void)nativeCallJsWithCallbackId:(NSString*)callbackIdx data:(NSString*)data;
{
    
    
}
- (void)nativeCallJsWithCallbackId:(NSString*)callbackIdx data:(id)data handlerName:(NSString*)handlerName;
{
    
    
}
#pragma mark - WebView load

- (void)loadURL:(NSURL *)URL{
    
}

- (void)loadHTMLString:(NSString *)htmlString{
}
@end
