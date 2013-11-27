//
//  MBFrostedGlassStylePopup.h
//  MBFrostedGlassStylePopup
//
//  Created by akira on 13-11-26.
//  Copyright (c) 2013年 Mibang.Inc. All rights reserved.
//

@class MBFrostedGlassStylePopup;
@protocol MBFrostedGlassStylePopupDelegate <NSObject>
@optional
- (void)popup:(MBFrostedGlassStylePopup *)popup willShowOnScreenAnimated:(BOOL)animatedYesOrNo;
- (void)popup:(MBFrostedGlassStylePopup *)popup didShowOnScreenAnimated:(BOOL)animatedYesOrNo;
- (void)popup:(MBFrostedGlassStylePopup *)popup willDismissFromScreenAnimated:(BOOL)animatedYesOrNo;
- (void)popup:(MBFrostedGlassStylePopup *)popup didDismissFromScreenAnimated:(BOOL)animatedYesOrNo;
- (void)popup:(MBFrostedGlassStylePopup *)popup didTapItemAtIndex:(NSUInteger)index;
- (void)popup:(MBFrostedGlassStylePopup *)popup didEnable:(BOOL)itemEnabled itemAtIndex:(NSUInteger)index;
@end

@interface MBFrostedGlassStylePopup : UIViewController

+ (instancetype)GlassPopup;

/**
 *  高度
 */
@property (nonatomic, assign) CGFloat height;

/**
 *
 */
@property (nonatomic, strong, readonly) UIView *contentView;

/**
 *  The duration of the show and hide animations
 *  Default 0.25
 */
@property (nonatomic, assign) CGFloat animationDuration;

/**
 *  The color to tint the blur effect
 *  Default white: 0.2, alpha: 0.73
 */
@property (nonatomic, strong) UIColor *tintColor;

@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, assign) id <MBFrostedGlassStylePopupDelegate> delegate;


- (void)show;
- (void)showAnimated:(BOOL)animated;
- (void)showInViewController:(UIViewController *)controller animated:(BOOL)animated;

- (void)dismiss;
- (void)dismissAnimated:(BOOL)animated;
- (void)dismissAnimated:(BOOL)animated completion:(void (^)(BOOL finished))completion;


@end
