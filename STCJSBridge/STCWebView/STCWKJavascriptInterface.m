//
//  STCWKJavascriptInterface.m
//  STCJSBridge
//
//  Created by HHH on 2017/5/24.
//  Copyright © 2017年 HHH. All rights reserved.
//

#import "STCWKJavascriptInterface.h"
#import "STCBridgeImplement.h"

#import <UIKit/UIKit.h>

#import "UIWebView+STCJSContext.h"
#import <JavaScriptCore/JavaScriptCore.h>

#import "STCBridgeImplement.h"

#import "STCHandlerManager.h"

@interface STCWKJavascriptInterface()
{
    //本地webview对网页发送消息的统一入口，这里还需要抽象webview的类型，用于执行evaluateScript到web
    __unsafe_unretained UIWebView *_webView;
}
@end

@implementation STCWKJavascriptInterface
+(instancetype)bridgeForWebView:(id)webView;
{
    STCWKJavascriptInterface *interface  = [[self alloc] init];
    interface->_webView = webView;
    
    return interface;
}

//原生代码执行web函数
-(void)nativeCallJs:(NSString *)callbackId
               data:(NSString*)data
        handlerName:(NSString*)handlerName;
{
    if(callbackId.length <=0 )callbackId = @"";
    if(data.length <= 0) data = @"";
    if(handlerName.length <=0 )handlerName = @"";
    NSString *arg = [NSString stringWithFormat:@"%@,%@,%@",callbackId,data,handlerName];
    
    NSString *javascriptCommand = [NSString
                                   stringWithFormat:@"javascript:starcorExt._invokeCallback('%@');",arg];
    if (![NSThread currentThread].isMainThread) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self->_webView.stc_javaScriptContext evaluateScript:javascriptCommand];
        });
    }
    else
        [self->_webView.stc_javaScriptContext evaluateScript:javascriptCommand];
    
}

//网页回调的基础函数

-(NSString*)_execFunc:(NSString*)handlerName;
{
    if (handlerName) {
        @try {
            NSArray *arg = [JSContext currentArguments];
            if (arg.count >=2) {
                JSValue *value = [arg lastObject];
                STCBridgeMessage *message = [STCBridgeImplement formatWebFucntionData:handlerName message:value.toString];
                if (message) {
                    
                    NSLog(@"web function ====%@",message.methodName);
                    
                    STCHandler handler = [[STCHandlerManager manager] handlerForKey:message.methodName];
                    if (handler) {
                        return handler(message.callbackId,message.data);
                    }
                    return @"";
                }
                else
                {
                        //message object error
                }
                
            }
        } @catch (NSException *exception) {
            
        }
    }
    return @"";
}

@end
