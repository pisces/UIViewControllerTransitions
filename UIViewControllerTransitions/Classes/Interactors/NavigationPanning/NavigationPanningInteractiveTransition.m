//  BSD 2-Clause License
//
//  Copyright (c) 2016 ~ 2021, Steve Kim
//  All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  * Redistributions of source code must retain the above copyright notice, this
//  list of conditions and the following disclaimer.
//
//  * Redistributions in binary form must reproduce the above copyright notice,
//  this list of conditions and the following disclaimer in the documentation
//  and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
//  FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
//  DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
//  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
//  CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
//  OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
//  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
//  NavigationPanningInteractiveTransition.m
//  UIViewControllerTransitions
//
//  Created by Steve Kim on 8/16/17.
//

#import "NavigationPanningInteractiveTransition.h"
#import "UINavigationControllerTransition.h"

@interface NavigationPanningInteractiveTransition ()
@property (nullable, nonatomic, readonly) UINavigationController *navigationController;
@end

@implementation NavigationPanningInteractiveTransition

#pragma mark - Overridden: PanningInteractiveTransition

- (AbstractTransition *)transition {
    return self.navigationController.navigationTransition;
}

- (BOOL)beginInteractiveTransition {
    if ([self.transition isAppearingWithInteractor:self]) {
        if (!self.presentViewController || [self.navigationController.viewControllers containsObject:self.presentViewController]) {
            return NO;
        }
        [self.navigationController pushViewController:self.presentViewController animated:YES];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    return YES;
}

#pragma mark - Properties

- (BOOL)isInteractionEnabled {
    if ([self.transition isAppearingWithInteractor:self]) {
        return self.presentViewController && ![self.navigationController.viewControllers containsObject:self.presentViewController];
    }
    return self.navigationController.viewControllers.count > 1;
}

- (UINavigationController *)navigationController {
    if ([self.viewController isKindOfClass:[UINavigationController class]]) {
        return (UINavigationController *) self.viewController;
    }
    return nil;
}

@end
