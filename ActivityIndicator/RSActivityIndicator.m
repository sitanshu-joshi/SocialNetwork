//
//  RSActivityIndicator.m
//  RSLibrary
//
//  Created by Rushi on 29/08/14.
//  Copyright (c) 2014 Coruscate. All rights reserved.
//

#import "RSActivityIndicator.h"
#import "UIView+Additions.h"

@implementation RSActivityIndicator

+(void)showIndicator
{
    [RSActivityIndicator showIndicatorWithTitle:nil userInteraction:NO];
}
+(void)showIndicatorWithTitle:(NSString *)title
{
    [RSActivityIndicator showIndicatorWithTitle:title userInteraction:NO];
}
+(void)showIndicatorWithTitle:(NSString *)title userInteraction:(BOOL)userInteractionEnabled
{
    UIView *winParent = [[UIApplication sharedApplication].windows objectAtIndex:0];
    [winParent showIndicatorWithTitle:title userInteraction:userInteractionEnabled];
}
+(void)hideIndicator
{
    UIView *winParent = [[UIApplication sharedApplication].windows objectAtIndex:0];
    [winParent hideIndicator];
}


@end
