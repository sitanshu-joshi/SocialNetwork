//
//  DataFromGoogle.h
//  Social Network
//
//  Created by Sitanshu Joshi on 2/2/15.
//  Copyright (c) 2015 Sitanshu Joshi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DataFromGoogle : NSManagedObject

@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSSet *results;
@end

@interface DataFromGoogle (CoreDataGeneratedAccessors)

- (void)addResultsObject:(NSManagedObject *)value;
- (void)removeResultsObject:(NSManagedObject *)value;
- (void)addResults:(NSSet *)values;
- (void)removeResults:(NSSet *)values;

+(RKEntityMapping *)objectMappingForDataFromGoogle:(OPPCodeType)OppCodeType;

@end
