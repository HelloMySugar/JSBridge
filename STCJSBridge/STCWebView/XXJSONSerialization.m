//
//  XXJSONSerialization.m
//  LogCatch
//
//  Created by HHH on 15/4/14.
//  Copyright (c) 2015年 HHH. All rights reserved.
//

#import "XXJSONSerialization.h"
@interface XXJSONSerialization(Private)
// 如果你系统里面有JSONKit的话使用
- (id) objectWithData:(NSData *)data;

// JSONKit 格式化函数
- (NSString *) JSONString;
- (id) decoder;

//SBJsonWriter库的函数
- (NSString *) stringWithObject:(id)object;
@end
@implementation XXJSONSerialization
+ (NSString *) JSONStringFromObject:(id)object error:(NSError **)error {
    
    NSAssert(([object isKindOfClass:[NSDictionary class]] || object == nil),@"请传入NSDictionary类型");
    
    Class     serializer;
    NSString *jsonString;
    
    
    jsonString = nil;
    
    //优先使用系统框架
    serializer = NSClassFromString(@"NSJSONSerialization");
    if (serializer) {
        NSData *data;
        
        data = [serializer dataWithJSONObject:object options:0 error:error];
        
        jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        return jsonString;
    }
    // 如果你的项目里面有SBJsonW库
    serializer = NSClassFromString(@"SBJsonWriter");
    if (serializer) {
        id writer;
        
        writer = [[serializer alloc] init];
        jsonString = [writer stringWithObject:object];
        
        return jsonString;
    }

    // 如果你的项目里面有JSONKit库
    if ([object respondsToSelector:@selector(JSONString)]) {
        return [object JSONString];
    }
    
    // 如果解析错误，抛出异常。
    [NSException raise:@"JSONSerializationException" format:@"格式化错误"];
    
    return nil;
}
@end
