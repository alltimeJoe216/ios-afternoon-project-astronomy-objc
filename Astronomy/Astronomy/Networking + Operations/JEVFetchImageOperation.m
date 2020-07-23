//
//  JEVFetchImageOp.m
//  Astronomy
//
//  Created by Joe Veverka on 7/22/20.
//  Copyright © 2020 Joe Veverka. All rights reserved.
//

#import "JEVFetchImageOperation.h"

@interface JEVFetchImageOperation()

@property NSURLSessionDataTask *fetchImageTask;

@end

@implementation JEVFetchImageOperation

- (instancetype)initWithImageURL:(NSURL *)imageURL {
    self = [super init];
    if (!self) { return nil; }
    
    _imageURL = imageURL;
    
    return self;
}

- (void)main {
    if (self.isCancelled) { return; }
    
    NSURLSessionDataTask *task = [NSURLSession.sharedSession dataTaskWithURL:self.imageURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

        if (error) {
            NSLog(@"Error fetching image: %@", error);
            return;
        }

        if (!data) {
            NSLog(@"Error fetching image: no data");
            return;
        }

        self.imageData = data;
        [self finish];
    }];
    
    [task resume];
}

- (void)cancel {
    [self.fetchImageTask cancel];
    [super cancel];
}

@end
