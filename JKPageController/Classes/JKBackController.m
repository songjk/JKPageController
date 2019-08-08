
//
//  JKBackController.m
//  
//
//  Created by songjk on 2019/4/15.
//  Copyright © 2019 sjk. All rights reserved.
//

#import "JKBackController.h"
#import "JKMenuView.h"
#import "JKScrollView.h"


#define SCR_W [UIScreen mainScreen].bounds.size.width
#define SCR_H [UIScreen mainScreen].bounds.size.height
#define kPAGE_IS_IPHONE_X  ((SCR_W == 375.f && SCR_H == 812.f) || (SCR_W == 414.f && SCR_H == 896.f))
#define kPAGE_NAVHEIGHT (kPAGE_IS_IPHONE_X ? 88 : 64)
#define kPAGE_TABBARHEIGHT (kPAGE_IS_IPHONE_X ? 83 : 49)
#define kLESS_THAN_iOS11 ([[UIDevice currentDevice].systemVersion floatValue] < 11.0 ? YES : NO)
@interface JKBackController ()<UIScrollViewDelegate,JKMenuViewDelegate>
@property(nonatomic, weak) id<JKBackControllerDelegate> child;
@property(nonatomic, strong) UIScrollView *contentView; // 内容视图
@property(nonatomic, weak) UIScrollView *currentView; // 当前显示的视图

@property(nonatomic, assign) CGFloat bgOffsetY; // 背景view的偏移
@property(nonatomic, assign) CGFloat currentViewOffsetY; // 内容view的偏移
@property(nonatomic, assign) CGFloat headerHeight;// 头部高度
@property(nonatomic, assign) CGFloat menuHeight; // 菜单高度
@property(nonatomic, assign) NSInteger currentIndex; // 当前内容索引
@end

@implementation JKBackController
-(instancetype)init
{
    if (self = [super init]) {
        if ([self conformsToProtocol:@protocol(JKBackControllerDelegate) ]) {
            self.child = (id<JKBackControllerDelegate>)self;
        }
        else
        {
            NSAssert(NO, @"子类必须实现协议JKApimanager");
        }
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBaseUI];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSNumber * value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
}
-(void)dealloc
{
    if (self.menuView) {
        [self.menuView removeFromSuperview];
    }
    if (self.headView) {
        [self.headView removeFromSuperview];
    }
    for (UIViewController *vc in self.childViewControllers) {
        [vc.view removeFromSuperview];
        [vc removeFromParentViewController];
    }
}
-(void)setBaseUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    CGRect backFrame = self.view.bounds;
    
    if (![self isNavigationControllerShows]) {
        backFrame.origin.y += [[UIApplication sharedApplication]statusBarFrame].size.height;
        backFrame.size.height -= backFrame.origin.y;
    }
    if ([self isNavigationControllerShows]) {
        backFrame.size.height -= kPAGE_NAVHEIGHT;
    }
    if (self.tabBarController && self.hidesBottomBarWhenPushed == NO) {
        backFrame.size.height -= kPAGE_TABBARHEIGHT;
    }
    CGFloat backHeight = backFrame.size.height;
    UIScrollView * backview =[[UIScrollView alloc] initWithFrame:backFrame];
    self.backview = backview;
    self.backview.backgroundColor = [UIColor clearColor];
    self.backview.showsVerticalScrollIndicator = false;
    self.backview.showsHorizontalScrollIndicator = false;
    if (@available(iOS 11.0, *)) {
        self.backview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    backview.delegate = self;
    [self.view addSubview:backview];
    
    // 头部view
    self.headView = [[UIView alloc] initWithFrame:CGRectZero];
    [backview addSubview:self.headView];
    if (self.child) {
        [self.headView removeFromSuperview];
        UIView *newHeadView = [self.child JKBackControllerHeadView];
        if (newHeadView) {
            self.headView = newHeadView;
            [backview addSubview:self.headView];
        }
//        if (!self.navigationController) {
//            self.headerHeight -= [[UIApplication sharedApplication]statusBarFrame].size.height;
//        }
    }
    self.headerHeight = self.headView.frame.size.height;
    
    // 菜单视图
    UIView *menuVIew = [[UIView alloc] initWithFrame:CGRectZero];
    [backview addSubview:menuVIew];
    if (self.child) {
        self.menuView = [self.child JKBackControllerMenueView];
        CGRect menuFram = self.menuView.frame;
        menuFram.origin.y = CGRectGetMaxY(self.headView.frame);
        self.menuView.frame = menuFram;
        self.menuHeight = self.menuView.frame.size.height;
        self.menuView.delegate = self;
//        [backview addSubview:self.menuView];
    }
    CGFloat contentViewY = CGRectGetMaxY(self.headView.frame);
    CGFloat contentVieH = backHeight - CGRectGetMaxY(self.headView.frame) + self.headerHeight;
    if ([backview.subviews containsObject:self.menuView]) {
        contentViewY = CGRectGetMaxY(self.menuView.frame);
        contentVieH = backHeight - CGRectGetMaxY(self.menuView.frame) + self.headerHeight;
    }
    self.contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, contentViewY, backFrame.size.width, contentVieH)];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.contentView.delegate = self;
    self.contentView.pagingEnabled = YES;
    self.contentView.showsVerticalScrollIndicator = false;
    self.contentView.showsHorizontalScrollIndicator = false;
    self.contentView.bounces = false;
    if (@available(iOS 11.0, *)) {
        self.contentView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }if (@available(iOS 11.0, *)) {
        self.contentView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    [backview addSubview:self.contentView];
    CGFloat heightMax = CGRectGetMaxY(self.contentView.frame);
    backview.contentSize = CGSizeMake(self.contentView.frame.size.width,heightMax);
}
#pragma mark - public

