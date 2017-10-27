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

- (void)saveToGIF:(NSArray<UIImage*>*)images;
@end
