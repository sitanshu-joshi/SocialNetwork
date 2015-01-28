//
//  DataForResponse.m
//  Social Network
//
//  Created by Sagar Gondaliya on 1/28/15.
//  Copyright (c) 2015 Sitanshu Joshi. All rights reserved.
//

#import "DataForResponse.h"
#import "Comment.h"
#import "Post.h"
#import "User.h"


@implementation DataForResponse

@dynamic post;
@dynamic user;
@dynamic comment;


+(RKEntityMapping *)objectMappingForDataResponse:(OPPCodeType)OppCodeType {
    
    RKEntityMapping *mapping = [RKEntityMapping mappingForEntityForName:NSStringFromClass([DataForResponse class]) inManagedObjectStore:[[AppDelegate appDelegate] rkMOS]];
    mapping.setDefaultValueForMissingAttributes = TRUE;
    
    if (OppCodeType == LOGIN) {
        [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"user" toKeyPath:@"user" withMapping:[User objectMappingForLogin:LOGIN]]];
    } else if(OppCodeType == POST) {
        [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"posts" toKeyPath:@"post" withMapping:[Post objectMappingForPost:POST]]];
    } else if (OppCodeType == COMMENT) {
        [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"comments" toKeyPath:@"comment" withMapping:[Comment objectMappingForComment:COMMENT]]];
    }
    
    return mapping;
}

@end
