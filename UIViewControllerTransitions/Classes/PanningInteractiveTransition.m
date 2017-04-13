//
//  PanningInteractiveTransition.m
//  UIViewControllerTransitions
//
//  Created by pisces on 11/04/2017.
//
//

#import "PanningInteractiveTransition.h"
#import "AbstractUIViewControllerTransition.h"

@implementation PanningInteractiveTransition
{
@private
    BOOL shouldComplete;
}

#pragma mark - Con(De)structor

- (void)dealloc {
    [_panGestureRecognizer removeTarget:self action:@selector(panned)];
}

- (id)init {
    self = [super init];
    
    if (self) {
        _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panned)];
    }
    
    return self;
}

#pragma mark - Overridden: AbstractInteractiveTransition

- (void)attach:(UIViewController *)viewController presentViewController:(UIViewController *)presentViewController {
    [super attach:viewController presentViewController:presentViewController];
    
    [self.viewController.view addGestureRecognizer:_panGestureRecognizer];
}

- (void)detach {
    [self.viewController.view removeGestureRecognizer:_panGestureRecognizer];
    
    [super detach];
}

#pragma mark - Private selector

- (void)panned {
    const AbstractUIViewControllerTransition *transition = self.currentViewController.transition;
    const CGPoint newPoint = [_panGestureRecognizer locationInView:self.currentViewController.view.window];
    const BOOL isDismissing = self.presentViewController == nil;
    
    switch (_panGestureRecognizer.state) {
        case UIGestureRecognizerStateBegan: {
            self.beginPoint = newPoint;
            transition.interactionEnabled = YES;
            
            if (isDismissing) {
                [self.viewController dismissViewControllerAnimated:YES completion:nil];
            } else {
                [self.viewController presentViewController:self.presentViewController animated:YES completion:nil];
            }
            
            [transition interactiveTransitionBegan:self];
            
            if (isDismissing) {
                [transition.dismissionDelegate didBeginTransition];
            }
            break;
        }
        case UIGestureRecognizerStateChanged: {
            const CGPoint translation = [_panGestureRecognizer translationInView:self.viewController.view.window];
            const CGFloat targetSize = self.direction == InteractiveTransitionDirectionVertical ? [UIScreen mainScreen].bounds.size.height : [UIScreen mainScreen].bounds.size.width;
            const CGFloat point = self.direction == InteractiveTransitionDirectionVertical ? translation.y : translation.x;
            const CGFloat dragAmount = targetSize * (self.presentViewController ? -1 : 1);
            const CGFloat threshold = 0.3;
            const CGFloat percent = fmin(fmax(point / dragAmount, 0), 1);
            shouldComplete = ABS(point / dragAmount) > threshold;
            self.point = newPoint;
            
            if (CGPointEqualToPoint(self.beginViewPoint, CGPointZero)) {
                self.beginViewPoint = self.currentViewController.view.frame.origin;
            }
            
            [self updateInteractiveTransition:percent];
            [transition interactiveTransitionChanged:self percent:percent];
            
            if (isDismissing) {
                [transition.dismissionDelegate didChangeTransition];
            }
            break;
        }
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded: {
            void (^completion)(void) = ^void(void) {
                if (isDismissing) {
                    [transition.dismissionDelegate didEndTransition];
                }
                
                transition.interactionEnabled = NO;
                self.beginPoint = CGPointZero;
                self.beginViewPoint = CGPointZero;
                self.point = CGPointZero;
            };
            
            if (_panGestureRecognizer.state == UIGestureRecognizerStateCancelled || !shouldComplete) {
                [self cancelInteractiveTransition];
                [transition interactiveTransitionCancelled:self completion:completion];
            } else {
                [self finishInteractiveTransition];
                [transition interactiveTransitionCompleted:self completion:completion];
            }
            break;
        }
        default:
            break;
    }
}

@end
