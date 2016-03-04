//
//  CartCell.m
//  ShopCart
//
//  Created by Rahul Gunjote on 03/03/16.
//  Copyright © 2016 Rahul Gunjote. All rights reserved.
//

#import "CartCell.h"

@implementation CartCell

- (void)awakeFromNib {
    // Initialization code
    self.buttonCallVendor.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.buttonCallVendor.layer.borderWidth = 1;
    self.buttonCallVendor.layer.cornerRadius= 5.0;
    self.buttonRemoveFromCart.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.buttonRemoveFromCart.layer.borderWidth = 1;
    self.buttonRemoveFromCart.layer.cornerRadius= 5.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)didTapCallVendorButton:(id)sender {
    if (self.didTapCallVendorHandler) {
        self.didTapCallVendorHandler(self.indexPath);
    }
}

- (IBAction)didTapRemoveFromCartButton:(id)sender {
    if (self.didTapRemoveFromCartHandler) {
        self.didTapRemoveFromCartHandler(self.indexPath);
    }
}
@end
