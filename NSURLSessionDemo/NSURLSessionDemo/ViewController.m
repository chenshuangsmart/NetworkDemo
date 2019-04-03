//
//  ViewController.m
//  NSURLSessionDemo
//
//  Created by cs on 2019/4/2.
//  Copyright © 2019 cs. All rights reserved.
//

#import "ViewController.h"

#define kScreanWidth [UIScreen mainScreen].bounds.size.width
#define kScreanHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<NSURLSessionDelegate, NSURLSessionDataDelegate, NSURLSessionDownloadDelegate>
/** imgview*/
@property(nonatomic,strong)UIImageView *imgView;
/** 进度条*/
@property(nonatomic,strong)UIView *progressView;
/** 进度值*/
@property(nonatomic,strong)UILabel *progressLbe;
/** downloadtask*/
@property(nonatomic,strong)NSURLSessionDownloadTask *downloadTask;
/** data*/
@property(nonatomic,strong)NSData *resumeData;
/** session*/
@property(nonatomic,strong)NSURLSession *session;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self drawUI];
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
//    [self sessionDataTaskPostDelegate];
    
    // download task
//    [self sessionDownloadTask];
    
    // sessionDownloadTaskDelegate
//    [self sessionDownloadTaskDelegate];
    
    // sessionUploadTask
    [self sessionUploadTask];
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
    
    // 暂停
    UIButton* button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button1.frame = CGRectMake(100, 100, 200, 40);
    // 按钮的正常状态
    [button1 setTitle:@"暂停" forState:UIControlStateNormal];
    // 设置按钮的背景色
    button1.backgroundColor = [UIColor redColor];
    // 设置正常状态下按钮文字的颜色，如果不写其他状态，默认都是用这个文字的颜色
    [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    // 设置按下状态文字的颜色
    [button1 setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    button1.center = CGPointMake(kScreanWidth * 0.5, 180);
    [button1 addTarget:self action:@selector(tapSuspend) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
    
    // 恢复
    UIButton* button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button2.frame = CGRectMake(100, 100, 200, 40);
    // 按钮的正常状态
    [button2 setTitle:@"恢复" forState:UIControlStateNormal];
    // 设置按钮的背景色
    button2.backgroundColor = [UIColor redColor];
    // 设置正常状态下按钮文字的颜色，如果不写其他状态，默认都是用这个文字的颜色
    [button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    // 设置按下状态文字的颜色
    [button2 setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    button2.center = CGPointMake(kScreanWidth * 0.5, 250);
    [button2 addTarget:self action:@selector(tapRecover) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
    
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
    NSURLSession *session = [NSURLSession sharedSession];
    
    // 下载 task
    NSURLSessionDownloadTask *task = [session downloadTaskWithURL:url completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        // 获取沙盒的 caches 路径
        NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:response.suggestedFilename];
        // 生成 url 路径
        NSURL *url = [NSURL fileURLWithPath:path];
        // 将文件保存到指定文件目录下
        [[NSFileManager defaultManager] moveItemAtURL:location toURL:url error:nil];
        NSLog(@"path = %@",path);
        NSLog(@"%@",[NSThread currentThread]);
        //切记当前为子线程，
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imgView.image = [UIImage imageNamed:path];
        });
    }];
    
    [task resume];
}

#pragma mark - sessionDownloadTaskDelegate

- (void)sessionDownloadTaskDelegate {
    // 1.请求路径
//    NSURL *url = [NSURL URLWithString:@"http://www.pptbz.com/pptpic/UploadFiles_6909/201203/2012031220134655.jpg"];
    NSURL *url = [NSURL URLWithString:@"http://dldir1.qq.com/qqfile/QQforMac/QQ_V5.4.0.dmg"];
    // 2.创建带有代理方法的自定义 session
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    // 3.创建任务
    NSURLSessionDownloadTask *task = [session downloadTaskWithURL:url];
    // 4. 开启任务
    [task resume];
}

#pragma mark - NSURLSessionDownloadDelegate

/**
 *  写入临时文件时调用
 *  @param bytesWritten              本次写入大小
 *  @param totalBytesWritten         已写入文件大小
 *  @param totalBytesExpectedToWrite 请求的总文件的大小
 */
- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    //可以监听下载的进度
    CGFloat progress = 1.0 * totalBytesWritten / totalBytesExpectedToWrite;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.progressLbe.text = [NSString stringWithFormat:@"%.2f",progress];
        CGRect frame = CGRectMake(0, 0, kScreanWidth * 0.6 * progress, 20);
        self.progressView.frame = frame;
    });
}

// 下载完成调用
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    // location 还是一个临时路径,需要自己挪到需要的路径（caches 文件夹）
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:downloadTask.response.suggestedFilename];
    [[NSFileManager defaultManager] moveItemAtURL:location toURL:[NSURL fileURLWithPath:filePath] error:nil];
    NSLog(@"downloadTask 移动文件路径");
}

