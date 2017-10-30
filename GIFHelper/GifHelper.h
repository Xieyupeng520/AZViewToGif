//
//  GifHelper.h
//
//  Created by azz on 2017/10/18.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface GifHelper : NSObject
+ (GifHelper*)getInstance;
/*
 * 得到可以兼容GIF的UIImage。若data为GIF，得到的image实际类型为内部类型_UIAnimatedImage
 */
- (UIImage *)animatedGIFWithData:(NSData *)data;
/**
 * @param images 要保存的序列帧
 * @param gifName 保存为gif的文件命名（* or *.gif）
 * @param delayTime 每两张序列帧之间的间隔，若传入值<=0，则设为和屏幕刷新同频率（60hz），即0.0167
 */
- (void)saveToGIF:(NSArray<UIImage*>*)images named:(NSString*)gifName delayTime:(CGFloat)delayTime;
@end
