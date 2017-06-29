//
//  UIImage+UIImageEx.m
//  9158Live
//
//  Created by zhongqing on 16/4/11.
//  Copyright © 2016年 tiange. All rights reserved.
//

#import "UIImage+UIImageEx.h"
#import <OpenGLES/ES1/glext.h>
@implementation UIImage (UIImageEx)

+(UIImage*) createImageWithColor:(UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

+(UIImage*)screenView:(UIView *)view{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+(UIImage *)cutScreen:(UIView *)view
{
    int width = [view bounds].size.width;
    int height = [view bounds].size.height;
    
    NSInteger myDataLength = width * height * 4;
    
    // allocate array and read pixels into it.
    GLubyte *buffer = (GLubyte *) malloc(myDataLength);
    
    glReadPixels(0, 0, width, height, GL_RGBA, GL_UNSIGNED_BYTE, buffer);
    glPixelStorei(GL_PACK_ALIGNMENT, 1);
    // gl renders "upside down" so swap top to bottom into new array.
    // there's gotta be a better way, but this works.
    GLubyte *buffer2 = (GLubyte *) malloc(myDataLength);
    for(int y = 0; y <height; y++)
    {
        
        for(int x = 0; x <width * 4; x++)
        {
            buffer2[(height -1 - y) * width * 4 + x] = buffer[y * 4 * width + x];
        }
    }
    free(buffer);
    
    // make data provider with data.
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, buffer2, myDataLength, NULL);
    
    // prep the ingredients
    int bitsPerComponent = 8;
    int bitsPerPixel = 32;
    int bytesPerRow = 4 * width;
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
    
    // make the cgimage
    CGImageRef imageRef = CGImageCreate(width, height, bitsPerComponent, bitsPerPixel, bytesPerRow, colorSpaceRef, bitmapInfo, provider, NULL, NO, renderingIntent);
    
    // then make the uiimage from that
    UIImage *myImage =  [UIImage imageWithCGImage:imageRef];
    
    CGImageRelease(imageRef);
    CGColorSpaceRelease(colorSpaceRef);
    CGDataProviderRelease(provider);
    
    return myImage;
    
}

- (UIImage *)cutCircleImage {
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0);
    // 获取上下文
    CGContextRef ctr = UIGraphicsGetCurrentContext();
    // 设置圆形
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextAddEllipseInRect(ctr, rect);
    // 裁剪
    CGContextClip(ctr);
    // 将图片画上去
    //    CGContextSetRGBStrokeColor(ctr,255,0,0,1);//画笔线的颜色
    //    CGContextSetLineWidth(ctr, 2);//线的宽度
    //    CGContextAddArc(ctr, self.size.width/2, self.size.height/2,self.size.width/2 , 0, M_PI*2, 0);
    //    CGContextDrawPath(ctr, kCGPathStroke);//绘制路径
    [self drawInRect:rect];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)addImage:(UIImage *)image1 toImage:(UIImage *)image2 {
    CGSize size = [UIScreen mainScreen].bounds.size;
    UIGraphicsBeginImageContext(size);
    [image1 drawInRect:CGRectMake(0, 0, size.width, size.height)];
    [image2 drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultingImage;
}

+ (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)theSize {
    if (image == nil)
    {
        return nil;
    }
    CGSize imgSize = image.size;
    if (imgSize.height == 0 || imgSize.width == 0 || theSize.width == 0 || theSize.height == 0)
    {
        return nil;
    }
    CGFloat nx = 0.0f;
    CGFloat ny = 0.0f;
    CGFloat nw = 0.0f;
    CGFloat nh = 0.0f;
    UIImage *autoImg = image;
    if (imgSize.width/imgSize.height >= theSize.width/theSize.height)
    {
        autoImg = [self changeImageSizeWithOriginalImage:image percent:theSize.height/imgSize.height];
        
        nw = theSize.width;
        nh = autoImg.size.height;
        ny = 0;
        nx = ABS(autoImg.size.width -  theSize.width)/2;
        
    }
    else
    {
        autoImg = [self changeImageSizeWithOriginalImage:image percent:theSize.width/imgSize.width];
        nh = theSize.height;
        nw = autoImg.size.width;
        nx = 0;
        ny = ABS(autoImg.size.height -  theSize.height)/2;
    }
    
    
    CGRect rect = CGRectMake(nx, ny, nw, nh);
    CGImageRef subImageRef = CGImageCreateWithImageInRect(autoImg.CGImage, rect);
    CGRect smallBounds = CGRectMake(0, 0,theSize.width, theSize.height);
    
    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage* smallImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGImageRelease(subImageRef);
    return smallImage;
    
}

+(UIImage*)changeImageSizeWithOriginalImage:(UIImage*)image percent:(float)percent
{
    // change the image size
    UIImage *changedImage=nil;
    float iwidth=image.size.width*percent;
    float iheight=image.size.height*percent;
    if (image.size.width != iwidth && image.size.height != iheight)
    {
        CGSize itemSize = CGSizeMake(iwidth, iheight);
        UIGraphicsBeginImageContext(itemSize);
        CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
        [image drawInRect:imageRect];
        changedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    else
    {
        changedImage = image;
    }
    
    return changedImage;
}


- (UIImage*)gradientImageWithBounds:(CGRect)bounds andColors:(NSArray*)colors andGradientType:(int)gradientType{
    NSMutableArray *ar = [NSMutableArray array];
    
    for(UIColor *c in colors) {
        [ar addObject:(id)c.CGColor];
    }
    UIGraphicsBeginImageContextWithOptions(bounds.size, YES, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGColorSpaceRef colorSpace = CGColorGetColorSpace([[colors lastObject] CGColor]);
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)ar, NULL);
    CGPoint start;
    CGPoint end;
    
    switch (gradientType) {
        case 0:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(0.0, bounds.size.height);
            break;
        case 1:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(bounds.size.width, 0.0);
            break;
    }
    CGContextDrawLinearGradient(context, gradient, start, end ,kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
    CGColorSpaceRelease(colorSpace);
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)clipCircleImage:(UIImage *)image{
    UIImage *tempImage;
    if (image.size.width != image.size.height){
        //将图片截成正方形
        tempImage = [self clipRectangle:image WRatio:1 HRatio:1];
    }
    else{
        tempImage = image;
    }
    //截取圆形
    return [self clipImage:tempImage];
}

+ (UIImage *)clipRectangle:(UIImage *)image WRatio:(float)WRatio HRatio:(float)HRatio{
    CGSize imageSize = image.size;
    if (imageSize.width == imageSize.height){
        return image;
    }
    CGRect rect;
    //1.得到截取区域
    if ((imageSize.width / imageSize.height) > WRatio/HRatio){
        float scaleWidth = imageSize.height/HRatio*WRatio;
        float leftMargin = (imageSize.width - scaleWidth)*0.5;
        rect = CGRectMake(leftMargin, 0, scaleWidth, imageSize.height);
    }
    else{
        float scaleHeight = imageSize.width/WRatio*HRatio;
        float topMargin = (imageSize.height - scaleHeight )*0.5;
        rect = CGRectMake(0, topMargin, imageSize.width, scaleHeight );
    }
    //2.转换为位图
    CGImageRef imageRef = image.CGImage;
    //3.根据截图范围
    CGImageRef imageRefRect = CGImageCreateWithImageInRect(imageRef, rect);
    //4.得到新图片
    UIImage *tmp = [[UIImage alloc] initWithCGImage:imageRefRect];
    //5.释放位图
    CGImageRelease(imageRefRect);
    return tmp;
}
+ (UIImage *)clipImage:(UIImage *)imgae{
    //开启上下文
    UIGraphicsBeginImageContextWithOptions(imgae.size, NO, 0.0);
    
    //获取路径
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, imgae.size.width, imgae.size.height)];
    
    //裁剪圆形
    [path addClip];
    
    //把图片塞进上下文中
    [imgae drawInRect:CGRectMake(0, 0, imgae.size.width, imgae.size.height)];
    
    //保存新图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //关闭上下文
    UIGraphicsEndImageContext();
    
    //返回图片
    return newImage;
    
}