#pragma mark - 断点续传

// 开始下载
- (void)tapDownload {
    // 1.URL
    NSURL *url = [NSURL URLWithString:@"http://dldir1.qq.com/qqfile/QQforMac/QQ_V5.4.0.dmg"];
    if (self.resumeData) {  // 之前已经下载过了
        self.downloadTask = [self.session downloadTaskWithResumeData:self.resumeData];
    } else {
        self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        self.downloadTask = [self.session downloadTaskWithRequest:request];
    }
    
    [self.downloadTask resume];
}

// 取消下载
- (void)tapSuspend {
    if (self.downloadTask) {
        __weak typeof (self)weakSelf = self;
        [self.downloadTask cancelByProducingResumeData:^(NSData *resumeData) {
            NSLog(@"resumeData:%@",resumeData);
            weakSelf.resumeData = resumeData;
            weakSelf.downloadTask = nil;
        }];
    }
}

// 恢复
- (void)tapRecover {
    self.downloadTask = nil;
    self.session = nil;
    self.resumeData = nil;
    self.progressLbe.text = @"0";
    CGRect frame = CGRectMake(0, 0, kScreanWidth * 0.6 * 0, 20);
    self.progressView.frame = frame;
}

#pragma mark - NSURLSessionUploadTask

//- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request;
//
//- (NSURLSessionDataTask *)dataTaskWithURL:(NSURL *)url;
//
//- (NSURLSessionUploadTask *)uploadTaskWithRequest:(NSURLRequest *)request fromFile:(NSURL *)fileURL;
//
//- (NSURLSessionUploadTask *)uploadTaskWithRequest:(NSURLRequest *)request fromData:(NSData *)bodyData;
//
//- (NSURLSessionUploadTask *)uploadTaskWithStreamedRequest:(NSURLRequest *)request;

// 发送请求
- (void)sessionUploadTask {
    NSURL *url = [NSURL URLWithString:@"https://api.weibo.com/2/statuses/public_timeline.json"];
    // 请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    // 设置一些参数
    [request setHTTPMethod:@"POST"];
    //设置请求体
    [request setValue:[NSString stringWithFormat: @"multipart/form-data;%@", @"cs"] forHTTPHeaderField:@"Content-type"];
    //获取上传的图片的data
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"picture" ofType:@"jpg"]];
    //此处添加需要看清楚内容
    NSData *body =  [self httpFormDataBodyWithBoundary:@"cs" params:@{@"access_token":@"2.00cYYKWF6EKpiB3883361b1dJiZ4eD",@"status":@"哈哈，这是我测试NSURLSession上传文件的微博"} fieldName:@"pic" fileName:@"pic.png" fileContentType:@"image/png" data:data];
    // 发送请求
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request fromData:body completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"error = %@",error.description);
        } else {
            NSLog(@"upload  success");
        }
    }];
    [uploadTask resume];
}

#pragma mark-拼接请求体

- (NSData *)httpFormDataBodyWithBoundary:(NSString *)boundary
                                  params:(NSDictionary *)params
                               fieldName:(NSString *)fieldName
                                fileName:(NSString *)fileName
                         fileContentType:(NSString *)fileContentType
                                    data:(NSData *)fileData {
    
    NSString *preBoundary = [NSString stringWithFormat:@"--%@",boundary];
    NSString *endBoundary = [NSString stringWithFormat:@"--%@--",boundary];
    NSMutableString *body = [[NSMutableString alloc] init];
    //遍历
    for (NSString *key in params) {
        //得到当前的key
        //如果key不是当前的pic，说明value是字符类型，比如name：Boris
        //添加分界线，换行，必须使用\r\n
        [body appendFormat:@"%@\r\n",preBoundary];
        //添加字段名称换2行
        [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
        //添加字段值
        [body appendFormat:@"%@\r\n",[params objectForKey:key]];
    }
    //添加分界线，换行
    [body appendFormat:@"%@\r\n",preBoundary];
    //声明pic字段，文件名为boris.png
    [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n",fieldName,fileName];
    //声明上传文件的格式
    [body appendFormat:@"Content-Type: %@\r\n\r\n",fileContentType];
    //声明结束符
    NSString *endStr = [NSString stringWithFormat:@"\r\n%@",endBoundary];
    //声明myRequestData，用来放入http  body
    NSMutableData *myRequestData = [NSMutableData data];
    //将body字符串转化为UTF8格式的二进制
    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    //将image的data加入
    [myRequestData appendData:fileData];
    //加入结束符--hwg--
    [myRequestData appendData:[endStr dataUsingEncoding:NSUTF8StringEncoding]];
    return myRequestData;
}

@end
