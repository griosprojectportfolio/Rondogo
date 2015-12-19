//
//  Categories.m
//  Rondogo
//
//  Created by GrepRuby3 on 18/12/15.
//  Copyright © 2015 GrepRuby3. All rights reserved.
//

#import "Categories.h"

@implementation Categories

@dynamic category_id;
@dynamic category_name;
@dynamic category_language;
@dynamic cat_server_url;
@dynamic cat_local_url;
@dynamic cat_sequence_no;
@dynamic is_deleted;

+ (id)findOrCreateByID:(id)anID inContext:(NSManagedObjectContext*)localContext {
    
    Categories *obj = [Categories MR_findFirstByAttribute:@"category_id" withValue:anID inContext:localContext];
    
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
    
    if (![[aDictionary objectForKey:@"category_id"] isKindOfClass:[NSNull class]]){
        
        Categories *obj = (Categories*)[self findOrCreateByID:[aDictionary objectForKey:@"category_id"] inContext:localContext];
        return obj;
    }
    
    return nil;
}

@end
