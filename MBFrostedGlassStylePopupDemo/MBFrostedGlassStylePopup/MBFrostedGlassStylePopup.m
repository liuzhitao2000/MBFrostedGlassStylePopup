//
//  MBFrostedGlassStylePopup.m
//  MBFrostedGlassStylePopup
//
//  Created by akira on 13-11-26.
//  Copyright (c) 2013年 Mibang.Inc. All rights reserved.
//

#import "MBFrostedGlassStylePopup.h"
#import "UIImage+Blur.h"
#import "UIView+Ext.h"

@interface MBFrostedGlassStylePopup ()
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIImageView *blurView;
@property (nonatomic, strong) UIView *maskView;
@end

static MBFrostedGlassStylePopup *popup;

@implementation MBFrostedGlassStylePopup

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        _contentView = [[UIView alloc] init];
        _contentView.clipsToBounds = YES;
        _animationDuration = 0.3f;
        _tintColor = [UIColor colorWithWhite:1 alpha:0.6];
        _maskView = [[UIView alloc] init];
        _maskView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.height = 300;
    self.height = self.view.height;
    self.view.clipsToBounds = YES;
    self.view.backgroundColor = [UIColor clearColor];
    // Do any additional setup after loading the view.
}
+(instancetype)GlassPopup{
    return popup;
}

- (void)loadView {
    [super loadView];
    [self.view addSubview:self.contentView];
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.view addGestureRecognizer:self.tapGesture];
}
- (void)handleTap:(UITapGestureRecognizer *)recognizer {
    CGPoint location = [recognizer locationInView:self.view];
    if (! CGRectContainsPoint(self.contentView.frame, location)) {
        [self dismissAnimated:YES completion:nil];
    }
}

- (void)addToParentViewController:(UIViewController *)parentViewController callingAppearanceMethods:(BOOL)callAppearanceMethods {
    if (self.parentViewController != nil) {
        [self removeFromParentViewControllerCallingAppearanceMethods:callAppearanceMethods];
    }
    
    if (callAppearanceMethods) [self beginAppearanceTransition:YES animated:NO];
    [parentViewController addChildViewController:self];
    [parentViewController.view addSubview:self.view];
    [self didMoveToParentViewController:self];
    if (callAppearanceMethods) [self endAppearanceTransition];
}

- (void)removeFromParentViewControllerCallingAppearanceMethods:(BOOL)callAppearanceMethods {
    if (callAppearanceMethods) [self beginAppearanceTransition:NO animated:NO];
    [self willMoveToParentViewController:nil];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    if (callAppearanceMethods) [self endAppearanceTransition];
}



- (void)show{}
- (void)showAnimated:(BOOL)animated{

}
- (void)showInViewController:(UIViewController *)controller animated:(BOOL)animated{
    if (popup != nil) {
        [popup dismissAnimated:NO completion:nil];
    }
    
    if ([self.delegate respondsToSelector:@selector(popup:willShowOnScreenAnimated:)]) {
        [self.delegate popup:self willShowOnScreenAnimated:animated];
    }
    
    popup = self;
    
    UIImage *blurImage = [controller.view screenshot];
    blurImage = [blurImage applyBlurWithRadius:40 tintColor:self.tintColor saturationDeltaFactor:1.8 maskImage:nil];
    
    [self addToParentViewController:controller callingAppearanceMethods:YES];
    self.view.frame = controller.view.bounds;

    CGFloat parentHeight = self.view.bounds.size.height;
    CGRect contentFrame = self.view.bounds;
    contentFrame.origin.y = parentHeight;
    contentFrame.size.height = _height;
    self.contentView.frame = contentFrame;
    self.maskView.frame = controller.view.bounds;
    
    CGRect blurFrame = CGRectMake(0,self.view.bounds.size.height, self.view.bounds.size.width, 0);
    
    self.blurView = [[UIImageView alloc] initWithImage:blurImage];
    self.blurView.frame = blurFrame;
    self.blurView.contentMode = UIViewContentModeBottom;
    self.blurView.clipsToBounds = YES;
    [self.view insertSubview:self.maskView belowSubview:self.contentView];
    [self.view insertSubview:self.blurView belowSubview:self.contentView];

    
    contentFrame.origin.y = parentHeight-_height;
    blurFrame.origin.y = contentFrame.origin.y;
    blurFrame.size.height = _height;
    
    void (^animations)() = ^{
        self.contentView.frame = contentFrame;
        self.blurView.frame = blurFrame;
        _maskView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
    };
    void (^completion)(BOOL) = ^(BOOL finished) {
        if (finished && [self.delegate respondsToSelector:@selector(popup:didShowOnScreenAnimated:)]) {
            [self.delegate popup:self didShowOnScreenAnimated:animated];
        }
    };
    
    if (animated) {
        [UIView animateWithDuration:self.animationDuration
                              delay:0
                            options:kNilOptions
                         animations:animations
                         completion:completion];
    }
    else{
        animations();
        completion(YES);
    }
}

- (void)dismiss{
    [self dismissAnimated:YES completion:nil];
}
- (void)dismissAnimated:(BOOL)animated{
    [self dismissAnimated:animated completion:nil];
}
- (void)dismissAnimated:(BOOL)animated completion:(void (^)(BOOL finished))completion{

    void (^completionBlock)(BOOL) = ^(BOOL finished){
        [self removeFromParentViewControllerCallingAppearanceMethods:YES];
        
        if ([self.delegate respondsToSelector:@selector(popup:didDismissFromScreenAnimated:)]) {
            [self.delegate popup:self didDismissFromScreenAnimated:YES];
        }
		if (completion) {
			completion(finished);
		}
    };
    
    if ([self.delegate respondsToSelector:@selector(popup:willDismissFromScreenAnimated:)]) {
        [self.delegate popup:self willDismissFromScreenAnimated:YES];
    }
    
    if (animated) {
        CGFloat parentHeight = self.view.bounds.size.height;
        CGRect contentFrame = self.contentView.frame;
        contentFrame.origin.y = parentHeight;
        
        CGRect blurFrame = self.blurView.frame;
        blurFrame.origin.y = parentHeight;
        blurFrame.size.height = 0;
        
        [UIView animateWithDuration:self.animationDuration
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             self.contentView.frame = contentFrame;
                             self.blurView.frame = blurFrame;
                             self.maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
                         }
                         completion:completionBlock];
    }
    else {
        completionBlock(YES);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
