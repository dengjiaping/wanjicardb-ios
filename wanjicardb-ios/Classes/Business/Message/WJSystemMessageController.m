//
//  WJSystemMessageController.m
//  CardsBusiness
//
//  Created by XT Xiong on 16/1/6.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJSystemMessageController.h"
#import "WJSystemMessageDetailController.h"
#import "CBMoneyClient.h"
#import "WJRefreshTableView.h"
#import "MJRefresh.h"


@interface WJSystemMessageController ()<UITableViewDataSource,UITableViewDelegate,WJRefreshTableViewDelegate>
{
    WJRefreshTableView       * mainTableView;
}

@end

@implementation WJSystemMessageController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"系统消息";
    [self.view addSubview:self.tableView];
    [self reloadDataWithPage];
}

- (void)reloadDataWithPage
{
    __weak WJSystemMessageController * weakSelf = self;
    [[CBMoneyClient shareRESTClient]systemMessagewithPage:++self.page finished:^(BOOL success, NSDictionary *data, NSString *message) {
        if (success) {
            NSLog(@"请求成功%@",data);
            weakSelf.totalPage = [data[@"totalPage"] intValue];
            weakSelf.totalSize = [data[@"totalSize"] intValue];
            weakSelf.page = [data[@"index"] intValue];
//            weakSelf.dataArray = [data objectForKey:@"result"];
            [weakSelf.dataArray addObjectsFromArray:[data objectForKey:@"result"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
                [weakSelf.tableView endFootFefresh];
                [weakSelf.tableView endHeadRefresh];
            });
            if (weakSelf.page > weakSelf.totalPage) {
                [[TKAlertCenter defaultCenter] postAlertWithMessage:@"暂无消息"];
            }
        }else{
            [[TKAlertCenter defaultCenter] postAlertWithMessage:message];
             --weakSelf.page;
            [weakSelf.tableView reloadData];
            [weakSelf.tableView endFootFefresh];
            [weakSelf.tableView endHeadRefresh];
        }
    }];
}

#pragma mark - WJRefreshTableView Delegate
- (void)startHeadRefreshToDo:(UITableView *)tableView
{
    self.page = 0;
    [self.dataArray removeAllObjects];
    [self reloadDataWithPage];
}

- (void)startFootRefreshToDo:(UITableView *)tableView;
{
    [self reloadDataWithPage];
}


#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ALD(70);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"myCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else
    {
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    UILabel * titleLabel = [[UILabel alloc]initForAutoLayout];
    titleLabel.font = WJFont16;
    [cell.contentView addSubview: titleLabel];
    [cell.contentView addConstraints:[titleLabel constraintsLeftInContainer:ALD(15)]];
    [cell.contentView addConstraints:[titleLabel constraintsTopInContainer:ALD(12)]];
    
    UILabel * subTitleLabel = [[UILabel alloc]initForAutoLayout];
    subTitleLabel.textColor = WJColorDardGray9;
    subTitleLabel.font = WJFont12;
    [cell.contentView addSubview: subTitleLabel];
    [cell.contentView addConstraints:[subTitleLabel constraintsLeftInContainer:ALD(15)]];
    [cell.contentView addConstraints:[subTitleLabel constraintsRightInContainer:ALD(0)]];
    [cell.contentView addConstraints:[subTitleLabel constraintsTopInContainer:ALD(40)]];
    
    UILabel * timeLabel = [[UILabel alloc]initForAutoLayout];
    timeLabel.textColor = WJColorDardGray9;
    timeLabel.font = WJFont12;
    [cell.contentView addSubview: timeLabel];
    [cell.contentView addConstraints:[timeLabel constraintsRightInContainer:ALD(0)]];
    [cell.contentView addConstraints:[timeLabel constraintsTopInContainer:ALD(15)]];
    
    UILabel * dataLabel = [[UILabel alloc]initForAutoLayout];
    dataLabel.textColor = WJColorDardGray9;
    dataLabel.font = WJFont12;
    [cell.contentView addSubview: dataLabel];
    [cell.contentView addConstraints:[dataLabel constraintsRightInContainer:ALD(150)]];
    [cell.contentView addConstraints:[dataLabel constraintsTopInContainer:ALD(15)]];
    
    if ([self.dataArray count] > indexPath.row) {
        titleLabel.text = [self.dataArray[indexPath.row] objectForKey:@"Title"];
        subTitleLabel.text = [self.dataArray[indexPath.row]objectForKey:@"Content"];
        timeLabel.text = [self.dataArray[indexPath.row] objectForKey:@"Date"];
    }
//    dataLabel.text = [NSString stringWithFormat:@"%@",[self.dataArray[indexPath.row] objectForKey:@"Id"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WJSystemMessageDetailController *smdVC = [[WJSystemMessageDetailController alloc]init];
    smdVC.dataDic = self.dataArray[indexPath.row];
    [self.navigationController pushViewController:smdVC animated:YES];
}

#pragma mark- Getter and Setter

-(WJRefreshTableView *) tableView
{
    if(nil == mainTableView)
    {
//        mainTableView=[[WJRefreshTableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 114) style:UITableViewStylePlain];
        mainTableView=[[WJRefreshTableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64) style:UITableViewStylePlain refreshNow:NO refreshViewType:WJRefreshViewTypeBoth];
        mainTableView.delegate = self;
        mainTableView.dataSource = self;
        mainTableView.separatorInset = UIEdgeInsetsZero;
        mainTableView.backgroundColor = WJColorViewBg;
        mainTableView.automaticallyRefresh = YES;
        [mainTableView showFooter];
//        mainTableView.tableFooterView = [[UIView alloc]init];
    }
    return mainTableView;
}

- (NSMutableArray *)dataArray
{
    if (nil == _dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
