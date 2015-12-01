//
//  MediaObject.m
//  Rondogo
//
//  Created by GrepRuby3 on 26/03/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

#import "MediaObject.h"


@implementation MediaObject

@dynamic category_id;
@dynamic object_id;
@dynamic is_deleted;
@dynamic object_name_english;
@dynamic object_name_hebrew;
@dynamic object_server_url_english;
@dynamic object_server_url_hebrew;
@dynamic object_type;
@dynamic sub_category_id;


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
    
    if (![[aDictionary objectForKey:@"category_id"] isKindOfClass:[NSNull class]]){
        
        MediaObject *obj = (MediaObject*)[self findOrCreateByID:[aDictionary objectForKey:@"id"] inContext:localContext];
        
        obj.category_id =[NSNumber numberWithInteger:[[aDictionary objectForKey:@"category_id"] integerValue]];
        
        if (![[aDictionary objectForKey:@"sub_category_id"] isKindOfClass:[NSNull class]])
            obj.sub_category_id =[NSNumber numberWithInteger:[[aDictionary objectForKey:@"sub_category_id"] integerValue]];
        
        if (![[aDictionary objectForKey:@"id"] isKindOfClass:[NSNull class]])
            obj.object_id = [NSNumber numberWithInteger:[[aDictionary objectForKey:@"id"] integerValue]];
        
        if (![[aDictionary objectForKey:@"is_deleted"] isKindOfClass:[NSNull class]])
            obj.is_deleted =[NSNumber numberWithInteger:[[aDictionary objectForKey:@"is_deleted"] integerValue]];
        
        if (![[aDictionary objectForKey:@"object_name_english"] isKindOfClass:[NSNull class]])
            obj.object_name_english = [aDictionary objectForKey:@"object_name_english"];
        
        if (![[aDictionary objectForKey:@"object_name_hebrew"] isKindOfClass:[NSNull class]])
            obj.object_name_hebrew = [aDictionary valueForKey:@"object_name_hebrew"];
        
        if (![[aDictionary objectForKey:@"object_server_url_english"] isKindOfClass:[NSNull class]])
            obj.object_server_url_english = [aDictionary valueForKey:@"object_server_url_english"];
        
        if (![[aDictionary objectForKey:@"object_server_url_hebrew"] isKindOfClass:[NSNull class]])
            obj.object_server_url_hebrew = [aDictionary valueForKey:@"object_server_url_hebrew"];
        
        if (![[aDictionary objectForKey:@"object_type"] isKindOfClass:[NSNull class]])
            obj.object_type = [NSNumber numberWithInteger:[[aDictionary objectForKey:@"object_type"] integerValue]];
        
        return obj;
    }
    
    return nil;
}


@end
