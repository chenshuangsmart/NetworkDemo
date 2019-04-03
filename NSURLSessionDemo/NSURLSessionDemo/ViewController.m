//
//  ViewController.m
//  NSURLSessionDemo
//
//  Created by cs on 2019/4/2.
//  Copyright © 2019 cs. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    [self sessionDataTask];
    // post
//    [self sessionDataTaskPost];
    // download img
    [self sessionDownloadTask];
}

- (void)sessionTask {
}

- (void)sessionDataTask {
    // 1.请求路径
    NSURL *url = [NSURL URLWithString:@"http://rap2api.taobao.org/app/mock/163155/gaoshilist"];
    // 2.创建请求对象
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    // 3.创建 session 对象
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    // 普通任务
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse * response, NSError *error) {
        if (error) {
            NSLog(@"NSURLSessionDataTaskerror:%@",error);
            return;
        }
        
        // 解析数据
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"NSURLSessionDataTaskdic:%@",dic);
        
        //5.解析数据
        NSLog(@"NSURLSessionDataTask:%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
    }];
    
    // 执行 task
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
    request.HTTPBody = [@"" dataUsingEncoding:NSUTF8StringEncoding];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:queue];
    
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
