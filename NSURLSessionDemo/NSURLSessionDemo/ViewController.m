//
//  ViewController.m
//  NSURLSessionDemo
//
//  Created by cs on 2019/4/2.
//  Copyright © 2019 cs. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<NSURLSessionDelegate, NSURLSessionDataDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    [self sessionDataTask];
    // post
//    [self sessionDataTaskPost];
    // download img
//    [self sessionDownloadTask];
    
    // NSURLSessionDataTask - Get
//    [self sessionDataTaskGet];
    
    // NSURLSessionDataTask - POST
//    [self sessionDataTaskPost];
    
    // NSURLSessionDataTask - NSURLSessionDataDelegate
    [self sessionDataTaskPostDelegate];
}

// 创建 session 对象
- (void)createSession {
    // 1.单例
    NSURLSession *session = [NSURLSession sharedSession];

    // 2.工厂方法 - 不使用代理
    NSURLSession *session1 = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];

    // 3.工厂方法 - 使用代理
    NSURLSession *session2 = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                           delegate:self
                                                      delegateQueue:[NSOperationQueue mainQueue]];
}

- (void)sessionConfiguration {
    NSURLSessionConfiguration *configuration = [[NSURLSessionConfiguration alloc] init];
    NSURLSessionConfiguration *configuration1 = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSessionConfiguration *configuration2 = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@""];
}

- (void)sessionTask {
    NSURLSessionDataTask;
    NSURLSessionDownloadTask;
    NSURLSessionStreamTask;
    NSURLSessionUploadTask;
}

#pragma mark - NSURLSessionDataTask

- (void)sessionDataTaskGet {
    // 1.请求路径
    NSURL *url = [NSURL URLWithString:@"http://rap2api.taobao.org/app/mock/163155/gaoshilist"];
    // 2.创建请求对象
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    // 3.创建 session 对象
    NSURLSession *session = [NSURLSession sharedSession];
    
    // 4.普通任务 - get
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse * response, NSError *error) {
        if (error) {
            NSLog(@"NSURLSessionDataTaskerror:%@",error);
            return;
        }
        
        //5.解析数据
        NSLog(@"NSURLSessionDataTask:%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
    }];
    
    // 启动任务
    [dataTask resume];
}

- (void)sessionDataTaskPost {
    // 1.请求路径
    NSURL *url = [NSURL URLWithString:@"http://rap2api.taobao.org/app/mock/163155/fankui"];
    // 2.创建请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    // 设置 post 请求方式
    request.HTTPMethod = @"POST";
    // 设置请求体
    request.HTTPBody = [@"username=1234&pwd=4321" dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"NSURLSessionDataTaskerror:%@",error);
            return;
        }
        
        //5.解析数据
        NSLog(@"NSURLSessionDataTask:%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
    }];
    
    [dataTask resume];
}

- (void)sessionDataTaskPostDelegate {
    // 1.请求路径
    NSURL *url = [NSURL URLWithString:@"http://rap2api.taobao.org/app/mock/163155/fankui"];
    // 2.创建请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    // 设置 post 请求方式
    request.HTTPMethod = @"POST";
    // 设置请求体
    request.HTTPBody = [@"username=1234&pwd=4321" dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request];
    
    [dataTask resume];
}

#pragma mark - NSURLSessionDataDelegate

// 1.接收到服务器的响应
- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
    NSLog(@"didReceiveResponse");
    // 必须设置对响应进行允许处理才会执行后面两个操作。
    completionHandler(NSURLSessionResponseAllow);
}

// 2.接收到服务器的数据（可能调用多次）
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    NSLog(@"接受到服务器的数据:%lu",data.length);
}

// 3.请求成功或者失败（如果失败，error有值）
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    if (error) {
        NSLog(@"请求失败: %@",error.description);
    } else {
        NSLog(@"请求成功");
    }
}

#pragma mark - NSURLSessionDownloadTask

- (void)sessionDownloadTask {
    // 1.请求路径
    NSURL *url = [NSURL URLWithString:@"http://www.pptbz.com/pptpic/UploadFiles_6909/201203/2012031220134655.jpg"];
    // 2.创建 session 对象
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    // 下载 task
    NSURLSessionDownloadTask *task = [session downloadTaskWithURL:url completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        // 获取沙盒的 caches 路径
        NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"img.jpg"];
        // 生成 url 路径
        NSURL *url = [NSURL fileURLWithPath:path];
        // 将文件保存到指定文件目录下
        [[NSFileManager defaultManager] moveItemAtURL:location toURL:url error:nil];
    }];
    
    [task resume];
}

@end
