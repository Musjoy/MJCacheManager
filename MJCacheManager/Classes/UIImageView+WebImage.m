//
//  UIImageView+Utils.m
//  Common
//
//  Created by 黄磊 on 16/4/6.
//  Copyright © 2016年 Musjoy. All rights reserved.
//

#import "UIImageView+WebImage.h"
#import "MJCacheManager.h"
#import <objc/runtime.h>

static UIImage *s_imgPlaceholder    = nil;

static char kImageIdentiferKey;


@implementation UIImageView (WebImage)

#pragma mark - Runtime

- (void)setIdentifer:(NSString *)identifer {
    objc_setAssociatedObject(self, &kImageIdentiferKey, identifer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)identifer {
    return objc_getAssociatedObject(self, &kImageIdentiferKey);
}


#pragma mark - Public

+ (void)setPlaceholderImage:(UIImage *)image
{
    s_imgPlaceholder = image;
}

- (void)updateIdentifer
{
    NSString *identifer = [[NSUUID UUID] UUIDString];
    [self setIdentifer:identifer];
}


#pragma mark - Image Name

- (void)setImageWithName:(NSString *)aImageName
{
    [self setImageWithName:aImageName placeholderImage:s_imgPlaceholder];
}

- (void)setImageWithName:(NSString *)aImageName placeholderImage:(UIImage *)placeholderImage
{
    UIImage *theImage = [UIImage imageNamed:aImageName];
    if (theImage == nil && [aImageName rangeOfString:@"/"].length > 0) {
        // 只支持存在只是一级目录的图片进行网络下载
        // 网络图片需下载
        if (![aImageName hasPrefix:@"http"]) {
#ifdef kServerUrl
            aImageName = [kServerUrl stringByAppendingString:aImageName];
#else
            return;
#endif
        }
        // 拼接scale
        aImageName = [aImageName stringByAppendingFormat:@"?scale=%d", (int)[[UIScreen mainScreen] scale]];
        [self setImageUrl:aImageName placeholderImage:placeholderImage];
        return;
    }
    [self setIdentifer:nil];
    [self setImage:theImage];
}


#pragma mark - Image Url

- (void)setImageUrl:(NSString *)imageUrl
{
    [self setImageUrl:imageUrl placeholderImage:s_imgPlaceholder];
}

- (void)setImageUrl:(NSString *)imageUrl placeholderImage:(UIImage *)placeholderImage
{
    [self setImageUrl:imageUrl placeholderImage:placeholderImage useCacheOnly:NO];
}

- (void)setImageUrl:(NSString *)imageUrl placeholderImage:(UIImage *)placeholderImage useCacheOnly:(BOOL)useCacheOnly
{
    [self setImageUrl:imageUrl placeholderImage:placeholderImage errorImage:nil useCacheOnly:useCacheOnly];
}

- (void)setImageUrl:(NSString *)imageUrl placeholderImage:(UIImage *)placeholderImage errorImage:(UIImage *)errorImage useCacheOnly:(BOOL)useCacheOnly
{
    [self setImageUrl:imageUrl placeholderImage:placeholderImage errorImage:errorImage useCacheOnly:useCacheOnly needJudge:NO];
}

#pragma mark -

- (void)setImageUrlWithJudge:(NSString *)imageUrl
{
    [self setImageUrlWithJudge:imageUrl placeholderImage:s_imgPlaceholder];
}

- (void)setImageUrlWithJudge:(NSString *)imageUrl placeholderImage:(UIImage *)placeholderImage
{
    [self setImageUrlWithJudge:imageUrl placeholderImage:placeholderImage useCacheOnly:NO];
}

- (void)setImageUrlWithJudge:(NSString *)imageUrl placeholderImage:(UIImage *)placeholderImage useCacheOnly:(BOOL)useCacheOnly
{
    [self setImageUrlWithJudge:imageUrl placeholderImage:placeholderImage errorImage:nil useCacheOnly:useCacheOnly];
}

- (void)setImageUrlWithJudge:(NSString *)imageUrl placeholderImage:(UIImage *)placeholderImage errorImage:(UIImage *)errorImage useCacheOnly:(BOOL)useCacheOnly
{
    [self setImageUrl:imageUrl placeholderImage:placeholderImage errorImage:errorImage useCacheOnly:useCacheOnly needJudge:YES];
}

#pragma mark -

- (void)setImageUrl:(NSString *)imageUrl
   placeholderImage:(UIImage *)placeholderImage
         errorImage:(UIImage *)errorImage
       useCacheOnly:(BOOL)useCacheOnly
          needJudge:(BOOL)needJudge
{
    UseCacheType useCacheType = eUseCacheFirst;
    if (useCacheOnly || (needJudge && ![MJCacheManager canFetchImage])) {
        useCacheType = eUseCacheOnly;
    }
    
    [self setImageUrl:imageUrl placeholderImage:placeholderImage errorImage:errorImage useCache:useCacheType];
}


- (void)setImageUrl:(NSString *)imageUrl
   placeholderImage:(UIImage *)placeholderImage
         errorImage:(UIImage *)errorImage
           useCache:(UseCacheType)useCacheType
{
    if (imageUrl == nil || [imageUrl isEqualToString:@""]) {
        if (![[NSThread currentThread] isMainThread]) {
            LogError(@"在非主线程中");
        } if (errorImage) {
            [self setImage:errorImage];
        } else if (placeholderImage) {
            [self setImage:placeholderImage];
        }
        return;
    }
    
    if (errorImage == nil) {
        errorImage = placeholderImage;
    }
    
    NSString *identifer = [[NSUUID UUID] UUIDString];
    [self setIdentifer:identifer];
    
    BOOL hasCache = [MJCacheManager getFileWithUrl:imageUrl
                                          fileType:eCacheFileImage
                                          useCache:useCacheType
                                        completion:^(BOOL isSucceed, NSString *message, NSObject *data)
                     {
                         if (![identifer isEqualToString:[self identifer]]) {
                             return;
                         }
                         if (isSucceed) {
                             if (data) {
                                 [self setImage:(UIImage *)data];
                             }
                         } else {
                             [self setImage:errorImage];
                         }
                     }];
    
    if (!hasCache) {
        [self setImage:placeholderImage];
    }
}


@end
