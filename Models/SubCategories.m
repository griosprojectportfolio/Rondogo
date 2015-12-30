//
//  SubCategories.m
//  Rondogo
//
//  Created by GrepRuby3 on 22/12/15.
//  Copyright © 2015 GrepRuby3. All rights reserved.
//

#import "SubCategories.h"

@implementation SubCategories

@dynamic subCat_id;
@dynamic subCat_name;
@dynamic is_deleted;
@dynamic cat_id;
@dynamic subCat_sequence;
@dynamic subCat_imageUrl;

+ (id)findOrCreateByID:(id)anID inContext:(NSManagedObjectContext*)localContext {
    
    SubCategories *obj = [SubCategories MR_findFirstByAttribute:@"subCat_id" withValue:anID inContext:localContext];
    
    if (!obj) {
        obj = [SubCategories MR_createInContext:localContext];
    }
    return obj;
}


+ (void)entityFromArray:(NSArray *)aArray inContext:(NSManagedObjectContext *)localContext {
    for(NSDictionary *aDictionary in aArray) {
        [SubCategories entityFromDictionary:aDictionary inContext:localContext];
    }
}

+ (id)entityFromDictionary:(NSDictionary *)aDictionary inContext:(NSManagedObjectContext *)localContext {
    
    if (![[aDictionary objectForKey:@"id"] isKindOfClass:[NSNull class]]){
        
        SubCategories *obj = (SubCategories*)[self findOrCreateByID:[aDictionary objectForKey:@"id"] inContext:localContext];
        
        obj.subCat_id =[NSNumber numberWithInteger:[[aDictionary objectForKey:@"id"] integerValue]];

        if (![[aDictionary objectForKey:@"subcategory_name"] isKindOfClass:[NSNull class]])
            obj.subCat_name = [aDictionary objectForKey:@"subcategory_name"];
        
        if (![[aDictionary objectForKey:@"is_deleted"] isKindOfClass:[NSNull class]])
            obj.is_deleted =[NSNumber numberWithInteger:[[aDictionary objectForKey:@"is_deleted"] integerValue]];

        if (![[aDictionary objectForKey:@"category_id"] isKindOfClass:[NSNull class]])
            obj.cat_id =[NSNumber numberWithInteger:[[aDictionary objectForKey:@"category_id"] integerValue]];

        if (![[aDictionary objectForKey:@"sequence_no"] isKindOfClass:[NSNull class]])
            obj.subCat_sequence =[NSNumber numberWithInteger:[[aDictionary objectForKey:@"sequence_no"] integerValue]];
        
        obj.subCat_imageUrl = [[aDictionary objectForKey:@"object_data"] objectForKey:@"url"];
        
        
        return obj;
    }
    
    return nil;
}

@end
