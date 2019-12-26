//
//  JKMenuView.m
//  
//
//  Created by songjk  on 2019/4/16.
//  Copyright © 2019 sjk. All rights reserved.
//

#import "JKMenuView.h"
#define kLineHeight 3
#define kleftAndRightWidth 5

@interface JKMenuView()<UIScrollViewDelegate>
@property(nonatomic, strong) UIScrollView *backView;
@property(nonatomic, strong) UIView *line;
@property(nonatomic, strong) UIView * bottomLine;
@property(nonatomic, strong) UIColor *normalColor;
@property(nonatomic, strong) UIColor *selectedColor;
@property(nonatomic, strong) UIColor *lineColor;
@property(nonatomic, strong) UIColor *bottomlineColor;

@property(nonatomic, strong) NSArray *titles;
@property(nonatomic, assign) NSInteger selectIndex;
@property(nonatomic, assign) CGFloat itemWidth;
@property(nonatomic, assign) CGFloat leftAndRightWidth;
@property(nonatomic, strong) UIButton *selectBtn;
@property(nonatomic, strong) NSMutableArray *btnArry;
@end
@implementation JKMenuView
+(instancetype)menuWithTitles:(NSArray *)titles andFrme:(CGRect)frame andItemWidth:(CGFloat)itemWidth
{
    JKMenuView * view = [[JKMenuView alloc] initWithFrame:frame];
    view.titles = titles;
    view.itemWidth = itemWidth;
    view.selectIndex = -1;
    [view setUI];
    return view;
}
-(void)setTitleNormalColor:(UIColor *)normalColor selectedColor:(UIColor *)selectedColor lineColor:(UIColor *)lineColor bottomlineColor:(nullable UIColor *)bottomlineColor
{
    self.normalColor = normalColor;
    self.selectedColor = selectedColor;
    self.lineColor = lineColor;
    self.bottomlineColor = bottomlineColor;
    self.line.backgroundColor = self.lineColor;
    self.bottomLine.backgroundColor = [self.bottomlineColor colorWithAlphaComponent:0];
    for (UIButton * btn in self.btnArry) {
        [btn setTitleColor:self.normalColor forState:UIControlStateNormal];
        [btn setTitleColor:self.selectedColor forState:UIControlStateSelected];
    }
}
-(void)updateWithTitles:(NSArray *)titles
{
    self.titles = titles;
    self.selectBtn = nil;
    [self setItems];
    if (self.btnArry.count>0) {
        self.selectIndex = -1;
        [self setSelectedIndex:0];
    }
}
-(void)updateFrameWithFrame:(CGRect)frame
{
    self.frame = frame;
    CGRect lineFrame = self.bottomLine.frame;
    lineFrame.size.width = frame.size.width;
    self.backView.frame = frame;
}
-(void)setStatusWhenContentScrolling:(CGFloat)progress
{
    CGFloat changeProgress = progress * 1.0;
    UIColor *color = self.bottomlineColor?[self.bottomlineColor colorWithAlphaComponent:changeProgress]: [UIColor colorWithRed:1 green:1 blue:1 alpha:changeProgress];
    self.bottomLine.backgroundColor = color;
}
-(void)setSelectedIndex:(NSInteger)index
{
    if (self.selectIndex == index || index > self.titles.count) {
        return;
    }
    self.selectIndex = index;
    UIButton * btu = self.btnArry[index];
    [self clickIndex:btu];
}
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
//        [self setUI];
    }
    return self;
}
-(void)setUI
{
    self.leftAndRightWidth = kleftAndRightWidth;
    self.backView =[[UIScrollView alloc] initWithFrame:self.bounds];
    self.backView.showsVerticalScrollIndicator = false;
    self.backView.showsHorizontalScrollIndicator = false;
    if (@available(iOS 11.0, *)) {
        self.backView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    self.backView.delegate = self;
    self.backView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.backView];
    [self setItems];
    self.line = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - kLineHeight, 40, kLineHeight)];
    self.line.tag = 999;
    [self.backView addSubview:self.line];
    self.line.backgroundColor = self.lineColor?self.lineColor: [UIColor whiteColor];
    
    self.bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-1, self.frame.size.width, 1)];
    self.bottomLine.backgroundColor = self.bottomlineColor?[self.bottomlineColor colorWithAlphaComponent:0]: [UIColor colorWithRed:1 green:1 blue:1 alpha:0];
    [self addSubview:self.bottomLine];
    if (self.btnArry.count>0) {
        [self setSelectedIndex:0];
    }
}

