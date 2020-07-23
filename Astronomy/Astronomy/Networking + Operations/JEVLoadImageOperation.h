//
//  JEVLoadImageOp.h
//  Astronomy
//
//  Created by Joe Veverka on 7/22/20.
//  Copyright © 2020 Joe Veverka. All rights reserved.
//


#import "JEVConcurrentOperation.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


NS_SWIFT_NAME(LoadImageOperation)
@interface JEVLoadImageOperation : JEVConcurrentOperation

@property (nonatomic) NSURL *url;
@property (nonatomic, weak) UIImageView *imageView;

- (instancetype)initWithURL:(NSURL *)url
                  imageView:(UIImageView *)imageView;

@end

NS_ASSUME_NONNULL_END
