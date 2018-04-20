//
//  XXJSONSerialization.h
//  LogCatch
//
//  Created by 周强 on 15/4/14.
//  Copyright (c) 2015年 周强. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XXJSONSerialization : NSObject
+ (NSString *) JSONStringFromObject:(id)object error:(NSError **)error;
@end
