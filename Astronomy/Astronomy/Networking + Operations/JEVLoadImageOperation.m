//
//  JEVLoadImageOp.m
//  Astronomy
//
//  Created by Joe Veverka on 7/22/20.
//  Copyright © 2020 Joe Veverka. All rights reserved.
//

#import "JEVLoadImageOperation.h"
#import "JEVFetchImageOp.h"

@interface JEVLoadImageOperation ()

@property (class, nonatomic, readonly) NSOperationQueue *loadImageQueue;
@property (class, nonatomic, readonly) NSCache *imageCache;

@property (nonatomic, readonly) NSBlockOperation *cacheImageOp;
@property (nonatomic, readonly) NSBlockOperation *updateImageOp;
@property (nonatomic, readonly) JEVFetchImageOp *fetchImageOp;

@end

@implementation JEVLoadImageOperation

static NSOperationQueue *_loadImageQueue;
static NSCache *_imageChache;

@synthesize updateImageOp = _updateImageViewOperation;
@synthesize cacheImageOp = _cacheImageOperation;
@synthesize fetchImageOp = _fetchImageOperation;


// MARK: -Inits

- (instancetype)initWithURL:(NSURL *)url
                  imageView:(UIImageView *)imageView {
    self = [super init];
    if (!self) { return nil; }
    
    _url = url;
    _imageView = imageView;
    [JEVLoadImageOperation.loadImageQueue addOperation:self];
    
    return self;
}

+ (NSOperationQueue *)loadImageQueue {
    if (!_loadImageQueue)
    {
        _loadImageQueue = [[NSOperationQueue alloc] init];
    }
    return _loadImageQueue;
}

+ (NSCache *)imageCache {
    if (!_imageChache)
    {
        _imageChache = [[NSCache alloc] init];
    }
    return _imageChache;
}

- (instancetype)initWithURL:(NSURL *)url
                  imageView:(UIImageView *)imageView {
    self = [super init];
    if (!self) { return nil; }
    
    _url = url;
    _imageView = imageView;
    [JEVLoadImageOperation.loadImageQueue addOperation:self];
    
    return self;
}

- (JEVFetchImageOp *)fetchImageOp {
    if (!_fetchImageOperation) {
        _fetchImageOp = [[JEVFetchImageOp alloc] initWithImageURL:self.url];
    }
    
    return _fetchImageOp;
}

- (NSBlockOperation *)cacheImageOp {
    if (!_cacheImageOp) {
        _cacheImageOp = [NSBlockOperation blockOperationWithBlock:^{
            if (self.isCancelled) { return; }
            
            NSData *imageData = self.fetchImageOp.imageData;
            if (imageData) {
                [JEVLoadImageOp.imageCache setObject:imageData forKey:self.url.absoluteString cost:imageData.length];
            }
        }];
    }
    
    return _cacheImageOperation;
}

- (NSBlockOperation *)updateImageViewOperation {
    if (!_updateImageViewOperation) {
        _updateImageViewOperation = [NSBlockOperation blockOperationWithBlock:^{
            if (self.isCancelled) { return; }
            
            NSData *imageData = self.fetchImageOp.imageData;
            self.imageView.image = [UIImage imageWithData:imageData];
        }];
    }
    
    return _updateImageViewOperation;
}

// MARK: - Lifecycle Methods

- (void)main {
    
    // Check for cached image
    NSData *imageData = [JEVLoadImageOperation.imageCache objectForKey:self.url.absoluteString];
    
    if (imageData) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image = [UIImage imageWithData:imageData];
            [self finish];
            return;
        });
    }
    
    [self.updateImageOp addDependency:self.fetchImageOp];
    [self.cacheImageOp addDependency:self.fetchImageOp];
    [NSOperationQueue.currentQueue addOperations:@[self.fetchImageOp, self.cacheImageOp] waitUntilFinished:NO];
    [NSOperationQueue.mainQueue addOperations:@[self.updateImageViewOperation] waitUntilFinished:YES];
    [self finish];
}

- (void)cancel {
    [self.fetchImageOp cancel];
}

@end






