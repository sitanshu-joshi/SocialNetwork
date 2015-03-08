//
//  UtilityMethods.m
//  Social Network
//
//  Created by Sitanshu Joshi on 3/8/15.
//  Copyright (c) 2015 Sitanshu Joshi. All rights reserved.
//

#import "UtilityMethods.h"

static UtilityMethods *utilityMethods;

@implementation UtilityMethods

+(UtilityMethods *)utilityMethods{
    if(!utilityMethods){
        utilityMethods = [[UtilityMethods alloc] init];
    }
    return utilityMethods;
}

-(BOOL)isUrlForImage:(NSString *)strUtl {
    BOOL isImage = false;
    NSArray *array = [strUtl componentsSeparatedByString:@"."];
    NSString *str = [array lastObject];
    if ([[str lowercaseString] isEqualToString:@"png"] || [[str lowercaseString] isEqualToString:@"jpg"] || [[str lowercaseString] isEqualToString:@"jpeg"] || [[str lowercaseString] isEqualToString:@"gif"]) {
        isImage = true;
    }
    return isImage;
}

@end
