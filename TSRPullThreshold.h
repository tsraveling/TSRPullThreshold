//
//  TSRPullThreshold.h
//  Ascendance
//
//  Created by Timothy Raveling on 1/11/14.
//  Copyright (c) 2014 Yetiden Games. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kTSRPullDirectionUp         0
#define kTSRPullDirectionRight      1
#define kTSRPullDirectionDown       2
#define kTSRPullDirectionLeft       3

#define kTSRPullTypeNormal          0
#define kTSRPullTypeDrawer          1

@interface TSRPullThreshold : NSObject
{
    // Public
    UIView *targetView;
    CGFloat pullThreshold;
    CGFloat drawerOutPoint;
    int pullDirection;
    void (^pullBlock)(CGFloat f);
    void (^finishBlock)();
    void (^cancelBlock)();
    BOOL isEnabled,shouldMoveView;
    int pullType;
    BOOL drawerIsOut;
    
    // Private
    CGPoint initialPoint;
    CGRect originalFrame;
    CGRect drawerFrameIn;
    CGRect drawerFrameOut;
    UIPanGestureRecognizer *gestureRecognizer;
    BOOL temporaryHalt;
}

@property (nonatomic,retain) UIView *targetView;
@property (assign) CGFloat pullThreshold,drawerOutPoint;
@property (assign) int pullDirection,pullType;
@property (assign) BOOL isEnabled,shouldMoveView,drawerIsOut;
@property (nonatomic,copy) void (^pullBlock)(CGFloat f);
@property (nonatomic,copy) void (^finishBlock)();
@property (nonatomic,copy) void (^cancelBlock)();

-(id)initWithView:(UIView*)_view direction:(int)dir threshold:(CGFloat)thresh;
-(void)setEnabled:(BOOL)enabled;
-(void)setupDrawerWithOutPos:(CGFloat)outpos;

+(TSRPullThreshold*)attachToView:(UIView*)_view direction:(int)dir threshold:(CGFloat)thresh pullBlock:(void(^)(CGFloat f))pullb finishBlock:(void(^)())finishb cancelBlock:(void(^)())cancelb;
+(TSRPullThreshold*)attachDrawerToView:(UIView*)_view direction:(int)dir threshold:(CGFloat)thresh outPoint:(CGFloat)outpoint pullBlock:(void(^)(CGFloat f))pullb finishBlock:(void(^)())finishb cancelBlock:(void(^)())cancelb;
+(TSRPullThreshold*)attachDrawerToView:(UIView*)_view direction:(int)dir threshold:(CGFloat)thresh outPoint:(CGFloat)outpoint;

-(void)closeDrawer;
-(void)openDrawer;

@end
