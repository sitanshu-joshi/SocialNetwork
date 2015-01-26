//
//  RSActivityIndicator.h
//  RSLibrary
//
//  Created by Rushi on 29/08/14.
//  Copyright (c) 2014 Coruscate. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSActivityIndicator : NSObject

+(void)showIndicator;                               //By default user interaction is disabled
+(void)showIndicatorWithTitle:(NSString *)title;    //By default user interaction is disabled
+(void)showIndicatorWithTitle:(NSString *)title userInteraction:(BOOL)userInteractionEnabled;
+(void)hideIndicator;

@end
