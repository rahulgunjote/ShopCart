//
//  CartViewController.m
//  ShopCart
//
//  Created by Rahul Gunjote on 03/03/16.
//  Copyright © 2016 Rahul Gunjote. All rights reserved.
//

#import "CartViewController.h"
#import "CartItem.h"
#import "CartCell.h"


static NSString * const kCellReuseIdentifier=@"CartCell";

@interface CartViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray        *cartItems;
@property (nonatomic,weak)    IBOutlet UITableView  *tableView;
@property (weak, nonatomic)   IBOutlet UIView       *viewTotalPrice;
@property (weak, nonatomic)   IBOutlet UILabel      *labelTotalPrice;


@end

@implementation CartViewController

-(NSMutableArray *)cartItems{
    if (!_cartItems) {
        _cartItems =[NSMutableArray new];
    }
    return _cartItems;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.estimatedRowHeight = 150;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    UINib *nib = [UINib nibWithNibName:@"CartCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:kCellReuseIdentifier];

    [self addObserver:self forKeyPath:NSStringFromSelector(@selector(cartItems)) options:NSKeyValueObservingOptionNew context:NULL];
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // On each appearance of cart screen load updated datasource
    [self fetchCartItems];
    [self updateTotalPrice];
}
-(void)fetchCartItems {
    //Fetch cart items from database
    NSManagedObjectContext *context = [[CDStack defaultStack] managedObjectContext];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"CartItem"];

    // Sort the records by added date in descending order
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"addedDate"
                                                                   ascending:NO];
    [request setSortDescriptors:@[sortDescriptor]];;
    NSError *fetchError;
    NSArray *results = [context executeFetchRequest:request error:&fetchError];
    if (results.count) {
        [self.cartItems removeAllObjects];
        [self.cartItems addObjectsFromArray:results];
        [self.tableView reloadData];
    }
    self.tableView.hidden = !results.count;
    self.viewTotalPrice.hidden = !results.count;
}

#pragma mark TabelView Datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cartItems.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CartCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellReuseIdentifier forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}
-(void) configureCell:(CartCell *)cell atIndexPath:(NSIndexPath *)indexPath{

    CartItem *cartItem = self.cartItems[indexPath.row];
    [cell.imageViewProductImage sd_setImageWithURL:[NSURL URLWithString:cartItem.productImage] placeholderImage:[UIImage imageNamed:@"image_placeholder"]];
    cell.labelName.text = cartItem.name;
    cell.labelPrice.text = [NSString stringWithFormat:@"%.2f",[cartItem.price doubleValue]];
    cell.labelVendorName.text = cartItem.vendorName;
    cell.labelVendorAddress.text = cartItem.vendorAddress;

    cell.buttonRemoveFromCart.tag = indexPath.row;
    [cell.buttonRemoveFromCart addTarget:self action:@selector(deleteItem:) forControlEvents:UIControlEventTouchUpInside];
    cell.buttonCallVendor.tag = indexPath.row;
    [cell.buttonCallVendor addTarget:self action:@selector(callVendor:) forControlEvents:UIControlEventTouchUpInside];
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
}
#pragma mark
#pragma mark Utility

-(void)deleteItem:(UIButton *)sender{

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    CartItem *cartItem = self.cartItems[indexPath.row];
    NSManagedObjectContext *context = [[CDStack defaultStack] managedObjectContext];
    [context deleteObject:cartItem];
    NSError *saveError;
    if ([context save:&saveError]) {
        [self.cartItems removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];

        [self updateTotalPrice];
        [self reloadBadge];
        if (!self.cartItems.count) {
            self.tableView.hidden = true;
            self.viewTotalPrice.hidden = true;
        }
    }else
    {
        NSLog(@"Error while removing from cart: %@", saveError.localizedDescription);
    }
}
-(void)callVendor:(UIButton *)sender{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    CartItem *cartItem = self.cartItems[indexPath.row];

    NSString *phoneNumber = cartItem.vendorPhoneNumber;
    NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"tel://%@",phoneNumber]];

    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
        [[UIApplication sharedApplication] openURL:phoneUrl];
    } else
    {
        NSLog(@"Can not open URL");
    }
}
- (void)updateTotalPrice{
    NSNumber *sum = [self.cartItems valueForKeyPath:@"@sum.price"];
    self.labelTotalPrice.text = [NSString stringWithFormat:@"Total Price: %.2f",[sum doubleValue]];
}
-(void)reloadBadge{
   UITabBarItem *tabItem =  [self.tabBarController.tabBar.items lastObject];
   tabItem.badgeValue=[NSString stringWithFormat:@"%li",(long)self.cartItems.count];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    [self removeObserver:self forKeyPath:NSStringFromSelector(@selector(cartItems)) context:NULL];
}


@end
