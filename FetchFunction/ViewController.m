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

- (IBAction)startDownload:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction

- (void)startDownload:(id)sender
{
    [NSThread sleepForTimeInterval:10];
    [[DownloadManager sharedManager] startDownload];
}

@end
