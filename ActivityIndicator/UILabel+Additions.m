//
//  UILabel+Additions.m
//  RSLibrary
//
//  Created by Rushi on 29/08/14.
//  Copyright (c) 2014 Coruscate. All rights reserved.
//


#import "UILabel+Additions.h"

@implementation UILabel(ISAdditions)

-(CGRect)fitToSize:(CGSize)constainSize
{
   // CGSize sizeThatFits = [self.text sizeWithFont:self.font constrainedToSize:constainSize lineBreakMode:UILineBreakModeWordWrap];
    NSDictionary *attributes = @{NSFontAttributeName:self.font};
    CGSize sizeThatFits = [self.text sizeWithAttributes:attributes];
    
    CGRect selfFrame = self.frame;
    selfFrame.size = sizeThatFits;
    self.frame = selfFrame;
    return selfFrame;
}

-(CGRect)fitToWidth:(CGFloat)width{
    return [self fitToSize:CGSizeMake(width, CGFLOAT_MAX)];
}

-(CGRect)fitToSelfFixWidth{
   // CGSize sizeThatFits = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(self.bounds.size.width, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap];
    
    NSDictionary *attributes = @{NSFontAttributeName:self.font};
    CGSize sizeThatFits = [self.text sizeWithAttributes:attributes];

    CGRect selfFrame = self.frame;
    selfFrame.size.height = sizeThatFits.height;
    self.frame = selfFrame;
    return selfFrame;
}

-(CGRect)fitToSelfWidth{
    return [self fitToWidth:self.frame.size.width];
}

-(CGRect)fitToHeight:(CGFloat)height{
    return [self fitToSize:CGSizeMake(CGFLOAT_MAX, height)];
}
-(CGRect)fitToSelfHeight{
    return [self fitToHeight:self.frame.size.height];
}
@end
