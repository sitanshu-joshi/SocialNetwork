//
//  UILabel+Additions.h
//  RSLibrary
//
//  Created by Rushi on 29/08/14.
//  Copyright (c) 2014 Coruscate. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface UILabel(ISAdditions)
-(CGRect)fitToSize:(CGSize)constainSize;

-(CGRect)fitToWidth:(CGFloat)width;
-(CGRect)fitToSelfWidth;
-(CGRect)fitToSelfFixWidth;

-(CGRect)fitToHeight:(CGFloat)height;
-(CGRect)fitToSelfHeight;

@end
