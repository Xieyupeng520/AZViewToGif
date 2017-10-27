//
//  CaptureHelper.m
//  AZViewToGif
//
//  Created by azz on 2017/10/26.
//  Copyright © 2017年 azz. All rights reserved.
//

#import "AZImageHelper.h"

@implementation AZImageHelper

+ (AZImageHelper*)getInstance
{
    static dispatch_once_t pred;
    static AZImageHelper* instance = nil;
    dispatch_once(&pred, ^{
        instance = [AZImageHelper new];
    });
    return instance;
}

//截取特定UIView的截屏
+ (UIImage*)captureView:(UIView*)theView {
    CGRect rect = theView.frame;
    
    UIGraphicsBeginImageContext(rect.size); //开始
    
    CGContextRef context = UIGraphicsGetCurrentContext(); //当前上下文
    [theView.layer renderInContext:context]; //渲染在当前上下文
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext(); //结束

    return img;
}

//使View有渐变效果，可以从透明渐变到不透明
- (void)gradientView:(UIView*)theView {
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = theView.bounds;
    //设置渐变颜色数组,可以加透明度的渐变
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithWhite:0 alpha:0.0].CGColor,(__bridge id)[UIColor colorWithWhite:0 alpha:1].CGColor];
    //设置渐变区域的起始和终止向量（范围为0-1）
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    //gradientLayer.locations = @[@(0.8f)];//设置渐变位置数组
    //注意：这里不用下边的这句话
    //[gradientView.layer addSublayer:gradientLayer];//将CAGradientlayer对象添加在我们要设置背景色的视图的layer层
    //设置蒙版，用来改变layer的透明度
    [theView.layer setMask:gradientLayer];
}
@end
