//
//  ViewController.m
//  AFNetworkingDemo
//
//  Created by cs on 2019/4/4.
//  Copyright © 2019 cs. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking.h>

#define kScreanWidth [UIScreen mainScreen].bounds.size.width

@interface ViewController ()
/** imgview */
@property(nonatomic, strong)UIImageView *imgView;
/** uila */
@property(nonatomic, strong)UILabel *progressLbe;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self drawUI];
}

- (void)drawUI {
//    self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
//    self.imgView.center = self.view.center;
//    [self.view addSubview:self.imgView];
    
    // 进度值
    self.progressLbe = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 30)];
    self.progressLbe.textColor = [UIColor blackColor];
    self.progressLbe.font = [UIFont boldSystemFontOfSize:20];
    self.progressLbe.textAlignment = NSTextAlignmentCenter;
    self.progressLbe.center = CGPointMake(kScreanWidth * 0.5, 400);
    self.progressLbe.text = @"当前下载进度:0.00%";
    [self.view addSubview:self.progressLbe];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // 下载图片操作
//    [self downloadImgAndSave];
    
    // 下载一个大文件
    [self downloadBigFile];
}

// 下载图片并且保存
- (void)downloadImgAndSave {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"image/jpeg", nil];
    
    __weak __typeof__(self) weakSelf = self;
    NSString *url = @"http://www.pptbz.com/pptpic/UploadFiles_6909/201203/2012031220134655.jpg";
    
    // 开始下载
    [manager GET:url parameters:nil progress:^(NSProgress *downloadProgress) {
        NSLog(@"progress:%lld",downloadProgress.completedUnitCount);
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"图片下载完成");
        __strong __typeof__(weakSelf) strongSelf = weakSelf;
        strongSelf.imgView.image = [UIImage imageWithData:(NSData *)responseObject];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (error) {
            NSLog(@"%@",error.userInfo);
        }
    }];
}

// 下载一个大文件
- (void)downloadBigFile {
    // 1.创建配置参数
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    // 2.创建会话管理者
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    // 3.创建请求对象
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://dldir1.qq.com/qqfile/QQforMac/QQ_V5.4.0.dmg"]];
    
    // 4.创建下载任务
    /**
     * 第一个参数 - request：请求对象
     * 第二个参数 - progress：下载进度block
     *      其中： downloadProgress.completedUnitCount：已经完成的大小
     *            downloadProgress.totalUnitCount：文件的总大小
     * 第三个参数 - destination：自动完成文件剪切操作
     *      其中： 返回值:该文件应该被剪切到哪里
     *            targetPath：临时路径 tmp NSURL
     *            response：响应头
     * 第四个参数 - completionHandler：下载完成回调
     *      其中： filePath：真实路径 == 第三个参数的返回值
     *            error:错误信息
     */
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress *downloadProgress) {
         __weak typeof(self) weakSelf = self;
        // 获取主线程，不然无法正确显示进度。
        NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
        [mainQueue addOperationWithBlock:^{
            weakSelf.progressLbe.text = [NSString stringWithFormat:@"当前下载进度:%.2f%%",100.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount];
        }];
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        NSURL *path = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [path URLByAppendingPathComponent:response.suggestedFilename];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        NSLog(@"File downloaded to: %@", filePath);
    }];
    
    // 5.开启下载任务
    [downloadTask resume];
}


@end
