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


-(UIImage *)scaleImageForIconicPic:(UIImage *)image {
    @autoreleasepool {
        float actualHeight = image.size.height;
        float actualWidth = image.size.width;
        float maxHeight = 200.0;
        float maxWidth = 200.0;
        float imgRatio = actualWidth/actualHeight;
        float maxRatio = maxWidth/maxHeight;
        float compressionQuality = 0.5;//50 percent compression
        
        if (actualHeight > maxHeight || actualWidth > maxWidth){
            if(imgRatio < maxRatio){
                //adjust width according to maxHeight
                imgRatio = maxHeight / actualHeight;
                actualWidth = imgRatio * actualWidth;
                actualHeight = maxHeight;
            }
            else if(imgRatio > maxRatio){
                //adjust height according to maxWidth
                imgRatio = maxWidth / actualWidth;
                actualHeight = imgRatio * actualHeight;
                actualWidth = maxWidth;
            }
            else{
                actualHeight = maxHeight;
                actualWidth = maxWidth;
            }
        }
        
        CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
        UIGraphicsBeginImageContext(rect.size);
        [image drawInRect:rect];
        UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
        NSData *imageData = UIImageJPEGRepresentation(img, compressionQuality);
        UIGraphicsEndImageContext();
        
        return [UIImage imageWithData:imageData];
    }
}

@end
