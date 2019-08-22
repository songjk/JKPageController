//
//  JKBackController.h
//
//
//  Created by songjk on 2019/4/15.
//  Copyright © 2019 sjk. All rights reserved.
// 使用的时候 请继承这个控制器 子控制器需实现协议JKBackControllerSubDelegate

#import <UIKit/UIKit.h>


@class JKMenuView;
@class JKBackController;

@protocol JKBackControllerDelegate <NSObject>
-(BOOL)JKBackControllerShouldShownavigationController;
-(JKMenuView*)JKBackControllerMenueView; // 菜单视图 请在该方法中设置菜单视图的父控件
-(UIView *)JKBackControllerHeadView; // 头部视图 会默认添加到顶部
-(void)JKBackController:(JKBackController*)vc didScrollFromIndex:(NSInteger)ondIndex toIndex:(NSInteger)newIndex; // 做鱼切换页面调用
-(void)JKBackController:(JKBackController*)vc headerScrollProgress:(CGFloat)progress; // 上下拖动调用
@end

// 用户内部子控制器，返回scrollview
@protocol JKBackControllerSubDelegate <NSObject>
@required
-(UIScrollView*)JKBackControllerScrollView;
@end


NS_ASSUME_NONNULL_BEGIN

@interface JKBackController : UIViewController

@property(nonatomic, strong) UIView *headView; // 头部视图
@property(nonatomic, strong) JKMenuView *menuView; // 菜单视图
@property(nonatomic, strong) UIScrollView * backview; // 底部视图
-(void)addSubController:(UIViewController<JKBackControllerSubDelegate>*)vc; // 添加子视图
-(void)removeSubController:(UIViewController*)vc; // 移除子视图
-(void)updateView; //更新界面
-(void)setCurrentViewByIndex:(int)index;
@end

NS_ASSUME_NONNULL_END
