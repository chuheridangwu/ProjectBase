//
//  UIImage+UIImageEx.h
//  9158Live
//
//  Created by zhongqing on 16/4/11.
//  Copyright © 2016年 tiange. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    gradientTopToBottom = 0,
    gradientLeftToRight
}GradientType;

@interface UIImage (UIImageEx)

+(UIImage*) createImageWithColor:(UIColor*) color;

+(UIImage*)screenView:(UIView *)view;


+(UIImage *)cutScreen:(UIView *)view;

+(UIImage *)addImage:(UIImage *)image1 toImage:(UIImage *)image2;

+ (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize;

+(UIImage*)changeImageSizeWithOriginalImage:(UIImage*)image percent:(float)percent;

- (UIImage*)gradientImageWithBounds:(CGRect)bounds andColors:(NSArray*)colors andGradientType:(int)gradientType;

+ (UIImage *)clipCircleImage:(UIImage *)image;
+ (UIImage *)clipRectangle:(UIImage *)image WRatio:(float)WRatio HRatio:(float)HRatio;
/** 获取截屏图片 */
+ (UIImage *)takeScreenshot;
/** 增加水印图片 */
+ (UIImage *)addImage:(UIImage *)useImage addMsakImage:(UIImage *)maskImage MaskImageRect:(CGRect)rect;
/** 等比压缩图片 */
+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size;

+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size;


@end
