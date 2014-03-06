//
//  TSRPullThreshold.m
//  Ascendance
//
//  Created by Timothy Raveling on 1/11/14.
//  Copyright (c) 2014 Yetiden Games. All rights reserved.
//

#import "TSRPullThreshold.h"

@implementation TSRPullThreshold
@synthesize targetView,pullBlock,pullThreshold,finishBlock,cancelBlock,pullDirection,isEnabled,shouldMoveView,pullType,drawerOutPoint,drawerIsOut;

#pragma mark - Pan Recognizer

-(IBAction)panView:(UIPanGestureRecognizer*)recognizer
{
    if (!isEnabled)return;
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        initialPoint = [recognizer locationInView:targetView.superview];
        temporaryHalt = FALSE;
        originalFrame = targetView.frame;
    }
    
    if (temporaryHalt)return;
    
    CGPoint curpoint = [recognizer locationInView:targetView.superview];
    CGFloat offset=0.0f;
    CGRect setframe = originalFrame;
    switch (pullDirection) {
        case kTSRPullDirectionDown:
        {
            offset = curpoint.y - initialPoint.y;
            if (offset<0.0f)offset = 0.0f;
            setframe.origin.y+=offset;
        } break;
        case kTSRPullDirectionLeft:
        {
            offset = initialPoint.x - curpoint.x;
            if (offset<0.0f)offset = 0.0f;
            setframe.origin.x-=offset;
        } break;
        case kTSRPullDirectionRight:
        {
            offset = curpoint.x - initialPoint.x;
            if (offset<0.0f)offset = 0.0f;
            setframe.origin.x+=offset;
        } break;
        case kTSRPullDirectionUp:
        {
            offset = initialPoint.y - curpoint.y;
            if (offset<0.0f)offset = 0.0f;
            setframe.origin.y-=offset;
        } break;
        default:
            break;
    }
    
    if (shouldMoveView)
        [targetView setFrame:setframe];
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        if (offset > pullThreshold) {
            finishBlock();
            temporaryHalt = TRUE;
            if (pullType == kTSRPullTypeDrawer) {
                pullDirection = [self oppositeDirection:pullDirection];
                NSLog(@"changed direction to %i",pullDirection);
                if (drawerIsOut) {
                    [UIView animateWithDuration:0.2f animations:^{
                        [targetView setFrame:drawerFrameIn];
                    }];
                } else {
                    [UIView animateWithDuration:0.2f animations:^{
                        [targetView setFrame:drawerFrameOut];
                    }];
                }
            }
            drawerIsOut = !drawerIsOut;
        } else {
            if (shouldMoveView) {
                if (pullType == kTSRPullTypeDrawer) {
                    if (drawerIsOut) {
                        [UIView animateWithDuration:0.2f animations:^{
                            [targetView setFrame:drawerFrameOut];
                        }];
                    } else {
                        [UIView animateWithDuration:0.2f animations:^{
                            [targetView setFrame:drawerFrameIn];
                        }];
                    }
                } else {
                    [UIView animateWithDuration:0.2f animations:^{
                        [targetView setFrame:originalFrame];
                    }];
                }
            }
            cancelBlock();
        }
    } else {
        pullBlock(offset);
    }
}

#pragma mark - Main Functions

-(void)setupDrawerWithOutPos:(CGFloat)outpos
{
    drawerOutPoint=outpos;
    
    drawerFrameIn = targetView.frame;
    drawerFrameOut = targetView.frame;
    
    if (pullDirection == kTSRPullDirectionDown)drawerFrameOut.origin.y = drawerOutPoint;
    if (pullDirection == kTSRPullDirectionLeft)drawerFrameOut.origin.x = drawerOutPoint;
    if (pullDirection == kTSRPullDirectionRight)drawerFrameOut.origin.x = drawerOutPoint;
    if (pullDirection == kTSRPullDirectionUp)drawerFrameOut.origin.y = drawerOutPoint;
}

-(int)oppositeDirection:(int)dir
{
    int d = dir;
    d+=2;
    if (d>3)d-=4;
    return d;
}

-(void)setEnabled:(BOOL)enabled
{
    isEnabled = enabled;
    gestureRecognizer.enabled = enabled;
}

-(id)initWithView:(UIView*)_view direction:(int)dir threshold:(CGFloat)thresh
{
    if (self = [super init])
    {
        targetView = _view;
        pullDirection = dir;
        pullThreshold = thresh;
        isEnabled = TRUE;
        shouldMoveView = TRUE;
        
        gestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
        [_view addGestureRecognizer:gestureRecognizer];
    }
    return self;
}

+(TSRPullThreshold*)attachToView:(UIView*)_view
          direction:(int)dir
          threshold:(CGFloat)thresh
          pullBlock:(void(^)(CGFloat f))pullb
        finishBlock:(void(^)())finishb
        cancelBlock:(void(^)())cancelb
{
    TSRPullThreshold *pt = [[TSRPullThreshold alloc] initWithView:_view direction:dir threshold:thresh];
    pt.pullBlock = pullb;
    pt.finishBlock = finishb;
    pt.cancelBlock = cancelb;
    return pt;
}

- (void)closeDrawer
{
    if (drawerIsOut) {
        [UIView animateWithDuration:0.2f animations:^{
            [targetView setFrame:drawerFrameIn];
        }];
    }
}

- (void)openDrawer
{
    if (!drawerIsOut) {
        [UIView animateWithDuration:0.2f animations:^{
            [targetView setFrame:drawerFrameOut];
        }];
    }
}

+(TSRPullThreshold*)attachDrawerToView:(UIView*)_view
                       direction:(int)dir
                       threshold:(CGFloat)thresh
                        outPoint:(CGFloat)outpoint
{
    return [TSRPullThreshold attachDrawerToView:_view
                                      direction:dir
                                      threshold:thresh
                                       outPoint:outpoint
                                      pullBlock:^(CGFloat f) {
                                          
                                      } finishBlock:^{
                                          
                                      } cancelBlock:^{
                                          
                                      }];
}

+(TSRPullThreshold*)attachDrawerToView:(UIView*)_view
                             direction:(int)dir
                             threshold:(CGFloat)thresh
                              outPoint:(CGFloat)outpoint
                             pullBlock:(void(^)(CGFloat f))pullb
                           finishBlock:(void(^)())finishb
                           cancelBlock:(void(^)())cancelb
{
    TSRPullThreshold *pt = [[TSRPullThreshold alloc] initWithView:_view direction:dir threshold:thresh];
    pt.pullBlock = pullb;
    pt.finishBlock = finishb;
    pt.cancelBlock = cancelb;
    pt.drawerOutPoint = outpoint;
    pt.pullType = kTSRPullTypeDrawer;
    [pt setupDrawerWithOutPos:outpoint];
    return pt;
}

@end
