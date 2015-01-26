//
//  UIView+Additions.h
//  RSLibrary
//
//  Created by Rushi on 29/08/14.
//  Copyright (c) 2014 Coruscate. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface UIView(ISAdditions)

//-(void)setSizeTo:(CGSize)size canChnageCenter:(BOOL)canChnageCenter;
-(void)setSizeTo:(CGSize)size;
-(void)addSize:(CGSize)size;
-(void)subtractSize:(CGSize)size;

-(void)setHeight:(CGFloat)height;
-(void)addHeight:(CGFloat)height;
-(void)subtractHeight:(CGFloat)height;

-(void)setWidth:(CGFloat)width;
-(void)addWidth:(CGFloat)width;
-(void)subtractWidth:(CGFloat)width;

-(void)resizeToFitSubviewsWithMargin:(CGSize)marginSize;
-(void)resizeToFitSubviews;
-(CGSize)sizeThatFitsSubviews;

-(void)setOrigin:(CGPoint)newOrigin;
-(void)setOriginX:(CGFloat)newX;
-(void)setOriginY:(CGFloat)newY;

-(void)centerVerticallyInParentView;
-(void)centerHorizontallyInParentView;
-(void)centerInParentView;

@property(nonatomic, readonly) CGFloat startX;
@property(nonatomic, readonly) CGFloat endX;
@property(nonatomic, readonly) CGFloat midX;
@property(nonatomic, readonly) CGFloat startY;
@property(nonatomic, readonly) CGFloat endY;
@property(nonatomic, readonly) CGFloat midY;
@property(nonatomic, readonly) CGPoint boundsCenter;

-(void)showIndicator;                               //By default user interaction is disabled
-(void)showIndicatorWithTitle:(NSString *)title;    //By default user interaction is disabled
-(void)showIndicatorWithTitle:(NSString *)title userInteraction:(BOOL)userInteractionEnabled;
-(void)hideIndicator;

@end
