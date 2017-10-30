//
//  TSTextShineView.h
//  TextShine
//
//  Created by Genki on 5/7/14.
//  Copyright (c) 2014 Reteq. All rights reserved.
//

#import <UIKit/UIKit.h>

#define DEFAULT_DURATION 2.f

@class RQShineLabel;
@protocol ShineLabelDelegate <NSObject>
/**
 * 每一帧刷新时
 */
- (void)onShine:(RQShineLabel*)shineLabel;
@end

@interface RQShineLabel: UILabel

/**
 *  Fade in text animation duration. Defaults to 2.5.
 */
@property (assign, nonatomic, readwrite) CFTimeInterval shineDuration;

/**
 *  Fade out duration. Defaults to 2.5.
 */
@property (assign, nonatomic, readwrite) CFTimeInterval fadeoutDuration;

/**
 * shine label delegate
 */
@property (nonatomic, strong) id<ShineLabelDelegate> delegate;
/**
 * 每多少帧刷新一次，默认是1，屏幕频率1秒60帧，每帧同步刷新；若改为2，则每2帧刷新一次，即1秒30帧
 */
@property (nonatomic, assign) NSInteger frameInterval;

/**
 *  Auto start the animation. Defaults to NO.
 */
@property (assign, nonatomic, readwrite, getter = isAutoStart) BOOL autoStart;

/**
 *  Check if the animation is finished
 */
@property (assign, nonatomic, readonly, getter = isShining) BOOL shining;

/**
 *  Check if visible
 */
@property (assign, nonatomic, readonly, getter = isVisible) BOOL visible;

/**
 *  Start the animation
 */
- (void)shine;
- (void)shineWithCompletion:(void (^)(void))completion;
- (void)fadeOut;
- (void)fadeOutWithCompletion:(void (^)(void))completion;

@end
