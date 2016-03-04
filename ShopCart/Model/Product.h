//
//  Product.h
//  ShopCart
//
//  Created by Rahul Gunjote on 03/03/16.
//  Copyright © 2016 Rahul Gunjote. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 {
 "productname": "Product 1",
 "price": "2000",
 "vendorname": "Vendor 1",
 "vendoraddress": "Pune",
 "productImg": "https://placeholdit.imgix.net/~text?txtsize=70&txt=Product+1&w=500&h=500&txttrack=0",
 "productGallery": [
 "https://placeholdit.imgix.net/~text?txtsize=70&txt=Product+1.1&w=500&h=500&txttrack=0",
 "https://placeholdit.imgix.net/~text?txtsize=70&txt=Product+1.2&w=500&h=500&txttrack=0",
 "https://placeholdit.imgix.net/~text?txtsize=70&txt=Product+1.3&w=500&h=500&txttrack=0",
 "https://placeholdit.imgix.net/~text?txtsize=70&txt=Product+1.4&w=500&h=500&txttrack=0",
 "https://placeholdit.imgix.net/~text?txtsize=70&txt=Product+1.5&w=500&h=500&txttrack=0"
 ],
 "phoneNumber": "+919999999997"
 }
 */
@interface Product : NSObject
@property (nonatomic, strong)NSString *name;
@property (nonatomic, strong)NSString *price;
@property (nonatomic, strong)NSString *vendorName;
@property (nonatomic, strong)NSString *vendorAddress;
@property (nonatomic, strong)NSString *imageURL;
@property (nonatomic, strong)NSString *phoneNumber;
@property (nonatomic, strong)NSMutableArray *productGallery;

-(id)initWithDictionary:(NSDictionary *)productDict ;
@end
