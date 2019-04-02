//
//  ViewController.m
//  NSURLConnectionDemo
//
//  Created by chenshuang on 2019/4/1.
//  Copyright © 2019年 wenwen. All rights reserved.
//
//  关于NSURLConnection的使用介绍

#import "ViewController.h"

#define kScreanWidth [UIScreen mainScreen].bounds.size.width
#define kScreanHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<NSURLConnectionDelegate, NSURLConnectionDataDelegate>
// 用来写数据的文件句柄对象
@property (nonatomic, strong) NSFileHandle *writeHandle;
// 文件的总大小
@property (nonatomic, assign) long long totalLength;
// 当前已经写入的文件大小
@property (nonatomic, assign) long long currentLength;
// 连接对象
@property (nonatomic, strong) NSURLConnection *conn;
/** 进度条*/
@property(nonatomic,strong)UIView *progressView;
/** 进度值*/
@property(nonatomic,strong)UILabel *progressLbe;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 同步请求
//    [self sendSynchronousRequest];
    // 异步请求
//    [self sendAsynchronousRequest];
    // delegate
//    [self sendDelegate];
    // mutableURLRequest
//    [self mutableURLRequest];
    
    // drawUI
    [self drawUI];
}

- (void)drawUI {
    // 下载
    UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(100, 100, 200, 40);
    // 按钮的正常状态
    [button setTitle:@"下载" forState:UIControlStateNormal];
    // 设置按钮的背景色
    button.backgroundColor = [UIColor redColor];
    // 设置正常状态下按钮文字的颜色，如果不写其他状态，默认都是用这个文字的颜色
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    // 设置按下状态文字的颜色
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    button.center = CGPointMake(kScreanWidth * 0.5, 100);
    [button addTarget:self action:@selector(tapDownload) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    // 取消
    UIButton* button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button1.frame = CGRectMake(100, 100, 200, 40);
    // 按钮的正常状态
    [button1 setTitle:@"取消" forState:UIControlStateNormal];
    // 设置按钮的背景色
    button1.backgroundColor = [UIColor redColor];
    // 设置正常状态下按钮文字的颜色，如果不写其他状态，默认都是用这个文字的颜色
    [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    // 设置按下状态文字的颜色
    [button1 setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    button1.center = CGPointMake(kScreanWidth * 0.5, 200);
    [button1 addTarget:self action:@selector(tapCancel) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
    
    // 进度条
    UIView *proView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreanWidth * 0.6, 20)];
    proView.backgroundColor = [UIColor grayColor];
    proView.center = CGPointMake(kScreanWidth * 0.5, 300);
    [self.view addSubview:proView];
    
    // 进度条
    UIView *progressView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 20)];
    progressView.backgroundColor = [UIColor greenColor];
    [proView addSubview:progressView];
    self.progressView = progressView;
    
    // 进度值
    self.progressLbe = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    self.progressLbe.textColor = [UIColor blackColor];
    self.progressLbe.font = [UIFont boldSystemFontOfSize:20];
    self.progressLbe.textAlignment = NSTextAlignmentCenter;
    self.progressLbe.center = CGPointMake(kScreanWidth * 0.5, 400);
    self.progressLbe.text = @"0";
    [self.view addSubview:self.progressLbe];
}

#pragma mark - action

// 开始下载
- (void)tapDownload {
    if (self.conn) {    // 如果有正在进行中的,需要停止先
        [self tapCancel];
    }
    // 1.URL
    NSURL *url = [NSURL URLWithString:@"http://dldir1.qq.com/qqfile/QQforMac/QQ_V5.4.0.dmg"];
    
    // 2.请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    // 设置请求头
    NSString *range = [NSString stringWithFormat:@"bytes=%lld-", self.currentLength];
    [request setValue:range forHTTPHeaderField:@"Range"];
    
    // 3.下载(创建完conn对象后，会自动发起一个异步请求)
    self.conn = [NSURLConnection connectionWithRequest:request delegate:self];
}

// 取消下载
- (void)tapCancel {
    [self.conn cancel];
    self.conn = nil;
}

