//
//  ShopInfoViewController.m
//  CardsBusiness
//
//  Created by Lynn on 15/7/21.
//  Copyright (c) 2015年 Lynn. All rights reserved.
//

#import "ShopInfoViewController.h"
#import "Configure.h"
#import "CBPassport.h"
#import "ShopInfoTableViewCell.h"
#import "CBShopInfoClient.h"
#import "CBUser.h"

@interface ShopInfoViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    BOOL isDifferent;

}
@property (nonatomic, strong) UITableView       * tableView;
@property (nonatomic, strong) NSArray           * listArray;

@property (nonatomic, strong) NSMutableArray    * tfArray;
@property (nonatomic, assign) BOOL              isEdit;

@property (nonatomic, strong) UIButton          *editButton;

@property (nonatomic, strong) UITextField       *addressTF;
@property (nonatomic, strong) UITextField       *phoneTF;

@end

@implementation ShopInfoViewController

#pragma mark - Property

- (NSMutableArray *)tfArray
{
    if (!_tfArray)
    {
        _tfArray = [NSMutableArray array];
    }
    return _tfArray;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        
    }
    return _tableView;
}

- (NSArray *)listArray
{
    if (!_listArray) {
        _listArray =  @[@{@"name":@"商户名", @"content":[CBPassport shopName]},
                        @{@"name":@"地址",   @"content":[CBPassport shopAddress]},
                        @{@"name":@"电话",   @"content":[CBPassport phone]}
                        ];
    }
    return _listArray;
}

#pragma mark - View Controller Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadUI];
    NSLog(@"%@",self.listArray);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - View Controller Flow
#pragma mark - Action

- (void)loadUI
{
    [self navigationAction];
    [self leftNavigationItem];
    [self.view addSubview:self.tableView];
}

- (void)leftNavigationItem
{
    UIButton * leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 0, 22, 22)];
    [leftButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    
    [leftButton addTarget:self action:@selector(backView) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)backView
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)navigationAction
{
    self.navigationItem.title = @"店铺信息";
    
    self.editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.editButton setFrame:CGRectMake(0, 0, 40, 40)];
    [self.editButton setTitle:@"修改" forState:UIControlStateNormal];
    [self.editButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.editButton addTarget:self action:@selector(editShopInfo) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithCustomView:self.editButton];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)editShopInfo
{
    if (self.isEdit) {
        [self shopInfoRequest];
    }else
    {
        self.isEdit = YES;
        
        [self.tfArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isKindOfClass:[UITextField class]]) {
                UITextField * text = (UITextField *)obj;
//                text.borderStyle = UITextBorderStyleLine;
                text.enabled = YES;
            }
        }];
        [self.editButton setTitle:@"完成" forState:UIControlStateNormal];
    }
}

- (void)shopInfoRequest
{
//    for (int i = 0; i < [self.listArray count]; i++) {
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
//        ShopInfoTableViewCell *cell = (ShopInfoTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
//        
//        if (![cell.textTF.text isEqualToString:[[self.listArray  objectAtIndex:i] objectForKey:@"content"]]) {
//            
//            isDifferent = YES;
//        }
//    }
    isDifferent = YES;
    if (isDifferent) {
        //请求
        [self editShopInfoRequest];
        [self.editButton setTitle:@"修改" forState:UIControlStateNormal];
        isDifferent = NO;
        self.isEdit = NO;
    }else
    {
        //没有修改
        [self.editButton setTitle:@"修改" forState:UIControlStateNormal];
        isDifferent = NO;
        self.isEdit = NO;
        
        [self.tfArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isKindOfClass:[UITextField class]]) {
                UITextField * text = (UITextField *)obj;
//                text.borderStyle = UITextBorderStyleNone;
                text.enabled = NO;
            }
        }];
    }
}


- (void)editShopInfoRequest
{
    NSDictionary * dic = @{@"merid"     :[NSString stringWithFormat:@"%d",[CBPassport merID]],
                           @"address"   :self.addressTF.text,
                           @"phone"     :self.phoneTF.text,
                           @"longitude" :[CBPassport longitude],
                           @"latitude"  :[CBPassport latitude]
                           };
    
    __weak ShopInfoViewController * weakSelf = self;
    
    [[CBShopInfoClient shareRESTClient] changeShopInfo:dic finished:^(BOOL success, NSString *message) {
        if (success) {
            [self showHUDWithText:@"修改成功"];
            
            BOOL isNeedPust = NO;
            
            if (![[CBPassport shopAddress] isEqualToString:weakSelf.addressTF.text]) {
                isNeedPust = YES;
            }
            
            [[NSUserDefaults standardUserDefaults] setObject:weakSelf.addressTF.text forKey:@"shopAddress"];
            [[NSUserDefaults standardUserDefaults] setObject:weakSelf.phoneTF.text forKey:@"shopPhoneKey"];

//            if (isNeedPust) {
            [kDefaultCenter postNotificationName:kMainAddressAction object:nil userInfo:@{@"address":weakSelf.addressTF.text,@"phone":weakSelf.phoneTF.text}];
//            }

        }else
        {
            [self showHUDWithText:message];
        }
        
    }];
}

#pragma mark - Delegate
#pragma mark - TableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ALD(56);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifyStr = @"cellID";
    ShopInfoTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifyStr];
    if (!cell) {
        cell = [[ShopInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifyStr];
        [self.tfArray addObject:cell.textTF];
    }
    NSDictionary * dic = [self.listArray  objectAtIndex:indexPath.row];
    
    if (indexPath.row == 0) {
        cell.textTF.userInteractionEnabled = NO;
    }else if(indexPath.row == 1)
    {
        self.addressTF = cell.textTF;
    }else if(indexPath.row == 2)
    {
        self.phoneTF = cell.textTF;
        self.phoneTF.delegate = self;
        self.phoneTF.placeholder = @"请输入手机号/区号-座机号";
    }
    
    cell.textTF.text = dic[@"content"];
    cell.nameLabel.text = dic[@"name"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@",indexPath);

}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@""]) {
        return YES;
    }
    
    if (textField.text.length > 11) {
        return NO;
    }
    
    return YES;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
