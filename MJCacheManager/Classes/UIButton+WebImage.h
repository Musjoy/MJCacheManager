//
//  UIButton+WebImage.h
//  Pods
//
//  Created by 黄磊 on 2017/4/26.
//
//

#import <UIKit/UIKit.h>

@interface UIButton (WebImage)

/// 根据名称设置图片，图片可以是kServerUrl下的网络图片
- (void)setImageWithName:(NSString *)aImageName forState:(UIControlState)state;

/// 根据名称设置图片，图片可以是kServerUrl下的网络图片，可自定义默认图片
- (void)setImageWithName:(NSString *)aImageName forState:(UIControlState)state placeholderImage:(UIImage *)placeholderImage;

/// 设置网络图片, 可设置默认显示图片
- (void)setImageUrl:(NSString *)imageUrl forState:(UIControlState)state;

/// 设置网络图片, 可设置默认显示图片
- (void)setImageUrl:(NSString *)imageUrl forState:(UIControlState)state placeholderImage:(UIImage *)placeholderImage;

#pragma mark - Background Image Url

/// 根据名称设置图片，图片可以是kServerUrl下的网络图片
- (void)setBackgroundImageWithName:(NSString *)aImageName forState:(UIControlState)state;

/// 根据名称设置图片，图片可以是kServerUrl下的网络图片，可自定义默认图片
- (void)setBackgroundImageWithName:(NSString *)aImageName forState:(UIControlState)state placeholderImage:(UIImage *)placeholderImage;

/// 设置网络图片, 可设置默认显示图片
- (void)setBackgroundImageUrl:(NSString *)imageUrl forState:(UIControlState)state;

/// 设置网络图片, 可设置默认显示图片
- (void)setBackgroundImageUrl:(NSString *)imageUrl forState:(UIControlState)state placeholderImage:(UIImage *)placeholderImage;


@end
