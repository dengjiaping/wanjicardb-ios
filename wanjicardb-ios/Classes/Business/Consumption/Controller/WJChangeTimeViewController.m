//
//  WJChangeTimeViewController.m
//  CardsBusiness
//
//  Created by Lynn on 16/1/14.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJChangeTimeViewController.h"
#import "WJTimeTableViewCell.h"
#import "WJPickView.h"
#define kBaseTag        10000

@interface WJChangeTimeViewController ()<UITableViewDataSource,UITableViewDelegate,WJPickViewDelegate>

@property (nonatomic, strong) NSArray           *titleArray;
@property (nonatomic, strong) UITableView       *tableView;

@property (nonatomic, strong) NSArray           *dataArray;
@property (nonatomic, strong) WJPickView        *pickerView;

@property (nonatomic, strong) NSIndexPath       *currentIndex;
@property (nonatomic, strong) UIButton          *saveButton;

@property (nonatomic, strong) UILabel           *tipLabel;

@end

@implementation WJChangeTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.timeType = WJConsumptionTime;
    [self setupUI];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action
- (void)setupUI
{
    [self setupNavigation];
    [self.view addSubview:self.tableView];
    
    
    self.saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.saveButton setFrame:CGRectMake(ALD(15), ALD(160), kScreenWidth - ALD(30), ALD(40))];
    self.saveButton.layer.cornerRadius = ALD(20);
    [self.saveButton setTitle:@"查看" forState:UIControlStateNormal];
    self.saveButton.backgroundColor = WJMainColor;
    [self.saveButton addTarget:self action:@selector(saveTime) forControlEvents:UIControlEventTouchUpInside];
    [self.tableView addSubview:self.saveButton];
    
    self.tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(ALD(15), ALD(100), kScreenWidth - ALD(30), ALD(30))];
    self.tipLabel.text = @"起始时间:00:00:00   结束时间:23:59:59";
    self.tipLabel.font = [UIFont systemFontOfSize:13];
    self.tipLabel.textColor = WJColorDardGray9;
    self.tipLabel.textAlignment = NSTextAlignmentCenter;
    [self.tableView addSubview:self.tipLabel];
}

- (void)setupNavigation
{
    self.title = [self.titleArray objectAtIndex:self.timeType];
}

