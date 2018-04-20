//
//  STCBridgeMessage.m
//  STCJSBridge
//
//  Created by Aby.zhou on 2017/5/23.
//  Copyright © 2017年 aby.zhou. All rights reserved.
//

#import "STCBridgeMessage.h"

@interface STCBridgeMessage()
@property (nonatomic, readwrite, copy) NSString *callbackId;
@property (nonatomic, readwrite, copy) NSString *methodName;
@property (nonatomic, readwrite, copy) NSString *data;
@end

@implementation STCBridgeMessage
+ (STCBridgeMessage *)commandFromJSArray:(NSArray *)jsArray;
{
    
    STCBridgeMessage *command = [[STCBridgeMessage alloc] init];
    command.callbackId = jsArray.count ? jsArray[0]:@"";
    command.data = jsArray.count >=1 ? jsArray[1] : @"";
    command.methodName = jsArray.count >= 2 ? jsArray[2] : @"";
//    command.arguments = jsArray.count >= 2 ? jsArray[2] : @"";
    
    return command;
}
- (NSString *)description{
    NSDictionary *descDic = @{@"callbackId":_callbackId?:@"nil",
                              @"methodName":_methodName?:@"nil",
                              @"arguments":_data?:@"nil"};
    return [NSString stringWithFormat:@"<%@: %p, %@>", [self class], self, descDic];
}
@end
