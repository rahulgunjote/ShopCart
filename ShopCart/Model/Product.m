//
//  Product.m
//  ShopCart
//
//  Created by Rahul Gunjote on 03/03/16.
//  Copyright © 2016 Rahul Gunjote. All rights reserved.
//

#import "Product.h"

@implementation Product
-(id)initWithDictionary:(NSDictionary *)productDict{

    self = [super init];
    if (self) {
        _name = [productDict valueForKey:@"productname"];
        _price = [productDict valueForKey:@"price"];
        _imageURL = [productDict valueForKey:@"productImg"];
        _vendorName = [productDict valueForKey:@"vendorname"];
        _vendorAddress = [productDict valueForKey:@"vendoraddress"];
        _phoneNumber = [productDict valueForKey:@"phoneNumber"];
        _productGallery = [productDict valueForKey:@"productGallery"];
    }
    return self;
}
@end
