//
//  CartItem+CoreDataProperties.h
//  ShopCart
//
//  Created by Rahul Gunjote on 03/03/16.
//  Copyright © 2016 Rahul Gunjote. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CartItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface CartItem (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *addedDate;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSNumber *price;
@property (nullable, nonatomic, retain) NSString *productImage;
@property (nullable, nonatomic, retain) NSNumber *quantity;
@property (nullable, nonatomic, retain) NSString *vendorAddress;
@property (nullable, nonatomic, retain) NSString *vendorName;
@property (nullable, nonatomic, retain) NSString *vendorPhoneNumber;

@end

NS_ASSUME_NONNULL_END
