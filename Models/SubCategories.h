//
//  SubCategories.h
//  Rondogo
//
//  Created by GrepRuby3 on 22/12/15.
//  Copyright © 2015 GrepRuby3. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface SubCategories : NSManagedObject

@property (nonatomic, retain) NSNumber *subCat_id;
@property (nonatomic, retain) NSString *subCat_name;
@property (nonatomic, retain) NSNumber *is_deleted;
@property (nonatomic, retain) NSNumber *cat_id;
@property (nonatomic, retain) NSNumber *subCat_sequence;
@property (nonatomic, retain) NSString *subCat_imageUrl;

+ (void)entityFromArray:(NSArray *)aArray inContext:(NSManagedObjectContext*)localContext;
+ (id)entityFromDictionary:(NSDictionary *)aDictionary inContext:(NSManagedObjectContext *)localContext;

@end
