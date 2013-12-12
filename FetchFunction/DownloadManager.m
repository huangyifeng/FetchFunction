//
//  DownloadManager.m
//  FetchFunction
//
//  Created by HuangYiFeng on 12/11/13.
//  Copyright (c) 2013 hyf. All rights reserved.
//

#import "DownloadManager.h"
#import "AppConst.h"

@interface DownloadManager ()

@property(nonatomic, strong)NSURLSession *URLSession;

- (void)initURLSession;
- (void)loadHasNewDataFile;
- (void)loadImagePathFile;
- (void)downloadImage:(NSString *)imagePath;

@end

@implementation DownloadManager

#pragma mark - public

+ (DownloadManager *)sharedManager
{
    static DownloadManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DownloadManager alloc] init];
    });
    return sharedInstance;
}

- (void)startDownload
{
    [self initURLSession];
    [self loadHasNewDataFile];
}

#pragma mark - private

- (void)initURLSession
{
    if (!self.URLSession)
    {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.URLSession = [NSURLSession sessionWithConfiguration:config];
    }
}

- (void)loadHasNewDataFile
{
    NSURL *newDataFileURL = [NSURL URLWithString:HAS_NEW_DATA_PATH];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:newDataFileURL];
    NSURLSessionDataTask *dataTask = [self.URLSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error)
        {
            NSLog(@"error: %@",[error localizedDescription]);
            return;
        }
        NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"Done, result is %@", result);
        if ([@"1" isEqualToString:result])
        {
            [self loadImagePathFile];
        }
    }];
    [dataTask resume];
}

- (void)loadImagePathFile
{
    NSURL *imagePathURL = [NSURL URLWithString:IMAGE_PATH_URL];
    NSURLSessionDataTask *dataTask = [self.URLSession dataTaskWithURL:imagePathURL
                                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                        if (error)
                                                        {
                                                            NSLog(@"error: %@", [error localizedDescription]);
                                                            return;
                                                        }
                                                        NSString *imagePath = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                        NSLog(@"Done! Image path is %@", imagePath);
                                                        [self downloadImage:imagePath];
                                                    }];
    [dataTask resume];
}

- (void)downloadImage:(NSString *)imagePath
{
    NSURL *imageURL = [NSURL URLWithString:imagePath];
    NSURLSessionDownloadTask *downloadImageTask = [self.URLSession downloadTaskWithURL:imageURL
                                                                     completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
                                                                         if (error)
                                                                         {
                                                                             NSLog(@"download error: %@", [error localizedDescription]);
                                                                             return;
                                                                         }
                                                                         
                                                                         //save to local document
                                                                         NSFileManager *fileManager = [NSFileManager defaultManager];
                                                                         NSURL *documentURL = [fileManager URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:&error];
                                                                         if (error)
                                                                         {
                                                                             NSLog(@"find folder error: %@", [error localizedDescription]);
                                                                             return;
                                                                         }
                                                                         
                                                                         
                                                                         NSURL *destination = [documentURL URLByAppendingPathComponent:[[response URL] lastPathComponent]];
                                                                         if ([fileManager fileExistsAtPath:[destination absoluteString]])
                                                                         {
                                                                             [fileManager removeItemAtURL:destination error:&error];
                                                                             if (error)
                                                                             {
                                                                                 NSLog(@"remove error: %@", [error localizedDescription]);
                                                                                 return;
                                                                             }
                                                                         }
                                                                         
                                                                         BOOL success = [fileManager copyItemAtURL:location toURL:destination error:&error];
                                                                         if (!success)
                                                                         {
                                                                             NSLog(@"copy error: %@", [error localizedDescription]);
                                                                             return;
                                                                         }
                                                                         NSLog(@"Done. Image File downloaded");
                                                                     }];
    [downloadImageTask resume];
}

@end



