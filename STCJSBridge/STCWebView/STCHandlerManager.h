//
//  STCHandlerManager.h
//  STCJSBridge
//
//  Created by Aby.zhou on 2017/5/26.
//  Copyright © 2017年 aby.zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "STCBridgeMessage.h"

#import "STCBridgeDelegate.h"

//用于存储网页调用本地函数的来往函数对

@interface STCHandlerManager : NSObject

+(instancetype)manager;

-(void)addHandler:(NSString*)handlerName handler:(STCHandler)handler;

-(STCHandler)handlerForKey:(NSString*)handlerName;

-(void)remoHandlerForKey:(NSString*)handlerName;
@end
