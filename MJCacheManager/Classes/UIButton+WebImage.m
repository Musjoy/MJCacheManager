//
//  UIButton+WebImage.m
//  Pods
//
//  Created by 黄磊 on 2017/4/26.
//
//

#import "UIButton+WebImage.h"
#import "MJCacheManager.h"
#import <objc/runtime.h>



static char kBtnImageIdentiferKey;

@implementation UIButton (WebImage)

#pragma mark - Runtime

- (void)setIdentifer:(NSString *)identifer {
    objc_setAssociatedObject(self, &kBtnImageIdentiferKey, identifer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)identifer {
    return objc_getAssociatedObject(self, &kBtnImageIdentiferKey);
}


#pragma mark - Public

#pragma mark - Image Name

- (void)setImageWithName:(NSString *)aImageName forState:(UIControlState)state
{
    [self setImageWithName:aImageName forState:state placeholderImage:nil];
}

- (void)setImageWithName:(NSString *)aImageName forState:(UIControlState)state placeholderImage:(UIImage *)placeholderImage
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
        // 拼接scale
        aImageName = [aImageName stringByAppendingFormat:@"?scale=%d", (int)[[UIScreen mainScreen] scale]];
        [self setImageUrl:aImageName forState:state placeholderImage:placeholderImage];
        return;
    }
    [self setIdentifer:nil];
    [self setImage:theImage forState:state];
}


#pragma mark - Image Url

- (void)setImageUrl:(NSString *)imageUrl forState:(UIControlState)state
{
    [self setImageUrl:imageUrl forState:state placeholderImage:nil];
}

- (void)setImageUrl:(NSString *)imageUrl forState:(UIControlState)state placeholderImage:(UIImage *)placeholderImage
{
    [self setImageUrl:imageUrl forState:state placeholderImage:placeholderImage useCacheOnly:NO];
}

- (void)setImageUrl:(NSString *)imageUrl forState:(UIControlState)state placeholderImage:(UIImage *)placeholderImage useCacheOnly:(BOOL)useCacheOnly
{
    [self setImageUrl:imageUrl forState:state placeholderImage:placeholderImage useCache:useCacheOnly?eUseCacheFirst:eUseCacheOnly];
}



#pragma mark -


- (void)setImageUrl:(NSString *)imageUrl
           forState:(UIControlState)state
   placeholderImage:(UIImage *)placeholderImage
           useCache:(UseCacheType)useCacheType
{
    if (imageUrl == nil || [imageUrl isEqualToString:@""]) {
        if (![[NSThread currentThread] isMainThread]) {
            LogError(@"在非主线程中");
        } else if (placeholderImage) {
            [self setImage:placeholderImage forState:state];
        }
        return;
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
                                 [self setImage:(UIImage *)data forState:state];
                             }
                         } else {
                             
                         }
                     }];
    
    if (!hasCache) {
        [self setImage:placeholderImage forState:state];
    }
}


@end
