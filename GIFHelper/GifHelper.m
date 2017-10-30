//
//  GifHelper.m
//
//  Created by azz on 2017/10/18.
//

#import "GifHelper.h"

@implementation GifHelper

+ (GifHelper*)getInstance
{
    static dispatch_once_t pred;
    static GifHelper* instance = nil;
    dispatch_once(&pred, ^{
        instance = [GifHelper new];
    });
    return instance;
}

- (UIImage *)animatedGIFWithData:(NSData *)data
{
    if (!data) {
        return nil;
    }
    
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    
    size_t count = CGImageSourceGetCount(source);
    
    UIImage *animatedImage;
    
    if (count <= 1) {
        animatedImage = [UIImage imageWithData:data];
    }
    else {
        NSMutableArray *images = [NSMutableArray array];
        
        NSTimeInterval duration = 0.0f;
        
        for (size_t i = 0; i < count; i++) {
            CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
            
            duration += [self sd_frameDurationAtIndex:i source:source];
            
            [images addObject:[UIImage imageWithCGImage:image scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp]];
            
            CGImageRelease(image);
        }
        
        if (!duration) {
            duration = (1.0f / 10.0f) * count;
        }
        
        animatedImage = [UIImage animatedImageWithImages:images duration:duration];
    }
    
    CFRelease(source);
    
    return animatedImage;
}

- (float)sd_frameDurationAtIndex:(NSUInteger)index source:(CGImageSourceRef)source {
    float frameDuration = 0.1f;
    CFDictionaryRef cfFrameProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil);
    NSDictionary *frameProperties = (__bridge NSDictionary *)cfFrameProperties;
    NSDictionary *gifProperties = frameProperties[(NSString *)kCGImagePropertyGIFDictionary];
    
    NSNumber *delayTimeUnclampedProp = gifProperties[(NSString *)kCGImagePropertyGIFUnclampedDelayTime];
    if (delayTimeUnclampedProp) {
        frameDuration = [delayTimeUnclampedProp floatValue];
    }
    else {
        
        NSNumber *delayTimeProp = gifProperties[(NSString *)kCGImagePropertyGIFDelayTime];
        if (delayTimeProp) {
            frameDuration = [delayTimeProp floatValue];
        }
    }
    
    // Many annoying ads specify a 0 duration to make an image flash as quickly as possible.
    // We follow Firefox's behavior and use a duration of 100 ms for any frames that specify
    // a duration of <= 10 ms. See <rdar://problem/7689300> and <http://webkit.org/b/36082>
    // for more information.
    
    if (frameDuration < 0.011f) {
        frameDuration = 0.100f;
    }
    
    CFRelease(cfFrameProperties);
    return frameDuration;
}

/**
 * @param images 要保存的序列帧
 * @param gifName 保存为gif的文件命名（* or *.gif）
 * @param delayTime 每两张序列帧之间的间隔，若传入值<=0，则设为和屏幕刷新同频率（60hz），即0.0167
 */
- (void)saveToGIF:(NSArray<UIImage*>*)images named:(NSString*)gifName delayTime:(CGFloat)delayTime{
    //是否循环
    NSUInteger loopCount = 0;
    
    if (delayTime <= 0) {
        delayTime = 0.0167;
    }
    
    //创建图片路径
    if (![gifName hasSuffix:@".gif"]) {
        gifName = [gifName stringByAppendingString:@".gif"];
    }
    NSString *cashPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:gifName];
    
    CGImageDestinationRef destination =CGImageDestinationCreateWithURL((CFURLRef)[NSURL fileURLWithPath:cashPath], kUTTypeGIF, images.count, NULL);
    
    NSDictionary *gifProperties = [NSDictionary dictionaryWithObject:[NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:loopCount] forKey:(NSString *)kCGImagePropertyGIFLoopCount]forKey:(NSString *)kCGImagePropertyGIFDictionary];
    
    
    //https://stackoverflow.com/questions/40310243/gif-image-generated-on-ios10-no-longer-loops-forever-on-browser
    CGImageDestinationSetProperties(destination, (CFDictionaryRef)gifProperties);
    
    for (int i = 0; i < images.count; i++) {
        
        UIImage *image = [images objectAtIndex:i];
        
        NSDictionary *frameProperties = [NSDictionary dictionaryWithObject:[NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:delayTime] forKey:(NSString *)kCGImagePropertyGIFDelayTime] forKey:(NSString *)kCGImagePropertyGIFDictionary];
        
        CGImageDestinationAddImage(destination, image.CGImage, (CFDictionaryRef)frameProperties);
        
    }
    
    
    CGImageDestinationFinalize(destination);
    
    CFRelease(destination);
    
    NSLog(@"animated GIF file created at %@", cashPath);
}
@end
