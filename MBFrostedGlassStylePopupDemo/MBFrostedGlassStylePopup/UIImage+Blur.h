//
//  UIImage+Blur.h
//
//  Created by akira on 13-11-26.
//  Copyright (c) 2013年 Mibang.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage(blur)
- (UIImage *)applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage;
@end
