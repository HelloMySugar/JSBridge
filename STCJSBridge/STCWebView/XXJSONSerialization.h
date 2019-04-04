//
//  XXJSONSerialization.h
//  LogCatch
//
//  Created by HHH on 15/4/14.
//  Copyright (c) 2015年 HHH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XXJSONSerialization : NSObject
+ (NSString *) JSONStringFromObject:(id)object error:(NSError **)error;
@end
