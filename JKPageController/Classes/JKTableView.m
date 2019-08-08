//
//  JKTableView.m
//  
//
//  Created by songjk  on 2019/4/16.
//  Copyright © 2019 sjk. All rights reserved.
//

#import "JKTableView.h"

@implementation JKTableView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
