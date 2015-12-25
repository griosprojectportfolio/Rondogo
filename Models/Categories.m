//
//  Categories.m
//  Rondogo
//
//  Created by GrepRuby3 on 22/12/15.
//  Copyright © 2015 GrepRuby3. All rights reserved.
//

#import "Categories.h"

@implementation Categories

@dynamic cat_sequence;
@dynamic cat_imageUrl;
@dynamic cat_id;
@dynamic cat_language;
@dynamic cat_name;
@dynamic is_deleted;


+ (id)findOrCreateByID:(id)anID inContext:(NSManagedObjectContext*)localContext {
    
    Categories *obj = [Categories MR_findFirstByAttribute:@"cat_id" withValue:anID inContext:localContext];
    
    if (!obj) {
        obj = [Categories MR_createInContext:localContext];
    }
    return obj;
}


+ (void)entityFromArray:(NSArray *)aArray inContext:(NSManagedObjectContext *)localContext {
    for(NSDictionary *aDictionary in aArray) {
        [Categories entityFromDictionary:aDictionary inContext:localContext];
    }
}

+ (id)entityFromDictionary:(NSDictionary *)aDictionary inContext:(NSManagedObjectContext *)localContext {
    
    if (![[aDictionary objectForKey:@"id"] isKindOfClass:[NSNull class]]){
        
        Categories *obj = (Categories*)[self findOrCreateByID:[aDictionary objectForKey:@"id"] inContext:localContext];
        
        obj.cat_id =[NSNumber numberWithInteger:[[aDictionary objectForKey:@"id"] integerValue]];
        
        if (![[aDictionary objectForKey:@"category_name"] isKindOfClass:[NSNull class]])
            obj.cat_name = [aDictionary objectForKey:@"category_name"];
        
        if (![[aDictionary objectForKey:@"category_language"] isKindOfClass:[NSNull class]])
            obj.cat_language = [aDictionary valueForKey:@"category_language"];
        
        if (![[aDictionary objectForKey:@"sequence_no"] isKindOfClass:[NSNull class]])
            obj.cat_sequence =[NSNumber numberWithInteger:[[aDictionary objectForKey:@"sequence_no"] integerValue]];
        
        if (![[aDictionary objectForKey:@"is_deleted"] isKindOfClass:[NSNull class]])
            obj.is_deleted =[NSNumber numberWithInteger:[[aDictionary objectForKey:@"is_deleted"] integerValue]];
        
        obj.cat_imageUrl = [NSString stringWithFormat:@"http://192.168.10.49:3000%@",[[aDictionary objectForKey:@"object_data"] objectForKey:@"url"]];

        return obj;
    }
    
    return nil;
}


@end
