//
//  LoadingView_NHT.m
//  LoadingView_NHT
//
//  Created by 刘晨 on 2022/6/2.
//

#import "LoadingView_NHT.h"


@implementation LoadingView_NHT
{
    UIView *bgView;//透明色
}

static LoadingView_NHT * sharedLoading;


+(LoadingView_NHT *)sharedLoading{
    
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        CGFloat width = [[UIScreen mainScreen] bounds].size.width;
        CGFloat height = [[UIScreen mainScreen] bounds].size.height;
        sharedLoading = [[LoadingView_NHT alloc] initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyle)UIActivityIndicatorViewStyleWhiteLarge];
        sharedLoading.frame = [[UIApplication sharedApplication].keyWindow bounds];
        sharedLoading.center = CGPointMake(width/2, height/2);
        sharedLoading.color = [UIColor whiteColor];
        sharedLoading.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:1];
    });
    return sharedLoading;
}
-(void)loadingAnimationStart{
    sharedLoading.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    [[UIApplication sharedApplication].keyWindow addSubview:sharedLoading];
    [UIApplication sharedApplication].keyWindow.userInteractionEnabled = NO;
    [sharedLoading startAnimating];
}
-(void)loadingAnimationStop{
    [sharedLoading removeFromSuperview];
    [sharedLoading stopAnimating];
    [UIApplication sharedApplication].keyWindow.userInteractionEnabled = YES;
    //    dispatch_async(dispatch_get_main_queue(), ^{
    //
    //    });
}
-(void)showViewOnlyWithFlower{
    [[UIApplication sharedApplication].keyWindow addSubview:sharedLoading];
    [UIApplication sharedApplication].keyWindow.userInteractionEnabled = NO;
    [sharedLoading startAnimating];
    sharedLoading.backgroundColor = [UIColor clearColor];
}

@end
