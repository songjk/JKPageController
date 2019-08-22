//
//  TestViewController.m
//  mainTest
//
//  Created by 曾静伟 on 2019/4/17.
//  Copyright © 2019 sjk. All rights reserved.
//

#import "TestViewController.h"
#import "JKMenuView.h"
#import "MyTableViewController.h"
@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUP];
}

-(void)setUP
{
    self.view.backgroundColor = [UIColor clearColor];
    for (int i=0; i<10; i++) {
        MyTableViewController * vc1 = [[MyTableViewController alloc] init];
        [self addSubController:vc1];
    }
    [self setCurrentViewByIndex:0];
}
#pragma mark - JKBackControllerDelegate
-(UIView *)JKBackControllerMenueView
{
    JKMenuView * view = [JKMenuView menuWithTitles:@[@"aasdfaa",@"bb",@"awrtywhdfghthwrthwrta",@"bb",@"aetyjea",@"bb",@"atuiouia",@"bb",@"aa",@"bb"] andFrme:CGRectMake(0, 0, self.view.frame.size.width, 50) andItemWidth:0];
    view.backgroundColor = [UIColor blueColor];
    [self.backview addSubview:view];
    return view;
}
-(UIView *)JKBackControllerHeadView
{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    view.backgroundColor = [UIColor redColor];
    return view;
}
-(void)JKBackController:(JKBackController *)vc headerScrollProgress:(CGFloat)progress
{
    
}
- (void)JKBackController:(JKBackController *)vc didScrollFromIndex:(NSInteger)ondIndex toIndex:(NSInteger)newIndex
{
    NSLog(@"now index:%ld",(long)newIndex);
}
-(BOOL)JKBackControllerShouldShownavigationController
{
    return NO;
}
@end
