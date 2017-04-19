//
//  UIImageView+Utils.m
//  Common
//
//  Created by 黄磊 on 16/4/6.
//  Copyright © 2016年 Musjoy. All rights reserved.
//

#import "UIImageView+WebImage.h"
#import "MJCacheManager.h"

static UIImage *s_imgPlaceholder    = nil;


@implementation UIImageView (WebImage)

+ (void)setPlaceholderImage:(UIImage *)image
{
    s_imgPlaceholder = image;
}

- (void)setImageWithName:(NSString *)aImageName
{
    [self setImageWithName:aImageName placeholderImage:s_imgPlaceholder];
}

- (void)setImageWithName:(NSString *)aImageName placeholderImage:(UIImage *)placeholderImage
{
    UIImage *theImage = [UIImage imageNamed:aImageName];
    if (theImage == nil) {
        // 网络图片需下载
        if (![aImageName hasPrefix:@"http"]) {
#ifdef kServerUrl
            if ([aImageName hasPrefix:@"/"]) {
                aImageName = [kServerUrl stringByAppendingString:aImageName];
            } else {
                aImageName = [NSString stringWithFormat:@"%@/%@", kServerUrl, aImageName];
            }
#else
            return;
#endif
        }
        [self setImageUrl:aImageName placeholderImage:placeholderImage];
        return;
    }
    [self setImage:theImage];
}

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
    if (imageUrl == nil || [imageUrl isEqualToString:@""])
    {
        if (![[NSThread currentThread] isMainThread]) {
            LogError(@"在非主线程中");
        }
        if (errorImage) {
            [self setImage:errorImage];
        }else if (placeholderImage)
        {
            [self setImage:placeholderImage];
        }
        return;
    }
    
    if (errorImage == nil) {
        errorImage = placeholderImage;
    }
    
    UseCacheType useCacheType = eUseCacheFirst;
    if (useCacheOnly || (needJudge && ![MJCacheManager canFetchImage])) {
        useCacheType = eUseCacheOnly;
    }
    
    self.tag = self.tag+1;
    NSInteger identifer = self.tag;
    
    BOOL hasCache = [MJCacheManager getFileWithUrl:imageUrl
                                        fileType:eCacheFileImage
                                       useCache:useCacheType
                                      completion:^(BOOL isSucceed, NSString *message, NSObject *data)
                     {
                         if (identifer != self.tag) {
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
- (void)setImageUrlWithJudge:(NSString *)imageUrl placeholderImage:(UIImage *)placeholderImage finish:(FinishBlock)block
{
    UIImage *errorImage = nil;
    BOOL useCacheOnly  = NO;
    BOOL needJudge = YES;
    
    if (imageUrl == nil || [imageUrl isEqualToString:@""])
    {
        if (![[NSThread currentThread] isMainThread]) {
            LogError(@"在非主线程中");
        }
        if (errorImage) {
            [self setImage:errorImage];
        }else if (placeholderImage)
        {
            [self setImage:placeholderImage];
        }
        block();
        return;
    }
    
    if (errorImage == nil) {
        errorImage = placeholderImage;
    }
    
    UseCacheType useCacheType = eUseCacheFirst;
    if (useCacheOnly || (needJudge && ![MJCacheManager canFetchImage])) {
        useCacheType = eUseCacheOnly;
    }
    
    self.tag = self.tag+1;
    NSInteger identifer = self.tag;
    
    BOOL hasCache = [MJCacheManager getFileWithUrl:imageUrl
                                        fileType:eCacheFileImage
                                        useCache:useCacheType
                                      completion:^(BOOL isSucceed, NSString *message, NSObject *data)
                     {
                         if (identifer != self.tag) {
                             return;
                         }
                         if (isSucceed) {
                             if (data) {
                                 [self setImage:(UIImage *)data];
                             }
                             block();
                         } else {
                             [self setImage:errorImage];
                         }
                     }];
    
    if (!hasCache) {
        [self setImage:placeholderImage];
    }
}
- (void)setImageUrl:(NSString *)imageUrl placeholderImage:(UIImage *)placeholderImage finish:(FinishBlock)block
{
    UIImage *errorImage = nil;
    BOOL useCacheOnly = NO;
    BOOL needJudge = YES;
    if (imageUrl == nil || [imageUrl isEqualToString:@""])
    {
        if (![[NSThread currentThread] isMainThread]) {
            LogError(@"在非主线程中");
        }
        if (errorImage) {
            [self setImage:errorImage];
        }else if (placeholderImage)
        {
            [self setImage:placeholderImage];
        }
        block();
        return;
    }
    
    if (errorImage == nil) {
        errorImage = placeholderImage;
    }
    
    UseCacheType useCacheType = eUseCacheFirst;
    if (useCacheOnly || (needJudge && ![MJCacheManager canFetchImage])) {
        useCacheType = eUseCacheOnly;
    }
    
    self.tag = self.tag+1;
    NSInteger identifer = self.tag;
    
    BOOL hasCache = [MJCacheManager getFileWithUrl:imageUrl
                                        fileType:eCacheFileImage
                                        useCache:useCacheType
                                      completion:^(BOOL isSucceed, NSString *message, NSObject *data)
                     {
                         if (identifer != self.tag) {
                             return;
                         }
                         if (isSucceed) {
                             if (data) {
                                 [self setImage:(UIImage *)data];
                                 block();
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
