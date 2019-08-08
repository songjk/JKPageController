//
//  JKScrollView.m
//  fanyuehome
//
//  Created by songjk on 2019/4/17.
//  Copyright © 2019 sjk. All rights reserved.
//

#import "JKScrollView.h"

@implementation JKScrollView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}
@end
