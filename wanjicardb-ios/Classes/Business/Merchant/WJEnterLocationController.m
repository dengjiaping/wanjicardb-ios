//
//  WJEnterLocationController.m
//  CardsBusiness
//
//  Created by 熊向天 on 16/1/21.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJEnterLocationController.h"
#import "WJChoiceMapViewController.h"
#import "CBShopInfoClient.h"

@interface WJEnterLocationController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,WJChoiceMapVCDelegate>
{
    UITableView        * mainTableView;
}

@property(nonatomic,strong) UITextField  * addressTF;

@property(nonatomic,strong)BMKPoiInfo             * poiModel;
@property(nonatomic,strong)UIButton               * sureBtn;

@end

@implementation WJEnterLocationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"输入所在地";
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.sureBtn];
    self.addressTF = [[UITextField alloc]init];
}

-(void)returnPoiMessage:(BMKPoiInfo *)poi
{
    self.poiModel = [[BMKPoiInfo alloc]init];
    self.poiModel = poi;
    self.addressTF.text = poi.address;
}

- (void)sureBtnAction
{
    if (self.poiModel) {
        NSString * acswerStr = [self.addressTF.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        if ([self.addressTF.text length] == [acswerStr length]){
            if (![self.addressTF.text isEqualToString:@""]) {
                [[CBShopInfoClient shareRESTClient]updatesShopInfoWithLongitude:[NSString stringWithFormat:@"%f",self.poiModel.pt.longitude] Latitude:[NSString stringWithFormat:@"%f",self.poiModel.pt.latitude] Address:self.addressTF.text finished:^(BOOL success, NSString *message){
                    if (success) {
                        [CBPassport changeShopAddress:self.addressTF.text];
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"ChangeShopAddress" object:nil];
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                }];
            }else{
                ALERT(@"请输入地址");
            }
        }else{
            ALERT(@"输入不能包含空格");
        }
    }else{
        ALERT(@"请进入地图选择店铺地址");
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.addressTF resignFirstResponder];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return ALD(15);
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ALD(45);
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [UIView new];
    return headView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell1"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"myCell1"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
    }
    cell.textLabel.textColor = WJColorDardGray3;
    cell.textLabel.font = WJFont14;
    UILabel *subLabel = [[UILabel alloc]initForAutoLayout];
    subLabel.textColor = WJColorDardGray9;
    subLabel.font = WJFont14;
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"地址";
        _addressTF.frame = CGRectMake(ALD(70), 2, kScreenWidth - ALD(70) - ALD(15), ALD(45));
        _addressTF.font = WJFont14;
        _addressTF.placeholder = @"请输入地址";
        _addressTF.textAlignment = NSTextAlignmentRight;
        _addressTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _addressTF.delegate = self;
        [cell.contentView addSubview:_addressTF];
    }if (indexPath.row == 1) {
        cell.textLabel.text = @"选择定位";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        subLabel.text = @"前往地图添加店铺";
        [cell.contentView addSubview:subLabel];
        [cell.contentView addConstraints:[subLabel constraintsRightInContainer:0]];
        [cell.contentView addConstraint:[subLabel constraintCenterYEqualToView:cell.contentView]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        if ([WJUtilityMethod isNotReachable]) {
            WJChoiceMapViewController * choiceMapVC = [[WJChoiceMapViewController alloc]init];
            choiceMapVC.addressStr = self.addressTF.text;
            choiceMapVC.delegate = self;
            NSLog(@"文本框：%@",choiceMapVC.addressStr);
            [self.navigationController pushViewController:choiceMapVC animated:YES];
        }else{
            ALERT(@"请检查网络");
        }
    }
}

#pragma mark - Getter and Setter
- (UITableView *) tableView
{
    if(nil == mainTableView)
    {
        mainTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, ALD(105)) style:UITableViewStylePlain];
        mainTableView.delegate = self;
        mainTableView.dataSource = self;
        mainTableView.separatorInset = UIEdgeInsetsZero;
        mainTableView.backgroundColor = WJColorViewBg;
        mainTableView.tableFooterView = [UIView new];
    }
    return mainTableView;
}


- (UIButton *)sureBtn
{
    _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _sureBtn.frame = CGRectMake((kScreenWidth - ALD(345))/2 ,ALD(200), ALD(345),ALD(48));
    [_sureBtn setTitle:@"保存" forState:UIControlStateNormal];
    _sureBtn.layer.cornerRadius = ALD(24);
    _sureBtn.enabled = YES;
    [_sureBtn setBackgroundColor:WJColorNavigationBar];
    [_sureBtn addTarget:self action:@selector(sureBtnAction) forControlEvents:UIControlEventTouchUpInside];
    return _sureBtn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
