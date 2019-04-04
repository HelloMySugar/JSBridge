//
//  STCHandlerManager.m
//  STCJSBridge
//
//  Created by HHH on 2017/5/26.
//  Copyright © 2017年 HHH. All rights reserved.
//

#import "STCHandlerManager.h"


typedef NSMutableDictionary<NSString *, id> STCCallbacksDictionary;

@interface STCHandlerManager()
@property (strong, nonatomic, nonnull) STCCallbacksDictionary *handlers;
@property (strong, nonatomic, nullable) dispatch_queue_t barrierQueue;

@end

@implementation STCHandlerManager

+(instancetype)manager;
{
    static STCHandlerManager *__manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __manager = [[self alloc] init];
    });
    return __manager;
}
-(instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}
-(dispatch_queue_t)barrierQueue
{
    if (!_barrierQueue) {
        _barrierQueue = dispatch_queue_create("com.starcor.js_bridge", DISPATCH_QUEUE_CONCURRENT);
    }
    return _barrierQueue;
}
-(STCCallbacksDictionary*)handlers
{
    if (!_handlers) {
        _handlers =@{}.mutableCopy;
    }
    return _handlers;
}
-(STCHandler)handlerForKey:(NSString*)handlerName;
{
    __block STCHandler h = nil;
    dispatch_sync(self.barrierQueue, ^{
        h = self.handlers[handlerName];
    });
    return h;
}
-(void)addHandler:(NSString*)handlerName handler:(STCHandler)handler;
{
    dispatch_barrier_async(self.barrierQueue, ^{
        self.handlers[handlerName] = handler;
    });
}
-(void)remoHandlerForKey:(NSString*)handlerName
{
    dispatch_barrier_sync(self.barrierQueue, ^{
        [self.handlers removeObjectForKey:handlerName];
    });
}
@end
