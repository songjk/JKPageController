//
//  JKMenuView.h
//
//
//  Created by songjk  on 2019/4/16.
//  Copyright © 2019 sjk. All rights reserved.

// 菜单视图

// 使用的时候请使用 +(instancetype)menuWithTitles:(NSArray*)titles andFrme:(CGRect)frame andItemWidth:(CGFloat)itemWidth;
// 

#import <UIKit/UIKit.h>
@class JKMenuView;
@protocol JKMenuViewDelegate <NSObject>

@required
-(void)JKMenuView:(JKMenuView*)view didSelectIndex:(NSInteger)index;

@end


NS_ASSUME_NONNULL_BEGIN

@interface JKMenuView : UIView
@property(nonatomic, assign, readonly) CGFloat allItemLength;
+(instancetype)menuWithTitles:(NSArray*)titles andFrme:(CGRect)frame andItemWidth:(CGFloat)itemWidth;
-(void)setTitleNormalColor:(nullable UIColor *)normalColor selectedColor:(nullable UIColor *)selectedColor lineColor:(nullable UIColor *)lineColor bottomlineColor:(nullable UIColor*)bottomlineColor;
-(void)updateFrameWithFrame:(CGRect)frame;

/**
 设置选择哪一个选项

 */
-(void)setSelectedIndex:(NSInteger)index;

/**
 更新界面 比如网络请求后调用

 */
-(void)updateWithTitles:(NSArray*)titles;

/**
 内容滑动时调用

 */
-(void)setStatusWhenContentScrolling:(CGFloat)progress;
@property(nonatomic, weak) id<JKMenuViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
