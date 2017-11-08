//
//  WJRefreshTableView.m
//  LESport
//
//  Created by Harry Hu on 15/3/18.
//  Copyright (c) 2015年 LETV. All rights reserved.
//

#import "WJRefreshTableView.h"
#import "MJRefresh.h"

@interface WJRefreshTableView ()

@end

@implementation WJRefreshTableView{
    BOOL isHeaderRefresh;
    BOOL isFooterRefresh;
}

- (id)initWithFrame:(CGRect)frame
              style:(UITableViewStyle)style
         refreshNow:(BOOL)isRefresh
    refreshViewType:(WJRefreshViewType)type{
    
    if (self = [super initWithFrame:frame style:style]) {
        NSLog(@"WJRefreshTableView init");
        
        isHeaderRefresh = isRefresh;
        isFooterRefresh = NO;
        self.tableFooterView = [UIView new];
        [self setSeparatorInset:UIEdgeInsetsZero];
        
        
        NSArray *idleImages = @[[UIImage imageNamed:@"Loading001"],
                                [UIImage imageNamed:@"Loading002"],
                                [UIImage imageNamed:@"Loading003"],
                                [UIImage imageNamed:@"Loading004"],
                                [UIImage imageNamed:@"Loading005"],
                                [UIImage imageNamed:@"Loading006"],
                                [UIImage imageNamed:@"Loading007"],
                                [UIImage imageNamed:@"Loading008"],
                                [UIImage imageNamed:@"Loading009"],
                                [UIImage imageNamed:@"Loading010"],
                                [UIImage imageNamed:@"Loading011"],
                                [UIImage imageNamed:@"Loading012"],
                                [UIImage imageNamed:@"Loading013"],
                                [UIImage imageNamed:@"Loading014"],
                                [UIImage imageNamed:@"Loading015"],
                                [UIImage imageNamed:@"Loading016"]];
        
        switch (type) {
            case WJRefreshViewTypeHeader:{
                [self createHeaderWithImages:idleImages];
            }
                break;
                
            case WJRefreshViewTypeFooter:{
                [self createFooterWithImages:idleImages];
            }
                break;
                
            case WJRefreshViewTypeBoth:{
                [self createHeaderWithImages:idleImages];
                [self createFooterWithImages:idleImages];
            }
                break;
                
            default:
                break;
        }
        
        if (isRefresh && (type == WJRefreshViewTypeHeader || type == WJRefreshViewTypeBoth)) {
            [self startHeadRefresh];
        }
        
    }
    
    return self;
}

- (void)createHeaderWithImages:(NSArray *)idleImages{
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadHeaderRefresh)];
    [header setImages:idleImages forState:MJRefreshStateIdle];
    [header setImages:idleImages forState:MJRefreshStatePulling];
    [header setImages:idleImages forState:MJRefreshStateRefreshing];
    // 设置header
    self.header = header;
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;

}

- (void)createFooterWithImages:(NSArray *)idleImages{
    MJRefreshAutoGifFooter *footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadFooterRefresh)];
    [footer setImages:idleImages forState:MJRefreshStateRefreshing];
    self.footer = footer;
    footer.refreshingTitleHidden = YES;
    footer.stateLabel.hidden = YES;
    footer.hidden = YES;
    
}


- (void)setRefreshingImages:(NSArray *)images
                  withState:(WJRefreshViewStatus)viewState
                   position:(WJRefreshViewType)position{
    if (position == WJRefreshViewTypeHeader && viewState < 3) {

    }else if(position == WJRefreshViewTypeFooter){

    }
    
    
    
}

- (void)loadHeaderRefresh{
    if ([self.delegate respondsToSelector:@selector(startHeadRefreshToDo:)]) {
        [self.delegate performSelector:@selector(startHeadRefreshToDo:) withObject:self];
    }else{
        [self.header endRefreshing];
        NSLog(@"未实现下拉刷新事件");
    }
}

- (void)loadFooterRefresh{
    
    if ([self.delegate respondsToSelector:@selector(startFootRefreshToDo:)]) {
        [self.delegate performSelector:@selector(startFootRefreshToDo:) withObject:self];
    }else{
        [self.footer endRefreshing];
        NSLog(@"未实现上拉加载事件");
    }
    
}


- (BOOL)automaticallyRefresh{
    return [(MJRefreshAutoFooter *)self.footer isAutomaticallyRefresh];
}

- (void)setAutomaticallyRefresh:(BOOL)automaticallyRefresh{
    [(MJRefreshAutoFooter *)self.footer setAutomaticallyRefresh:automaticallyRefresh];
}

- (void)hiddenHeader
{
    if (self.header) {
        self.header.hidden = YES;
    }
}

- (void)showHeader
{
    if (self.header) {
        self.header.hidden = NO;
    }
}

- (void)hiddenFooter{
    if (self.footer) {
        self.footer.hidden = YES;
    }
}

- (void)showFooter{
    if (self.footer) {
        self.footer.hidden = NO;
    }
}

- (void)startHeadRefresh{
    [self.header beginRefreshing];
}

- (void)endHeadRefresh{
    [self.header endRefreshing];
}


- (void)startFootRefresh{
    [self.footer beginRefreshing];
}

- (void)endFootFefresh{
    [self.footer endRefreshing];
}

- (void)setView:(WJRefreshViewType)type
           text:(NSString *)text
         status:(WJRefreshViewStatus)status{
    if (type == WJRefreshViewTypeHeader) {
        MJRefreshStateHeader *header = (MJRefreshStateHeader *)self.header;
        [header setTitle:text forState:(MJRefreshState)status];

    }else if (type == WJRefreshViewTypeFooter){
        MJRefreshAutoStateFooter * footer = (MJRefreshAutoStateFooter *)self.footer;
        [footer setTitle:text forState:(MJRefreshState)status];
    }
}

- (void)dealloc{
    NSLog(@"WJRefreshTableView dealloc");
}


@end
