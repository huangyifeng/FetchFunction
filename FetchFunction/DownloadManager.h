//
//  DownloadManager.h
//  FetchFunction
//
//  Created by HuangYiFeng on 12/11/13.
//  Copyright (c) 2013 hyf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DownloadManager : NSObject

+ (DownloadManager *)sharedManager;

- (void)startDownload;

@end