-(void)setItems
{
    CGFloat xBorder = self.leftAndRightWidth;
    CGFloat marginX = xBorder * 2;
    CGFloat btnHeight = 35;
    CGFloat currentWidth = 0;
    CGFloat btnY = self.frame.size.height - btnHeight-kLineHeight;
    for (UIButton * btn in self.btnArry) {
        btn.hidden = YES;
    }
    UIFont * font = [UIFont preferredFontForTextStyle:UIFontTextStyleCallout];
    for (int i=0; i<self.titles.count; i++) {
        NSString * title = [NSString stringWithFormat:@"%@",self.titles[i]] ;
        CGFloat titleWidth = 0;
        if (self.itemWidth > 0) {
            titleWidth = self.itemWidth;
        }
        else
        {
            titleWidth =  [title boundingRectWithSize:CGSizeMake(MAXFLOAT, btnHeight) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size.width;
        }
        
        CGFloat x =  currentWidth + (i>0?marginX:xBorder);
        UIButton * btn = nil;
        if (self.btnArry.count>i) {
            btn = self.btnArry[i];
        }
        if (!btn || ![btn isKindOfClass:[UIButton class]]) {
            btn = [[UIButton alloc] init];
            [btn setTitleColor:self.normalColor?self.normalColor:[UIColor colorWithRed:239/255.0 green:234/255.0 blue:231/255.0 alpha:1] forState:UIControlStateNormal];
            [btn setTitleColor:self.selectedColor?self.selectedColor:[UIColor whiteColor] forState:UIControlStateSelected];
            btn.titleLabel.font = font;
            [self.backView addSubview:btn];
            [self.btnArry addObject:btn];
        }
        btn.hidden = NO;
        [btn setTitle:title forState:UIControlStateNormal];
        btn.frame = CGRectMake(x, btnY, titleWidth, btnHeight);
        currentWidth = CGRectGetMaxX(btn.frame);
        btn.tag = i;
        [btn addTarget:self action:@selector(clickIndex:) forControlEvents:UIControlEventTouchUpInside];
    }
    self->_allItemLength = currentWidth+xBorder;
    self.backView.contentSize = CGSizeMake(self.allItemLength, self.backView.frame.size.height);
}
-(void)clickIndex:(UIButton *)sender
{
    if (self.selectBtn) {
        if (self.selectBtn == sender) {
            return;
        }
        self.selectBtn.selected = false;
    }
    sender.selected = YES;
    self.selectBtn = sender;
    self.selectIndex = sender.tag;
    [self updateLine];
    if (self.delegate) {
        [self.delegate JKMenuView:self didSelectIndex:self.selectIndex];
    }
}
-(void)updateLine
{
    UIButton * btn = [self.btnArry objectAtIndex:self.selectIndex];
    CGFloat lineX = btn.frame.origin.x - kleftAndRightWidth;
    CGFloat lineWidth = btn.frame.size.width + kleftAndRightWidth * 2;
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = self.line.frame ;
        frame.origin.x = lineX;
        frame.size.width = lineWidth;
        self.line.frame = frame;
        
        if (self.backView.scrollEnabled) {
            CGFloat currentOffsetX = self.backView.contentOffset.x;
            CGFloat itemPostion = CGRectGetMaxX(frame);
            CGFloat needChange = itemPostion - self.frame.size.width; // 需要向右滚动的距离
            CGFloat needBack = currentOffsetX - frame.origin.x; // 需要向左滑动的距离
            if (needChange > currentOffsetX) {
                if (itemPostion < self.backView.contentSize.width) {
                    frame.origin.x += 20;
                }
                [self.backView scrollRectToVisible:frame animated:YES];

            }
            else if(needBack >0)
            {
                if (frame.origin.x > 0) {
                    frame.origin.x -= 20;
                }
                [self.backView scrollRectToVisible:frame animated:YES];            }
        }
    }];
}
-(NSMutableArray *)btnArry
{
    if (!_btnArry) {
        _btnArry = [NSMutableArray array];
    }
    return _btnArry;
}

@end