-(void)saveTime
{
//    if (startTime.length == 0 && endTime.length == 0 ) {
//        [[TKAlertCenter defaultCenter] postAlertWithMessage:@""];
//    }
    
    if ([self.delegate respondsToSelector:@selector(moreTimeConsumptionWithStartTime:endTime:)]) {
        
        NSString * startTime = [[self.dataArray objectAtIndex:0] objectForKey:@"time"];
        NSString * endTime = [[self.dataArray objectAtIndex:1] objectForKey:@"time"];
        
        if ([[startTime substringWithRange:NSMakeRange(0, 4)] intValue] == [[endTime substringWithRange:NSMakeRange(0, 4)] intValue]  ){
            if ([[startTime substringWithRange:NSMakeRange(5, 2)] intValue] == [[endTime substringWithRange:NSMakeRange(5, 2)] intValue]) {
                if ([[startTime substringWithRange:NSMakeRange(8, 2)] intValue] <= [[endTime substringWithRange:NSMakeRange(8, 2)] intValue]) {
                    startTime = [NSString stringWithFormat:@"%@ %@",startTime,@"00:00:00"];
                    endTime = [NSString stringWithFormat:@"%@ %@",endTime, @"23:59:59"];
                    [self.delegate moreTimeConsumptionWithStartTime:startTime endTime:endTime];
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    ALERT(@"开始时间小于结束时间");
                }
            }
            if ([[startTime substringWithRange:NSMakeRange(5, 2)] intValue] > [[endTime substringWithRange:NSMakeRange(5, 2)] intValue]) {
                ALERT(@"开始时间小于结束时间");
            }
            if ([[startTime substringWithRange:NSMakeRange(5, 2)] intValue] < [[endTime substringWithRange:NSMakeRange(5, 2)] intValue]) {
                startTime = [NSString stringWithFormat:@"%@ %@",startTime,@"00:00:00"];
                endTime = [NSString stringWithFormat:@"%@ %@",endTime, @"23:59:59"];
                [self.delegate moreTimeConsumptionWithStartTime:startTime endTime:endTime];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        if ([[startTime substringWithRange:NSMakeRange(0, 4)] intValue] > [[endTime substringWithRange:NSMakeRange(0, 4)] intValue]  ){
            ALERT(@"开始时间小于结束时间");
        }
        if ([[startTime substringWithRange:NSMakeRange(0, 4)] intValue] < [[endTime substringWithRange:NSMakeRange(0, 4)] intValue]  ){
            startTime = [NSString stringWithFormat:@"%@ %@",startTime,@"00:00:00"];
            endTime = [NSString stringWithFormat:@"%@ %@",endTime, @"23:59:59"];
            [self.delegate moreTimeConsumptionWithStartTime:startTime endTime:endTime];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
}


#pragma mark - Delegate
#pragma mark - tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //    return [_listArray count];
    NSLog(@"\n%lu\n%@",(unsigned long)[self.dataArray count],self.dataArray);
    return [self.dataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ALD(44);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"timeCellID";
    WJTimeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[WJTimeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        //        cell.backgroundColor = [UIHelper randomColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    cell.dic = [self.dataArray objectAtIndex:indexPath.row];
    cell.tag = indexPath.row + kBaseTag;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    self.currentIndex = indexPath;
    [self.pickerView presentViewController:self];
}

#pragma mark - WJPickViewDelegate
- (void)pickerView:(WJPickView *)pickerView didSelectRow:(NSString *)selectTimeString;
{
    NSLog(@"%@",selectTimeString);
    
    [[self.dataArray objectAtIndex:self.currentIndex.row] setObject:selectTimeString forKey:@"time"];
    
    WJTimeTableViewCell * cell = (WJTimeTableViewCell *)[self.tableView viewWithTag:self.currentIndex.row + kBaseTag];
    cell.timeLabel.text = selectTimeString;
}

#pragma mark - Property
- (NSArray *)titleArray
{
    return @[@"修改营业时间",@"更多时间"];
}

- (UITableView *)tableView
{
    if (!_tableView) {
//        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, ALD(15), kScreenWidth, ALD(89)) style:UITableViewStylePlain];
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, ALD(15), kScreenWidth, kScreenHeight - ALD(15)) style:UITableViewStylePlain];

        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.scrollEnabled = NO;
        _tableView.backgroundColor = WJColorViewBg;
    }
    return _tableView;
}

- (NSArray *)dataArray
{
    if (!_dataArray) {
        NSLog(@"%@",[CBPassport businessTime]);
        
//        NSArray * array = [[CBPassport businessTime] componentsSeparatedByString:@"-"];
//        NSString * startTime = @"";
//        NSString * endTime = @"";
//        if ([array count]>=1) {
//            startTime = [array objectAtIndex:0];
//        }
//        
//        if ([array count] >= 2) {
//            endTime = [array objectAtIndex:1];
//        }
        NSMutableDictionary * dic0 = [NSMutableDictionary dictionaryWithObjectsAndKeys:((self.timeType == WJBusinessTime)?@"开店时间":@"起始时间"),@"titleText",[WJUtilityMethod currentDay],@"time", nil];
        
        NSMutableDictionary * dic1 = [NSMutableDictionary dictionaryWithObjectsAndKeys:((self.timeType == WJBusinessTime)?@"闭店时间":@"结束时间"),@"titleText", [WJUtilityMethod currentDay],@"time", nil];
        
        
        _dataArray = @[dic0,dic1];
    }
    return _dataArray;
}

- (WJPickView *)pickerView
{
    if (!_pickerView) {
        
        _pickerView = [[WJPickView alloc] initWithTitle:@"选择时间" delegate:self pickViewDataType:PickViewDataTypeTime];
    }
    return _pickerView;
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