/** 获取截屏图片 */
+ (UIImage*)takeScreenshot
{
    CGSize imageSize = CGSizeZero;
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsPortrait(orientation))
        imageSize = [UIScreen mainScreen].bounds.size;
    else
        imageSize = CGSizeMake([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (UIWindow *window in [[UIApplication sharedApplication] windows])
    {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, window.center.x, window.center.y);
        CGContextConcatCTM(context, window.transform);
        CGContextTranslateCTM(context, -window.bounds.size.width * window.layer.anchorPoint.x, -window.bounds.size.height * window.layer.anchorPoint.y);
        if (orientation == UIInterfaceOrientationLandscapeLeft)
        {
            CGContextRotateCTM(context, M_PI_2);
            CGContextTranslateCTM(context, 0, -imageSize.width);
        }
        else if (orientation == UIInterfaceOrientationLandscapeRight)
        {
            CGContextRotateCTM(context, -M_PI_2);
            CGContextTranslateCTM(context, -imageSize.height, 0);
        } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
            CGContextRotateCTM(context, M_PI);
            CGContextTranslateCTM(context, -imageSize.width, -imageSize.height);
        }
        if ([window respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)])
        {
            [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
        }
        else
        {
            [window.layer renderInContext:context];
        }
        CGContextRestoreGState(context);
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


+ (UIImage *)addImage:(UIImage *)useImage addMsakImage:(UIImage *)maskImage MaskImageRect:(CGRect)rect
{
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 4.0)
    {
        UIGraphicsBeginImageContextWithOptions(useImage.size ,NO, 0.0);    }
#else
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 4.0)
    {
        UIGraphicsBeginImageContext(useImage.size);
    }
#endif
    [useImage drawInRect:CGRectMake(0, 0, useImage.size.width, useImage.size.height)];
    
    [maskImage drawInRect:rect];
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultingImage;
}

+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size
{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0,0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    //返回新的改变大小后的图片
    return scaledImage;
}

+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    CGColorSpaceRelease(cs);
    UIImage *img = [UIImage imageWithCGImage:scaledImage];
    CGImageRelease(scaledImage);
    
    return img;
}

@end