/**
 更新全部显示
 */
-(void)updateView
{
    if (self.child) {
        [self.headView removeFromSuperview];
        self.headView = [self.child JKBackControllerHeadView];
        [self.backview addSubview:self.headView];
        self.headerHeight = self.headView.frame.size.height;
//        if (!self.navigationController) {
//            self.headerHeight -= [[UIApplication sharedApplication]statusBarFrame].size.height;
//        }
    }
    
    
    if (self.child) {
        JKMenuView * view = [self.child JKBackControllerMenueView];
        if (view != self.menuView) {
            [self.menuView removeFromSuperview];
            self.menuView = view;
            self.menuView.delegate = self;
//            [self.backview addSubview:self.menuView];
        }
        CGRect menuFram = self.menuView.frame;
        menuFram.origin.y = CGRectGetMaxY(self.headView.frame);
        self.menuView.frame = menuFram;
        self.menuHeight = self.menuView.frame.size.height;
        
    }
    
    CGFloat contentViewY = CGRectGetMaxY(self.headView.frame);
    CGFloat contentVieH = contentVieH = self.backview.frame.size.height - CGRectGetMaxY(self.headView.frame) + self.headerHeight;
    if ([self.backview.subviews containsObject:self.menuView]) {
        contentViewY = CGRectGetMaxY(self.menuView.frame);
        contentVieH = self.backview.frame.size.height - CGRectGetMaxY(self.menuView.frame) + self.headerHeight;
    }
    self.contentView.frame = CGRectMake(0, contentViewY, self.backview.frame.size.width, contentVieH);
    
    CGFloat heightMax = CGRectGetMaxY(self.contentView.frame);
    self.backview.contentSize = CGSizeMake(self.contentView.frame.size.width,heightMax);
}
-(void)addSubController:(UIViewController*)vc
{
    CGFloat viewX = self.contentView.subviews.count * SCR_W;
    [self addChildViewController:vc];
    [self.contentView addSubview:vc.view];
    vc.view.frame = CGRectMake(viewX, 0, self.contentView.frame.size.width, self.contentView.frame.size.height);
    
    self.contentView.contentSize = CGSizeMake(self.contentView.frame.size.width*self.childViewControllers.count, self.contentView.frame.size.height);
}
-(void)removeSubController:(UIViewController*)vc
{
    [vc.view removeFromSuperview];
    [vc removeFromParentViewController];
    
    self.contentView.contentSize = CGSizeMake(self.contentView.frame.size.width*self.childViewControllers.count, self.contentView.frame.size.height);
}
#pragma mark - JKMenuViewDelegate
-(void)JKMenuView:(JKMenuView *)view didSelectIndex:(NSInteger)index
{
    if (index != self.currentIndex) {
        [self.contentView scrollRectToVisible:CGRectMake(self.contentView.frame.size.width * index, 0, self.contentView.frame.size.width, self.contentView.frame.size.height) animated:NO];
        NSInteger oldIndex = self.currentIndex;
        self.currentIndex = index;
        
        if (self.child) {
            [self.child JKBackController:self didScrollFromIndex:oldIndex toIndex:index];
        }
    }
}
#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.backview)
    {
        CGFloat bgOffsetY = self.backview.contentOffset.y;
        CGFloat currentOffsetY = self.currentView.contentOffset.y;
        if (bgOffsetY>=self.bgOffsetY) { //上啦内容视图
            if (bgOffsetY<self.headerHeight) { // 没拉到顶部 继续上拉背景视图。不让内容视图拉动
                self.bgOffsetY = bgOffsetY;
            }
            else // 当背景视图拉到最大位置。允许上拉内容视图
            {
                self.bgOffsetY = self.headerHeight;
                self.currentViewOffsetY = currentOffsetY;
            }
        }
        else // 下拉
        {
            if (bgOffsetY <=0 && currentOffsetY>0) { // 如果背景是图下拉到最底部 让内容视图可以继续下拉 不让背景下拉
                self.bgOffsetY = 0;
                self.currentViewOffsetY = currentOffsetY;
            }
            else if(currentOffsetY<=0) // 如果内容是图下拉到最底下 就不让内容视图继续下拉
            {
                self.bgOffsetY = bgOffsetY;
                self.currentViewOffsetY = 0;
            }
            else if(currentOffsetY > 0) // 如果内容视图的位置是被上拉的 继续内容视图可以下拉
            {
                self.currentViewOffsetY = currentOffsetY;
            }
            
            
        }
        self.currentView.contentOffset = CGPointMake(0, self.currentViewOffsetY);
        self.backview.contentOffset = CGPointMake(0, self.bgOffsetY);
        CGFloat progress = self.bgOffsetY / self.headerHeight;
        if (self.child) {
            [self.child JKBackController:self headerScrollProgress:progress];
        }
        
    }
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (scrollView == self.backview)
    {
       
        self.bgOffsetY = self.backview.contentOffset.y;
        self.currentViewOffsetY = self.currentView.contentOffset.y;
        
    }
    else
    {
         self.currentView.scrollEnabled = NO;
    }
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView != self.backview && !decelerate)
    {
        self.currentView.scrollEnabled = YES;
        if (!decelerate) { // 计算显示内容
            [self  calculateIndex];
        }
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView != self.backview) {
        self.currentView.scrollEnabled = YES;
        [self calculateIndex];
    }
}
-(void)calculateIndex
{
    CGFloat offsetX = self.contentView.contentOffset.x;
    NSInteger nowIndex =  (NSInteger)(offsetX/SCR_W + 0.1);
    if (nowIndex != self.currentIndex)
    {
        NSInteger oldIndex = self.currentIndex;
        self.currentIndex = nowIndex;
        [self.menuView setSelectedIndex:self.currentIndex];
        if (self.child) {
            [self.child JKBackController:self didScrollFromIndex:oldIndex toIndex:nowIndex];
        }

    }
}

/**
 是否显示导航栏

 */
-(BOOL)isNavigationControllerShows
{
    if (self.child) {
        return [self.child JKBackControllerShouldShownavigationController];
    }
    return NO;
}
#pragma mark - lazy
-(UIScrollView *)currentView
{
    if (!_currentView) {
        if (self.childViewControllers.count > self.currentIndex) {
            UIViewController<JKBackControllerSubDelegate> *vc = self.childViewControllers[self.currentIndex];
            _currentView = [vc JKBackControllerScrollView];
            self.currentViewOffsetY = _currentView.contentOffset.y;
        }
    }
    return _currentView;
}
-(void)setCurrentIndex:(NSInteger)currentIndex
{
    _currentIndex = currentIndex;
    UIViewController<JKBackControllerSubDelegate> *vc = self.childViewControllers[self.currentIndex];
    _currentView = [vc JKBackControllerScrollView];
    self.currentViewOffsetY = _currentView.contentOffset.y;
}

- (BOOL)shouldAutorotate{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}
@end
