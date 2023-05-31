//
//  LoadingView_NHT.h
//  LoadingView_NHT
//
//  Created by 刘晨 on 2022/6/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LoadingView_NHT : UIActivityIndicatorView


+(LoadingView_NHT *)sharedLoading;

/**
 显示小菊花同时显示灰色背景
 */
-(void)loadingAnimationStart;
/**
 只显示小菊花不显示灰色背景
 */
-(void)showViewOnlyWithFlower;

/**
 停止显示加载动画
 */
-(void)loadingAnimationStop;

@end

NS_ASSUME_NONNULL_END
