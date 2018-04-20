//
//  UIWebView+STCJSContext.m
//  STCJSBridge
//
//  Created by Aby.zhou on 2017/5/26.
//  Copyright © 2017年 aby.zhou. All rights reserved.
//

#import "UIWebView+STCJSContext.h"

#import <objc/runtime.h>

static const char kSTCJavaScriptContext[] = "stc_javaScriptContext";

static NSHashTable* g_webViews = nil;

@interface UIWebView (STCJSContextPrivate)
- (void)stc_didCreateJavaScriptContext:(JSContext *)javaScriptContext;
@end

@protocol TSWebFrame <NSObject>
- (id) parentFrame;
@end

@implementation NSObject (STCJSContext)

- (void)webView:(id)unused didCreateJavaScriptContext: (JSContext*) ctx forFrame:(id<TSWebFrame>)frame
{
    NSParameterAssert( [frame respondsToSelector: @selector( parentFrame )] );
    
    // only interested in root-level frames
    if ( [frame respondsToSelector: @selector( parentFrame) ] && [frame parentFrame] != nil )
        return;
    
    void (^notifyDidCreateJavaScriptContext)() = ^{
        
        for ( UIWebView* webView in g_webViews )
        {
            NSString* cookie = [NSString stringWithFormat: @"ts_jscWebView_%lud", (unsigned long)webView.hash ];
            
            [webView stringByEvaluatingJavaScriptFromString: [NSString stringWithFormat: @"var %@ = '%@'", cookie, cookie ] ];
            
            if ( [ctx[cookie].toString isEqualToString: cookie] )
            {
                [webView stc_didCreateJavaScriptContext: ctx];
                return;
            }
        }
    };
    
    if ( [NSThread isMainThread] )
    {
        notifyDidCreateJavaScriptContext();
    }
    else
    {
        dispatch_async( dispatch_get_main_queue(), notifyDidCreateJavaScriptContext );
    }
}

@end


@implementation UIWebView (STCJSContext)

+ (id) allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        g_webViews = [NSHashTable weakObjectsHashTable];
    });
        
    id webView = [super allocWithZone: zone];
    
    [g_webViews addObject: webView];
    
    return webView;
}

- (void)stc_didCreateJavaScriptContext:(JSContext *)javaScriptContext
{
    [self willChangeValueForKey: @"stc_javaScriptContext"];
    
    objc_setAssociatedObject( self, kSTCJavaScriptContext, javaScriptContext, OBJC_ASSOCIATION_RETAIN);
    
    [self didChangeValueForKey: @"stc_javaScriptContext"];
    
    if ( [self.delegate respondsToSelector: @selector(webView:didCreateJavaScriptContext:)] )
    {
        id<STCWebViewDelegate> delegate = ( id<STCWebViewDelegate>)self.delegate;
        [delegate webView: self didCreateJavaScriptContext: javaScriptContext];
    }
}

- (JSContext*) stc_javaScriptContext
{
    JSContext* javaScriptContext = objc_getAssociatedObject( self, kSTCJavaScriptContext );
    
    return javaScriptContext;
}

@end
