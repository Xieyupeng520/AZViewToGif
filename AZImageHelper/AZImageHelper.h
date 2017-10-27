//
//  AZImageHelper.h
//  AZViewToGif
//
//  Created by azz on 2017/10/26.
//  Copyright © 2017年 azz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AZImageHelper : NSObject
+ (AZImageHelper*)getInstance;
//截取特定UIView的截屏
+ (UIImage*)captureView:(UIView*)theView;
@end
