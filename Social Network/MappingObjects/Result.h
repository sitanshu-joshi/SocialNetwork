//
//  Result.h
//  Social Network
//
//  Created by Sitanshu Joshi on 2/2/15.
//  Copyright (c) 2015 Sitanshu Joshi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Result : NSManagedObject

@property (nonatomic, retain) NSString * ids;
@property (nonatomic, retain) NSString * formatted_address;
@property (nonatomic, retain) id geometry;
@property (nonatomic, retain) NSString * icon;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * place_id;
@property (nonatomic, retain) NSString * reference;
@property (nonatomic, retain) id types;

+(RKEntityMapping *)objectMappingForPlaces:(OPPCodeType)OppCodeType;

@end
