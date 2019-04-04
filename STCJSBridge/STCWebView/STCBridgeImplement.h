//
//  STCBridgeImplement.h
//  STCJSBridge
//
//  Created by HHH on 2017/5/22.
//  Copyright © 2017年 HHH. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "STCBridgeMessage.h"

@interface STCBridgeImplement : NSObject

+(STCBridgeMessage*)formatWebFucntionData:(NSString*)handler message:(NSString*)message;

@end
