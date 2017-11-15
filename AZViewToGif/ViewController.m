//
//  ViewController.m
//  AZViewToGif
//
//  Created by cocozzhang on 2017/10/26.
//  Copyright © 2017年 cocozzhang. All rights reserved.
//

#import "ViewController.h"

#import "RQShineLabel.h"
#import "AZImageHelper.h"
#import "GifHelper.h"

#define PRINT_COST_TIME 0 //打印耗时

@interface ViewController () <ShineLabelDelegate> {
    NSMutableArray* _gifImages;
    NSMutableArray* _costTimes;
}
@property (strong, nonatomic) RQShineLabel *shineLabel;
@property (strong, nonatomic) NSArray *textArray;
@property (assign, nonatomic) NSUInteger textIndex;
@property (strong, nonatomic) UIImageView *wallpaper1;
@property (strong, nonatomic) UIImageView *wallpaper2;
@property (strong, nonatomic) NSArray *imageArray;
@end

@implementation ViewController

- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super initWithCoder:decoder]) {
        _textArray = @[@"花のような美しい物、まるで空から落とした流星、いいえ、いかにもそうでごじゃる。我々は远い远いところで见るだけて本当に赘沢ことですから。",
                       @"如果我爱上你的笑容\n要怎么收藏 要怎么拥有\n\n如果你快乐不是为我\n会不会放手 其实才是拥有.",
                       @"We all live in the past. We take a minute to know someone, one hour tolike someone, and one day to love someone, but the whole life to forgetsomeone.",
                       @"从前的日色变得慢\n车 马 邮件都慢\n一生只够 爱一个人.\n从前的锁也好看\n钥匙精美有样子\n你锁了\n人家就懂了"
                       ];
        
        _textIndex  = 0;
        
        _imageArray = @[@"ygr",@"rqq2",@"ll",@"fy"];
        _gifImages = [NSMutableArray new];
        _costTimes = [NSMutableArray new];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.wallpaper1 = ({
        UIImageView *imageView =  [[UIImageView alloc] initWithImage:[UIImage imageNamed:_imageArray[0]]];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.frame = self.view.bounds;
        imageView;
    });
    [self.view addSubview:self.wallpaper1];
    
    self.wallpaper2 = ({
        UIImageView *imageView =  [[UIImageView alloc] initWithImage:[UIImage imageNamed:_imageArray[1]]];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.frame = self.view.bounds;
        imageView.alpha = 0;
        imageView;
    });
    [self.view addSubview:self.wallpaper2];
    
    self.shineLabel = ({
        RQShineLabel *label = [[RQShineLabel alloc] initWithFrame:CGRectMake(16, 16, 320 - 32, CGRectGetHeight(self.view.bounds) - 16)];
        label.delegate = self;
        label.numberOfLines = 0;
        label.text = [self.textArray objectAtIndex:self.textIndex];
        label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:24.0];
        label.backgroundColor = [UIColor clearColor];
        [label sizeToFit];
        label.center = CGPointMake(label.center.x, self.view.center.y);
        label.frameInterval = 2;
        label;
    });
    [self.view addSubview:self.shineLabel];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.shineLabel shineWithCompletion:^{
        [[GifHelper getInstance] saveToGIF:_gifImages named:@"shinelabel" delayTime:self.shineLabel.frameInterval * 1/60.f]; //屏幕fps为60hz
//        [AZImageHelper gradientView:self.shineLabel.layer];
//        [self printAverageCostTime];
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    if (self.shineLabel.isVisible) {
        [self.shineLabel fadeOutWithCompletion:^{
            [self changeText];
            [self.shineLabel shineWithCompletion:^{
//                [self printAverageCostTime];
//                [AZImageHelper gradientView:self.shineLabel.layer];
            }];
        }];

        [UIView animateWithDuration:DEFAULT_DURATION+1 delay:DEFAULT_DURATION-1 options:UIViewAnimationOptionCurveLinear animations:^{
            if (self.wallpaper1.alpha > 0.1) {
                self.wallpaper1.alpha = 0;
                self.wallpaper2.alpha = 1;
            } else {
                self.wallpaper1.alpha = 1;
                self.wallpaper2.alpha = 0;
            }
        } completion:^(BOOL finished) {
            UIImage *img = [UIImage imageNamed:_imageArray[(self.textIndex+1) % _imageArray.count]];
            if (self.wallpaper1.alpha == 0) {
                self.wallpaper1.image = img;
            } else {
                self.wallpaper2.image = img;
            }
        }];
    }
}

- (void)changeText
{
    self.shineLabel.text = self.textArray[(++self.textIndex) % self.textArray.count];
    [self.shineLabel sizeToFit];
    self.shineLabel.frame = CGRectMake(16, 16, 320 - 32, self.shineLabel.bounds.size.height);
    self.shineLabel.center = CGPointMake(self.shineLabel.center.x, self.view.center.y);
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)printAverageCostTime {
    CGFloat count = 0.f;
    for (NSNumber *n in _costTimes) {
        count += [n floatValue];
    }
    NSLog(@"cost time average = %f \n\n", count/_costTimes.count);
    [_costTimes removeAllObjects];
}
#pragma mark - ShineLabelDelegate
- (void)onShine:(RQShineLabel*)shineLabel {
#if PRINT_COST_TIME
    NSDate* tmpStartData = [NSDate date];
    double deltaTime1 = [[NSDate date] timeIntervalSinceDate:tmpStartData];
    NSLog(@"cost time begin= %f", deltaTime1);
#endif
//    shineLabel.backgroundColor = [UIColor blackColor];

    UIImage* img = [AZImageHelper captureView:shineLabel];
    [_gifImages addObject:img];
    
//    shineLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0];

#if PRINT_COST_TIME
    double deltaTime2 = [[NSDate date] timeIntervalSinceDate:tmpStartData];
    NSLog(@"cost time end= %f \n\n", deltaTime2);

    [_costTimes addObject:[NSNumber numberWithFloat:deltaTime2 - deltaTime1]];
#endif
}
@end

