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
//  AnimatedNavigationTransitioning.m
//  AnimatedTransitionKit
//
//  Created by Steve Kim on 8/13/17.
//

#import "AnimatedNavigationTransitioning.h"

@implementation AnimatedNavigationTransitioning

#pragma mark - Public Properties

- (void)setPush:(BOOL)push {
    _push = push;
    self.options = push ? _appearenceOptions : _disappearenceOptions;
}

#pragma mark - Overridden: AbstractAnimatedTransitioning

- (UIViewController *)aboveViewController {
    return _push ? self.toViewController : self.fromViewController;
}

- (UIViewController *)belowViewController {
    return _push ? self.fromViewController : self.toViewController;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    [super animateTransition:transitionContext];
    
    if (_push) {
        [self animateTransitionForPush:transitionContext];
    } else {
        [self animateTransitionForPop:transitionContext];
    }
}

#pragma mark - Protected methods

- (void)animateTransitionForPop:(id<UIViewControllerContextTransitioning>)transitionContext {
}

- (void)animateTransitionForPush:(id<UIViewControllerContextTransitioning>)transitionContext {
}

@end
