//
//  JEVFetchImageOp.h
//  Astronomy
//
//  Created by Joe Veverka on 7/22/20.
//  Copyright © 2020 Joe Veverka. All rights reserved.
//

#import "JEVConcurrentOperation.h"

NS_ASSUME_NONNULL_BEGIN

@interface JEVFetchImageOperation : JEVConcurrentOperation

@property NSURL *imageURL;
@property NSDate *imageData;

@end

NS_ASSUME_NONNULL_END
