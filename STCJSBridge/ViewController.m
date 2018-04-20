//
//  ViewController.m
//  STCJSBridge
//
//  Created by Aby.zhou on 2017/5/22.
//  Copyright © 2017年 aby.zhou. All rights reserved.
//

#import "ViewController.h"

#import "STCWebViewBridge.h"

#import "STCWKWebViewBridge.h"

@interface ViewController ()
@property (nonatomic, strong) STCWKWebViewBridge *wkBridge;
@property (nonatomic, strong) STCWebViewBridge *webBridge;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    UIWebView *weview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 30, self.view.bounds.size.width,
//                                                                    self.view.bounds.size.height/2.0f)];
//
//    STCWebViewBridge *bridge = [STCWebViewBridge bridgeForWebView:weview];
//
//    self.webBridge = bridge;
//
//    [self.view addSubview:weview];
//
//
//    [self.webBridge jsCallNative:@"getTokenInfo" handler:^NSString *(NSString *callbackId, NSString *data) {
//        return @"哈哈哈哈哈";
//    }];
//    [self.webBridge jsCallNative:@"thirdLogin" handler:^NSString *(NSString *callbackId, NSString *data) {
//
//        [self.webBridge nativeCallJsWithCallbackId:callbackId data:@"login sssssss" handlerName:@"getServerTime"];
//
//        return @"thirdLogin success";
//    }];
    
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.preferences.minimumFontSize = 14;
    
    WKWebView *wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width,
                                                                       self.view.bounds.size.height/2.0f)
                                              configuration:config];
    wkWebView.backgroundColor= [UIColor redColor];
    [self.view addSubview:wkWebView];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"test_demo.html" ofType:nil];
    
    
    
    //https://api.elenw.me/webview_demo/test_demo.html
    
    NSURL *URL = [NSURL fileURLWithPath:path];
    
    _wkBridge = [STCWKWebViewBridge bridgeForWebView:wkWebView];
    [_wkBridge loadURL:URL];
    
//    [self.webBridge loadURL:URL];
}
- (void)btnClick:(UIButton *)sender
{
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
