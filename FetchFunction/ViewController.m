//
//  ViewController.m
//  FetchFunction
//
//  Created by HuangYiFeng on 12/11/13.
//  Copyright (c) 2013 hyf. All rights reserved.
//

#import "ViewController.h"
#import "DownloadManager.h"

@interface ViewController ()

@property(nonatomic, weak)IBOutlet UILabel *fileExistLabel;

- (IBAction)startDownload:(id)sender;

- (void)checkFileExist;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self checkFileExist];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

- (void)checkFileExist
{
    NSError *error = nil;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *documentURL = [fileManager URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:&error];
    NSArray *subContents = [fileManager contentsOfDirectoryAtPath:[documentURL path] error:&error];
    if (0 < [subContents count])
    {
        self.fileExistLabel.text = @"file exist!!";
    }
    else
    {
        self.fileExistLabel.text = @"file NOT exist.";
    }
}

#pragma mark - IBAction

//- (void)startDownload:(id)sender
//{
////    [NSThread sleepForTimeInterval:10];
//    [[DownloadManager sharedManager] startDownload];
//}

@end
