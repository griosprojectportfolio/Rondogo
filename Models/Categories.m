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
        
        obj.category_id =[NSNumber numberWithInteger:[[aDictionary objectForKey:@"category_id"] integerValue]];
        
        if (![[aDictionary objectForKey:@"category_name"] isKindOfClass:[NSNull class]])
            obj.category_name = [aDictionary objectForKey:@"category_name"];
        
        if (![[aDictionary objectForKey:@"category_language"] isKindOfClass:[NSNull class]])
            obj.category_language = [aDictionary valueForKey:@"category_language"];
        
        if (![[aDictionary objectForKey:@"server_url"] isKindOfClass:[NSNull class]])
            obj.cat_server_url = [aDictionary valueForKey:@"server_url"];
        
        if (![[aDictionary objectForKey:@"local_url"] isKindOfClass:[NSNull class]])
            obj.cat_local_url = [aDictionary valueForKey:@"local_url"];
        
        if (![[aDictionary objectForKey:@"sequence_no"] isKindOfClass:[NSNull class]])
            obj.cat_sequence_no =[NSNumber numberWithInteger:[[aDictionary objectForKey:@"sequence_no"] integerValue]];
        
        if (![[aDictionary objectForKey:@"is_deleted"] isKindOfClass:[NSNull class]])
            obj.is_deleted =[NSNumber numberWithInteger:[[aDictionary objectForKey:@"is_deleted"] integerValue]];

        return obj;
    }
    
    return nil;
}

@end
