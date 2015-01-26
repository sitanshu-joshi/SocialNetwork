//
//  UIView+Additions.m
//  RSLibrary
//
//  Created by Rushi on 29/08/14.
//  Copyright (c) 2014 Coruscate. All rights reserved.
//


#import "UIView+Additions.h"
#import "UILabel+Additions.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>


#define PROGRESS_INDICATOR_BG_COLOR [UIColor blackColor]
#define CLEAR_COLOR [UIColor clearColor]
#define LABEL_MAX_LINES 2
#define WHITE_COLOR [UIColor whiteColor]
#define INDICATOR_FONT [UIFont fontWithName:@"Roboto-Light" size:15]

static const CGFloat ISActivityViewMaxWidth            = 250.0f;
static const CGFloat ISActivityViewMinWidth            = 130.0f;
static const NSString * ISActivityContainerKey         = @"ISActivityContainerKey";

static const CGFloat ISActivityViewFadeDuration        = 0.1;
static const CGFloat ISActivityViewCornerRadius        = 10.0;
static const CGFloat ISActivityViewShadowOpacity       = 0.8;
static const CGFloat ISActivityViewShadowRadius        = 6.0;
static const CGSize  ISActivityViewShadowOffset        = { 4.0, 4.0 };

@implementation UIView (ISAdditions)

-(void)setSizeTo:(CGSize)size{
    CGRect selfFrame = self.frame;
    selfFrame.size = size;
    self.frame = selfFrame;
    return;
}

-(void)addSize:(CGSize)size{
    return [self setSizeTo:CGSizeMake(self.frame.size.width + size.width, self.frame.size.height + size.height)];
}

-(void)subtractSize:(CGSize)size{
    return [self setSizeTo:CGSizeMake(self.frame.size.width - size.width, self.frame.size.height - size.height)];
}

-(void)setHeight:(CGFloat)height{
    return[self setSizeTo:CGSizeMake(self.frame.size.width, height)];
}

-(void)addHeight:(CGFloat)height{
    return [self setHeight:(self.frame.size.height + height)];
}

-(void)subtractHeight:(CGFloat)height{
    return [self setHeight:(self.frame.size.height - height)];
}

-(void)setWidth:(CGFloat)width{
    return[self setSizeTo:CGSizeMake(width, self.frame.size.height)];
}

-(void)addWidth:(CGFloat)width{
    return [self setWidth:(self.frame.size.width + width)];;
}

-(void)subtractWidth:(CGFloat)width{
    return [self setWidth:(self.frame.size.width - width)];
}

-(void)resizeToFitSubviewsWithMargin:(CGSize)marginSize{
    CGFloat maxX = 0.0f;
    CGFloat maxY = 0.0f;
    for(UIView *aSubView in self.subviews)
    {
        if(aSubView.isHidden == YES)
            continue;
        CGFloat viewMaxX = CGRectGetMaxX(aSubView.frame);
        CGFloat viewMaxY = CGRectGetMaxY(aSubView.frame);
        
        if(maxX<viewMaxX)
            maxX = viewMaxX;
        if(maxY<viewMaxY)
            maxY = viewMaxY;
    }
    return [self setSizeTo:CGSizeMake(maxX+marginSize.width, maxY+marginSize.height)];
}

-(CGSize)sizeThatFitsSubviews{
    CGFloat maxX = 0.0f;
    CGFloat maxY = 0.0f;
    for(UIView *aSubView in self.subviews){
        if(aSubView.isHidden == YES)
            continue;
        CGFloat viewMaxX = CGRectGetMaxX(aSubView.frame);
        CGFloat viewMaxY = CGRectGetMaxY(aSubView.frame);
        
        if(maxX<viewMaxX)
            maxX = viewMaxX;
        if(maxY<viewMaxY)
            maxY = viewMaxY;
    }
    return CGSizeMake(maxX, maxY);
}

-(void)resizeToFitSubviewsWithPadding:(UIEdgeInsets)paddingInserts{
    
}
-(void)resizeToFitSubviews
{
    return [self resizeToFitSubviewsWithMargin:CGSizeZero];
}

-(void)setOrigin:(CGPoint)newOrigin{
    CGRect selfFrame = self.frame;
    selfFrame.origin = newOrigin;
    self.frame = selfFrame;
}

-(void)setOriginX:(CGFloat)newX{
    CGRect selfFrame = self.frame;
    selfFrame.origin.x = newX;
    self.frame = selfFrame;
}

-(void)setOriginY:(CGFloat)newY{
    CGRect selfFrame = self.frame;
    selfFrame.origin.y = newY;
    self.frame = selfFrame;
}

-(void)centerVerticallyInParentView{
    CGRect parentBound = self.superview.bounds;
    CGPoint selfCenter = self.center;
    int midY = CGRectGetMidY(parentBound);
    selfCenter.y = midY;
    self.center = selfCenter;
}

-(void)centerHorizontallyInParentView{
    CGRect parentBound = self.superview.bounds;
    CGPoint selfCenter = self.center;
    int midX = CGRectGetMidX(parentBound);
    selfCenter.x = midX;
    self.center = selfCenter;
}

-(void)centerInParentView{
    CGRect parentBound = self.superview.bounds;
    int midY = CGRectGetMidY(parentBound);
    int midX = CGRectGetMidX(parentBound);
    self.center = CGPointMake(midX, midY);
}

