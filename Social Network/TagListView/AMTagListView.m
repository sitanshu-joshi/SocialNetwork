//
//  AMTagListView.m
//  AMTagListView
//
//  Created by Andrea Mazzini on 20/01/14.
//  Copyright (c) 2014 Fancy Pixel. All rights reserved.
//

#import "AMTagListView.h"

@interface AMTagListView (){
    AMTagView* tagView;
    UIImageView *imgView;
}

@property (nonatomic, copy) AMTagListViewTapHandler tapHandler;
@property (nonatomic, weak) AMTagView *selection;

@end

@implementation AMTagListView

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self setup];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self setup];
	}
	return self;
}

- (void)setup
{
	// Default margins
	_marginX = 4;
	_marginY = 4;
	self.clipsToBounds = YES;
	_tags = [@[] mutableCopy];
	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	[center addObserverForName:AMTagViewNotification
						object:nil
						 queue:nil
					usingBlock:^(NSNotification *notification) {
						if (_tapHandler) {
							self.tapHandler(notification.object);
						}
	}];
}

- (void)setTapHandler:(AMTagListViewTapHandler)tapHandler
{
	_tapHandler = tapHandler;
}

- (void)addTag:(NSString*)text withClose:(BOOL)isClose color:(UIColor *)tagColor withDesc:(NSString *)strDesc {
    @autoreleasepool {
        UIFont *font = kDefaultFont;
        CGSize size = [text sizeWithAttributes:@{NSFontAttributeName: font}];
        float padding = [[AMTagView appearance] textPadding] ? [[AMTagView appearance] textPadding] : kDefaultTextPadding;
        float tagLength = [[AMTagView appearance] tagLength] ? [[AMTagView appearance] tagLength] : kDefaultTagLength;
        
        size.width = (int)size.width + padding * 2 + tagLength;
        size.height = (int)size.height + padding;
        size.width = MIN(size.width, self.frame.size.width - self.marginX * 2);
        
        
        if(isClose) {
            tagView = [[AMTagView alloc] initWithFrame:(CGRect){0, 0, size.width+56, size.height}];
            if (text.length > 38) {
                size.width = 308.0;
                tagView = [[AMTagView alloc] initWithFrame:(CGRect){0, 0, size.width, size.height}];
            } else {
                tagView = [[AMTagView alloc] initWithFrame:(CGRect){0, 0, size.width+56, size.height}];
            }
            tagView.tagDesc = strDesc;
            imgView = [[UIImageView alloc] initWithFrame:CGRectMake(tagView.frame.size.width-54, tagView.frame.origin.y+2, 28, 28)];
            
                    tagView.tagColor = tagColor;
                    //tagView.tagType = kFav_League;
                    //imgView.image = [UIImage imageNamed:@"city"];
            
            UIButton *btnClose = [UIButton buttonWithType:UIButtonTypeCustom];
            [btnClose setFrame:CGRectMake(tagView.frame.size.width-28, tagView.frame.origin.y, 28, 28)];
            [btnClose setImage:[UIImage imageNamed:@"icon_close"] forState:UIControlStateNormal];
            [btnClose addTarget:self action:@selector(closeBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
            [btnClose setContentMode:UIViewContentModeCenter];
            [btnClose setFrame:CGRectMake(tagView.frame.size.width-28, tagView.frame.origin.y, 28, 28)];
            
            [tagView addSubview:btnClose];
            [tagView setupWithText:text];
            [tagView addSubview:imgView];
            [self.tags addObject:tagView];
        } else {
            tagView = [[AMTagView alloc] initWithFrame:(CGRect){0, 0, size.width, size.height}];
            tagView.tagColor = tagColor;
            [tagView setupWithText:text];
            [self.tags addObject:tagView];
        }
            [UIView transitionWithView:self duration:0.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
    
            [self rearrangeTags];
        }
                        completion:NULL];
    }
}
	

-(void)closeBtnTapped:(UIButton *)button{
    self.selection = (AMTagView *)[button superview];
    [self removeTag:self.selection];
     [[NSNotificationCenter defaultCenter] postNotificationName:@"manageTags" object:nil];
}

- (void)rearrangeTags {
    @autoreleasepool {
        [UIView beginAnimations:nil context:(__bridge void *)(self)];
        [UIView setAnimationDelay:0.5];
        [self.subviews enumerateObjectsUsingBlock:^(UIView* obj, NSUInteger idx, BOOL *stop) {
            [obj removeFromSuperview];
        }];
        __block float maxY = 0;
        __block float maxX = 0;
        __block CGSize size;
        [self.tags enumerateObjectsUsingBlock:^(AMTagView* obj, NSUInteger idx, BOOL *stop) {
            size = obj.frame.size;
            [self.subviews enumerateObjectsUsingBlock:^(UIView* obj, NSUInteger idx, BOOL *stop) {
                if ([obj isKindOfClass:[AMTagView class]]) {
                    maxY = MAX(maxY, obj.frame.origin.y);
                }
            }];
            
            [self.subviews enumerateObjectsUsingBlock:^(UIView* obj, NSUInteger idx, BOOL *stop) {
                if ([obj isKindOfClass:[AMTagView class]]) {
                    if (obj.frame.origin.y == maxY) {
                        maxX = MAX(maxX, obj.frame.origin.x + obj.frame.size.width);
                    }
                }
            }];
            
            // Go to a new line if the tag won't fit
            if (size.width + maxX > (self.frame.size.width - self.marginX)) {
                maxY += size.height + self.marginY;
                maxX = 0;
            }
            if (maxY == 0) {
                maxY = self.marginY;
            }
            
            obj.frame = (CGRect){maxX + self.marginX, maxY, size.width, size.height};
            [self addSubview:obj];
        }];
        
        [self setContentSize:(CGSize){self.frame.size.width, maxY + size.height +self.marginY}];
        [UIView commitAnimations];
    }
    
}

- (void)addTags:(NSArray*)array withClose:(BOOL)isClose color:(UIColor *)tagColor
{
	for (NSString* address in array) {
        NSArray *addressComponenet = [address componentsSeparatedByString:@"," ];
        NSString *strText = [addressComponenet objectAtIndex:0];
		[self addTag:strText withClose:isClose color:tagColor withDesc:strText];
	}
}

- (void)removeTag:(AMTagView*)view {
    @autoreleasepool {
        [view removeFromSuperview];
        [self.tags removeObject:view];
        [self rearrangeTags];
    }
	
}

@end