#pragma mark - NSURLConnectionDataDelegate

//开始接收到服务器的响应时调用
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"didReceiveResponse: %lld",response.expectedContentLength);
    
    if (self.currentLength) return; // 如果已经下载过了,就直接跳过
    
    // 文件路径
    NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filepath = [caches stringByAppendingPathComponent:@"videos.zip"];
    
    // 创建一个空的文件 到 沙盒中
    NSFileManager *mgr = [NSFileManager defaultManager];
    [mgr createFileAtPath:filepath contents:nil attributes:nil];
    
    // 创建一个用来写数据的文件句柄
    self.writeHandle = [NSFileHandle fileHandleForWritingAtPath:filepath];
    
    // 获得文件的总大小
    self.totalLength = response.expectedContentLength;
}

// 接收到服务器返回的数据时调用（服务器返回的数据比较大时会调用多次）
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSLog(@"didReceiveData: %lu",(unsigned long)data.length);
    
    // 移动到文件的最后面
    [self.writeHandle seekToEndOfFile];
    
    // 将数据写入沙盒
    [self.writeHandle writeData:data];
    
    // 累计文件的长度
    self.currentLength += data.length;
    
    float progress = (double)self.currentLength/ self.totalLength;
    self.progressLbe.text = [NSString stringWithFormat:@"%.2f",progress];
    CGRect frame = CGRectMake(0, 0, kScreanWidth * 0.6 * progress, 20);
    self.progressView.frame = frame;
}

// 服务器返回的数据完全接收完毕后调用
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"connectionDidFinishLoading");
    
    self.currentLength = 0;
    self.totalLength = 0;
    
    // 关闭文件
    [self.writeHandle closeFile];
    self.writeHandle = nil;
}

// 请求出错时调用（比如请求超时）
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError: %@",error.description);
}

#pragma mark - 发送请求

// 同步请求
- (void)sendSynchronousRequest {
    // 1.请求路径
    NSURL *url = [NSURL URLWithString:@"http://rap2api.taobao.org/app/mock/163155/gaoshilist"];
    // 2.创建请求对象
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // 3.发送同步请求 - 在主线程执行
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSLog(@"length:%lu",(unsigned long)data.length);
}

// 异步请求
- (void)sendAsynchronousRequest {
    // 1.请求路径
    NSURL *url = [NSURL URLWithString:@"http://rap2api.taobao.org/app/mock/163155/gaoshilist"];
    // 2.创建请求对象
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // 3.异步发送请求
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:queue
                           completionHandler:^(NSURLResponse * response, NSData *data, NSError *connectionError) {
        NSLog(@"length:%lu",(unsigned long)data.length);
    }];
}

// 代理
- (void)sendDelegate {
    // 1.请求路径
    NSURL *url = [NSURL URLWithString:@"http://rap2api.taobao.org/app/mock/163155/gaoshilist"];
    // 2.创建请求对象
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // 1.创建connection
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    // 2.创建connection
//    [NSURLConnection connectionWithRequest:request delegate:self];
    
    // 3.创建connection
//    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
//    [connection start];
}

#pragma mark - NSMutableURLRequest

- (void)mutableURLRequest {
    // 1.请求路径
    NSURL *url = [NSURL URLWithString:@"http://rap2api.taobao.org/app/mock/163155/login"];
    // 创建请求u对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    //设置请求超时等待时间（超过这个时间就算超时，请求失败）
    [request setTimeoutInterval:15.0];
    
    //设置请求方法（比如GET和POST）
    [request setHTTPMethod:@"POST"];
    
    //设置请求体
    NSString *bodyStr = @"username=123&pwd=123";
    [request setHTTPBody:[bodyStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    //设置请求头
    [request setValue:@"" forHTTPHeaderField:@""];
    
    // 3.异步发送请求
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[[NSOperationQueue alloc] init]
                           completionHandler:^(NSURLResponse * response, NSData *data, NSError *connectionError) {
                               NSLog(@"length:%lu",(unsigned long)data.length);
                           }];
}

@end
