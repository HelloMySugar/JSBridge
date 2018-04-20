//
//  STCBridgeImplement.h
//  STCJSBridge
//
//  Created by Aby.zhou on 2017/5/22.
//  Copyright © 2017年 aby.zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "STCBridgeMessage.h"

@interface STCBridgeImplement : NSObject

+(STCBridgeMessage*)formatWebFucntionData:(NSString*)handler message:(NSString*)message;

@end
