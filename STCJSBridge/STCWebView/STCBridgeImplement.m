//
//  STCBridgeImplement.m
//  STCJSBridge
//
//  Created by Aby.zhou on 2017/5/22.
//  Copyright © 2017年 aby.zhou. All rights reserved.
//

#import "STCBridgeImplement.h"

#import "XXJSONSerialization.h"

#import <JavaScriptCore/JavaScriptCore.h>

NSString *const kSTCHandlerSendIntent = @"sendIntent";
NSString *const kSTCHandlerSetHandler = @"setHandler";
NSString *const kSTCHandlerSendMessage = @"sendMessage";

NSString *const kSTCHandlerValue = @"value";

@interface STCBridgeImplement()
@end

@implementation STCBridgeImplement
+(STCBridgeMessage*)formatWebFucntionData:(NSString*)handler message:(NSString*)message;
{
    if ([handler isEqualToString:kSTCHandlerSendIntent] ||
        [handler isEqualToString:kSTCHandlerSetHandler] ||
        [handler isEqualToString:kSTCHandlerSendMessage]) {
        
        NSString *function = @"";
        NSString *data = @"";
        NSString *callbackId = @"";
        
        id temp = [NSJSONSerialization JSONObjectWithData:[message dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        if ([temp isKindOfClass:[NSArray class]]) {
            NSDictionary *funcDict = [temp firstObject];
            if (function) {
                function = funcDict[kSTCHandlerValue];
            }
            if (((NSArray*)temp).count >=2) {
                NSDictionary *arg = temp[1];
                if (arg) {
                    data = [XXJSONSerialization JSONStringFromObject:arg error:nil];
                }
            }
            if (((NSArray*)temp).count>=3) {
                NSDictionary *arg = temp[2];
                if (arg) {
                    callbackId = arg[kSTCHandlerValue];
                }
            }
            return [STCBridgeMessage commandFromJSArray:@[callbackId,data,function]];
        }
        else
            return [STCBridgeMessage commandFromJSArray:@[@"",message,handler]];
    }
    else
    {
        return [STCBridgeMessage commandFromJSArray:@[@"",message,handler]];
    }
    return nil;
}
@end
