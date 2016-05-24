//
//  HTMLViewController.m
//  afanti
//
//  Created by 尾巴超大号 on 15/12/16.
//  Copyright © 2015年 尾巴超大号. All rights reserved.
//

#import "HTMLViewController.h"
#import "ViewController.h"
#import "WebViewJavascriptBridge.h"

#define HTML @"http://121.43.104.78:8081/News/NewsPage/"

@interface HTMLViewController ()

@property (nonatomic, readwrite, strong) UIWebView *webView;

@property WebViewJavascriptBridge *bridge;

@end

@implementation HTMLViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithRed:244.0/255.0 green:245.0/255.0 blue:247.0/255.0 alpha:1];
    _webView = [[UIWebView alloc]init];
    _webView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_webView];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_webView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_webView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_webView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_webView)]];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"backfrommenu"];
    if (_bridge) {
        return;
    }
    [WebViewJavascriptBridge enableLogging];
    _bridge = [WebViewJavascriptBridge bridgeForWebView:_webView];
    [_bridge registerHandler:@"testObjcCallback" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"testObjcCallback called: %@", data);
        responseCallback(@"Response from testObjcCallback");
    }];
    [_bridge callHandler:@"testJavascriptHandler" data:@{ @"foo":@"before ready" }];
    
    NSURL *url = [NSURL URLWithString:_urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    id data = @{ @"greetingFromObjC": @"Hi there, JS!" };
    [_bridge callHandler:@"testJavascriptHandler" data:data responseCallback:^(id response) {
        NSLog(@"testJavascriptHandler responded: %@", response);
        NSDictionary *dic = (NSDictionary *)response;
        [self.delegate passBrowseNumber:[NSString stringWithFormat:@"%@",[dic objectForKey:@"readNum"]] indexPath:self.indexPath id:self.ID];
    }];
}



@end