-(CGFloat)startX{
    return CGRectGetMinX(self.frame);
}

-(CGFloat)midX{
    return CGRectGetMidX(self.frame);
}

-(CGFloat)endX{
    return CGRectGetMaxX(self.frame);
}

-(CGFloat)startY{
    return CGRectGetMinY(self.frame);
}

-(CGFloat)midY{
    return CGRectGetMidY(self.frame);
}

-(CGFloat)endY{
    return CGRectGetMaxY(self.frame);
}

-(CGPoint)boundsCenter{
    CGRect selfBound = self.bounds;
    CGFloat midY = CGRectGetMidY(selfBound);
    CGFloat midX = CGRectGetMidX(selfBound);
    return CGPointMake(midX, midY);
}

#pragma mark - Activity Indicator methods
-(void)showIndicator{
    [self showIndicatorWithTitle:nil userInteraction:NO];
}

-(void)showIndicatorWithTitle:(NSString *)title{
    [self showIndicatorWithTitle:title userInteraction:NO];
}

-(void)showIndicatorWithTitle:(NSString *)title userInteraction:(BOOL)userInteractionEnabled{
    [self _showIndicatorWithTitle:title userInteraction:userInteractionEnabled];
}

-(void)_showIndicatorWithTitle:(NSString *)title userInteraction:(BOOL)userInteractionEnabled{
    UIView *existingActivityView = objc_getAssociatedObject(self, &ISActivityContainerKey);
    if (existingActivityView != nil) return;
    
    UIView *activityContainer = [[UIView alloc] initWithFrame:CGRectZero];
    activityContainer.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    activityContainer.alpha = 0.0;
    
    UIView *activityView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ISActivityViewMaxWidth, 0)];
    activityView.backgroundColor = PROGRESS_INDICATOR_BG_COLOR;
    activityView.userInteractionEnabled = userInteractionEnabled;
    [activityContainer addSubview:activityView];
    activityView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin);
    activityView.layer.cornerRadius = ISActivityViewCornerRadius;
    
    if (userInteractionEnabled) {
        activityView.layer.shadowColor = [PROGRESS_INDICATOR_BG_COLOR colorWithAlphaComponent:1.0f].CGColor;
        activityView.layer.shadowOpacity = ISActivityViewShadowOpacity;
        activityView.layer.shadowRadius = ISActivityViewShadowRadius;
        activityView.layer.shadowOffset = ISActivityViewShadowOffset;
        activityContainer.backgroundColor = CLEAR_COLOR;
    }
    
    CGFloat verticalGap = 15.0f;
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [activityView addSubview:indicator];
    indicator.frame = CGRectMake(verticalGap, verticalGap, 30.0f, 30.0f);
    indicator.autoresizingMask = UIViewAutoresizingNone;
    [indicator startAnimating];
    
    UILabel *lblMessage = nil;
    if(title){
        CGFloat margin = 5.0f;
        lblMessage = [[UILabel alloc] initWithFrame:CGRectMake(margin, indicator.endY+margin*2, ISActivityViewMaxWidth - 2*margin, 5)];
        lblMessage.numberOfLines = LABEL_MAX_LINES;
        lblMessage.backgroundColor = CLEAR_COLOR;
        lblMessage.textColor = WHITE_COLOR;
        lblMessage.textAlignment = NSTextAlignmentCenter;
        lblMessage.font = INDICATOR_FONT;
        lblMessage.text = title;
        [lblMessage fitToWidth:lblMessage.frame.size.width];
        [activityView addSubview:lblMessage];
        lblMessage.autoresizingMask = UIViewAutoresizingNone;
    }
    // associate ourselves with the activity view
    objc_setAssociatedObject (self, &ISActivityContainerKey, activityContainer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [activityView resizeToFitSubviewsWithMargin:CGSizeMake(verticalGap, verticalGap)];
    if(title && activityView.frame.size.width < ISActivityViewMinWidth)
        [activityView setWidth:ISActivityViewMinWidth];
    [self addSubview:activityContainer];
    [indicator centerHorizontallyInParentView];
    [lblMessage centerHorizontallyInParentView];
    
    if(userInteractionEnabled){
        [activityContainer resizeToFitSubviews];
        [activityContainer centerInParentView];
    }else{
        activityContainer.backgroundColor = [PROGRESS_INDICATOR_BG_COLOR colorWithAlphaComponent:0.5f];
        activityContainer.frame = self.bounds;
        activityView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        activityContainer.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    [activityView centerInParentView];
    
    [UIView animateWithDuration:ISActivityViewFadeDuration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         activityContainer.alpha = 1.0;
                     } completion:nil];
}

-(void)hideIndicator{
    UIView *existingActivityView = objc_getAssociatedObject(self, &ISActivityContainerKey);
    
    if (existingActivityView != nil) {
        /*[UIView animateWithDuration:ISActivityViewFadeDuration
         delay:0.0
         options:(UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState)
         animations:^{
         existingActivityView.alpha = 0.0;
         } completion:^(BOOL finished) {
         [existingActivityView removeFromSuperview];
         objc_setAssociatedObject (self, &ISActivityContainerKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
         }]; */
        [existingActivityView removeFromSuperview];
        objc_setAssociatedObject (self, &ISActivityContainerKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

@end
