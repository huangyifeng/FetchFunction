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
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration backgroundSessionConfiguration:BACKGROUND_SESSION_IDENTIFIER];
        self.URLSession = [NSURLSession sessionWithConfiguration:config];
    }
}

- (void)loadHasNewDataFile
{
    NSURL *newDataFileURL = [NSURL URLWithString:HAS_NEW_DATA_PATH];
    NSData *data = [NSData dataWithContentsOfURL:newDataFileURL];
    if (data)
    {
        NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"Done, result is %@", result);
        if ([@"1" isEqualToString:result])
        {
            [self loadImagePathFile];
        }
    }
}

- (void)loadImagePathFile
{
    NSURL *imagePathURL = [NSURL URLWithString:IMAGE_PATH_URL];
    NSData *data = [NSData dataWithContentsOfURL:imagePathURL];
    if (data)
    {
        NSString *imagePath = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"Done! Image path is %@", imagePath);
        [self downloadImage:imagePath];
    }
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

#pragma mark - NSURLSessionDownloadDelegate

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    NSError *error = nil;
    //save to local document
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *documentURL = [fileManager URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:&error];
    if (error)
    {
        NSLog(@"find folder error: %@", [error localizedDescription]);
        return;
    }

    NSURLResponse *response = downloadTask.response;
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
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes
{
    
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    
}


@end



