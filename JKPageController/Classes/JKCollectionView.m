//
//  JKCollectionView.m
//  
//
//  Created by songjk on 2019/4/17.
//  Copyright © 2019 sjk. All rights reserved.
//

#import "JKCollectionView.h"
@interface JKCollectionView () <UIGestureRecognizerDelegate>

@end
@implementation JKCollectionView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
