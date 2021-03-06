//
//  UIImageView+Utils.h
//  Common
//
//  Created by 黄磊 on 16/4/6.
//  Copyright © 2016年 Musjoy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (WebImage)


#pragma mark -

/// 设置默认加载图片
+ (void)setPlaceholderImage:(UIImage *)image;

/// 更新唯一标识，用于处理列表中的复用问题
- (void)updateIdentifer;

#pragma mark - Image Name

/// 根据名称设置图片，图片可以是kServerUrl下的网络图片
- (void)setImageWithName:(NSString *)aImageName;

/// 根据名称设置图片，图片可以是kServerUrl下的网络图片，可自定义默认图片
- (void)setImageWithName:(NSString *)aImageName placeholderImage:(UIImage *)placeholderImage;


#pragma mark - Image Url

/** 设置网络图片, 可设置默认显示图片 */
- (void)setImageUrl:(NSString *)imageUrl;

/** 设置网络图片, 可设置默认显示图片 */
- (void)setImageUrl:(NSString *)imageUrl placeholderImage:(UIImage *)placeholderImage;
/** 设置网络图片, 可使用useCacheOnly设置是否需要从网络请求图片，useCacheOnly优先于网络状态判断 */
- (void)setImageUrl:(NSString *)imageUrl
   placeholderImage:(UIImage *)placeholderImage
       useCacheOnly:(BOOL)useCacheOnly;

/** 设置网络图片，可设置网络错误或图片不存在时的默认图片 */
- (void)setImageUrl:(NSString *)imageUrl
   placeholderImage:(UIImage *)placeholderImage
         errorImage:(UIImage *)errorImage
       useCacheOnly:(BOOL)useCacheOnly;


#pragma mark - 以下需要通过网络状态判断是否从网络获取图片

/** 设置网络图片，并根据网络状态判断是否需要从网络加载图片 */
- (void)setImageUrlWithJudge:(NSString *)imageUrl;

/** 设置网络图片，并根据网络状态判断是否需要从网络加载图片 */
- (void)setImageUrlWithJudge:(NSString *)imageUrl placeholderImage:(UIImage *)placeholderImage;
/** 设置网络图片，并根据网络状态判断是否需要从网络加载图片，可使用useCacheOnly设置是否需要从网络请求图片，useCacheOnly优先于网络状态判断 */
- (void)setImageUrlWithJudge:(NSString *)imageUrl
            placeholderImage:(UIImage *)placeholderImage
                useCacheOnly:(BOOL)useCacheOnly;

/** 设置网络图片，并根据网络状态判断是否需要从网络加载图片，可设置网络错误或图片不存在时的默认图片 */
- (void)setImageUrlWithJudge:(NSString *)imageUrl
            placeholderImage:(UIImage *)placeholderImage
                  errorImage:(UIImage *)errorImage
                useCacheOnly:(BOOL)useCacheOnly;


#pragma mark - 

/**
 *	@brief	设置网络图片，以下方法均调用该方法
 *
 *	@param 	imageUrl            设置图片的远程url
 *	@param 	placeholderImage 	设置默认图片, 默认nil
 *	@param 	errorImage          设置错误时的默认图片, 默认placeholderImage
 *	@param 	useCacheOnly        是否仅使用缓存, 默认NO
 *	@param 	needJudge           是否判断是否需要下载图片 YES-需要判断; NO-不需要判断，即本地无缓存时回从网络下载, 默认NO
 *
 */
- (void)setImageUrl:(NSString *)imageUrl
   placeholderImage:(UIImage *)placeholderImage
         errorImage:(UIImage *)errorImage
       useCacheOnly:(BOOL)useCacheOnly
          needJudge:(BOOL)needJudge;


@end
