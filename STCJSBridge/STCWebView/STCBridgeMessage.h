//
//  STCBridgeMessage.h
//  STCJSBridge
//
//  Created by Aby.zhou on 2017/5/23.
//  Copyright © 2017年 aby.zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STCBridgeMessage : NSObject

@property (nonatomic, readonly, copy) NSString *methodName;
@property (nonatomic, readonly, copy) NSString *callbackId;
@property (nonatomic, readonly, copy) NSString *data;


/**
 <#Description#>

 @param jsArray <#jsArray description#>
 @return <#return value description#>
 */
+ (STCBridgeMessage *)commandFromJSArray:(NSArray *)jsArray;


@end
