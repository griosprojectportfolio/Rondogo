//
//  MediaObject.m
//  Rondogo
//
//  Created by GrepRuby3 on 26/03/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

#import "MediaObject.h"


@implementation MediaObject

@dynamic object_id;
@dynamic object_url;
@dynamic object_type;
@dynamic is_deleted;
@dynamic subCategory_id;
@dynamic object_name;
@dynamic object_sequence;


+ (id)findOrCreateByID:(id)anID inContext:(NSManagedObjectContext*)localContext {
    
    MediaObject *obj = [MediaObject MR_findFirstByAttribute:@"object_id" withValue:anID inContext:localContext];
    
    if (!obj) {
        obj = [MediaObject MR_createInContext:localContext];
    }
    return obj;
}


+ (void)entityFromArray:(NSArray *)aArray inContext:(NSManagedObjectContext *)localContext {
    for(NSDictionary *aDictionary in aArray) {
        [MediaObject entityFromDictionary:aDictionary inContext:localContext];
    }
}

+ (id)entityFromDictionary:(NSDictionary *)aDictionary inContext:(NSManagedObjectContext *)localContext {
    
    if (![[aDictionary objectForKey:@"id"] isKindOfClass:[NSNull class]]){
        
        MediaObject *obj = (MediaObject*)[self findOrCreateByID:[aDictionary objectForKey:@"id"] inContext:localContext];
        
        obj.object_id = [NSNumber numberWithInteger:[[aDictionary objectForKey:@"id"] integerValue]];
        
        obj.object_url = [NSString stringWithFormat:@"http://192.168.10.49:3000%@",[[aDictionary objectForKey:@"object_data"] objectForKey:@"url"]];
        
        if (![[aDictionary objectForKey:@"object_type"] isKindOfClass:[NSNull class]])
            obj.object_type = [NSNumber numberWithInteger:[[aDictionary objectForKey:@"object_type"] integerValue]];

        if (![[aDictionary objectForKey:@"is_deleted"] isKindOfClass:[NSNull class]])
            obj.is_deleted =[NSNumber numberWithInteger:[[aDictionary objectForKey:@"is_deleted"] integerValue]];
        
        if (![[aDictionary objectForKey:@"sub_category_id"] isKindOfClass:[NSNull class]])
            obj.subCategory_id =[NSNumber numberWithInteger:[[aDictionary objectForKey:@"sub_category_id"] integerValue]];

        if (![[aDictionary objectForKey:@"object_name"] isKindOfClass:[NSNull class]])
            obj.object_name = [aDictionary objectForKey:@"object_name"];
        
        if (![[aDictionary objectForKey:@"sequence_no"] isKindOfClass:[NSNull class]])
            obj.object_sequence =[NSNumber numberWithInteger:[[aDictionary objectForKey:@"sequence_no"] integerValue]];

        return obj;
    }
    
    return nil;
}


@end
