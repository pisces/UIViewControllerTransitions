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
//  AnimatedTransitioning.m
//  AnimatedTransitionKit
//
//  Created by Steve Kim on 5/12/16.
//  Modified by Steve Kim on 4/14/17.
//      - Renew design and add new feature interactive transition
//  Modified by Steve Kim on 8/14/17.
//      - Refactoring design for 3.0.0
//

#import "AnimatedTransitioning.h"
#import "AnimatedTransition.h"

@implementation AnimatedTransitioning
{
@private BOOL isDismissTransitionInitialized;
}
@synthesize presenting = _presenting;

#pragma mark - Overridden: AbstractAnimatedTransitioning

- (UIViewController *)aboveViewController {
    return _presenting ? self.toViewController : self.fromViewController;
}

- (UIViewController *)belowViewController {
    return _presenting ? self.fromViewController : self.toViewController;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    [super animateTransition:transitionContext];

    isDismissTransitionInitialized = !_presenting;
    
    self.fromViewController.modalPresentationCapturesStatusBarAppearance = YES;
    self.toViewController.modalPresentationCapturesStatusBarAppearance = YES;

    if (self.isAllowsAppearanceTransition && !transitionContext.isInteractive) {
        [self.belowViewController beginAppearanceTransition:!_presenting animated:transitionContext.isAnimated];
    }
    
    if (_presenting) {
        [self animateTransitionForPresenting:transitionContext];
    } else {
        [self animateTransitionForDismission:transitionContext];
    }
}

- (void)clear {
    if (isDismissTransitionInitialized) { return; }

    if (self.isAllowsDeactivating) {
        self.belowViewController.view.alpha = 1;
        self.belowViewController.view.transform = CGAffineTransformTranslate(self.belowViewController.view.transform, 0, 0);
        self.belowViewController.view.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;
        self.belowViewController.view.hidden = NO;
    }

    if (self.isAllowsAppearanceTransition) {
        [self.aboveViewController beginAppearanceTransition:NO animated:NO];
        [self.belowViewController beginAppearanceTransition:YES animated:NO];
    }
    [self.aboveViewController.view removeFromSuperview];

    if (self.isAllowsAppearanceTransition) {
        [self.aboveViewController endAppearanceTransition];
        [self.belowViewController endAppearanceTransition];
    }
}

#pragma mark - Protected methods

- (void)animateTransitionForDismission:(id<UIViewControllerContextTransitioning>)transitionContext {
}

- (void)animateTransitionForPresenting:(id<UIViewControllerContextTransitioning>)transitionContext {
    self.toViewController.view.frame = self.fromViewController.view.bounds;
}

@end
