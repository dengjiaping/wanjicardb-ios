//
//  CBCoredataHelper.m
//  CardsBusiness
//
//  Created by Lynn on 15/7/29.
//  Copyright (c) 2015年 Lynn. All rights reserved.
//

#import "CBCoredataHelper.h"
#import "AppDelegate.h"
#import "CBBranchModel.h"
#import "CBPrivilegeModel.h"
#import "CBProductModel.h"

@interface CBCoredataHelper()

@property (nonatomic, strong) AppDelegate       *myDelegate;
@property (nonatomic, strong) NSManagedObject   *obj;

@end

@implementation CBCoredataHelper

-(AppDelegate *)myDelegate
{
    return self.myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

-(void)save:(NSString *)entityName obj:(NSArray *)someModel
{
    
    _obj = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:self.myDelegate.managedObjectContext];

    if ([entityName isEqualToString:@"Branch"])
    {
        if ([someModel isKindOfClass:[NSArray class]]) {
            someModel = (NSArray *)someModel;
            for (int i = 0; i<[someModel count]; i++) {
                CBBranchModel * branch = [someModel objectAtIndex:i];
//                [self saveBranch:branch];
            }
        }
    } else if([entityName isEqualToString:@"Privilege"])
    {
        if ([someModel isKindOfClass:[NSArray class]]) {
            someModel = (NSArray *)someModel;
            for (int i = 0; i<[someModel count]; i++) {
                CBPrivilegeModel * branch = [someModel objectAtIndex:i];
//                [self savePrivilege:branch];
            }
        }
    } else if ([entityName isEqualToString:@"Product"])
    {
        if ([someModel isKindOfClass:[NSArray class]]) {
            someModel = (NSArray *)someModel;
            for (int i = 0; i<[someModel count]; i++) {
                CBProductModel * branch = [someModel objectAtIndex:i];
//                [self saveProduct:branch];
            }
        }
    }else
    {
        NSAssert(1, @"不存在");
    }
}

//- (void)saveBranch:(CBBranchModel *)branch
//{
//    [self.obj setValue:[NSString stringWithFormat:@"%@",branch.branchID]        forKey:@"branchID"];
//    [self.obj setValue:branch.address                                           forKey:@"address"];
//    [self.obj setValue:branch.businessTime                                      forKey:@"businessTime"];
//    [self.obj setValue:branch.category                                          forKey:@"category"];
//    [self.obj setValue:branch.cover                                             forKey:@"cover"];
//    [self.obj setValue:[NSString stringWithFormat:@"%@",branch.distance]        forKey:@"distance"];
//    [self.obj setValue:branch.distanceStr                                       forKey:@"distanceStr"];
//    [self.obj setValue:[NSString stringWithFormat:@"%@",branch.latitude]        forKey:@"latitude"];
//    [self.obj setValue:[NSString stringWithFormat:@"%@",branch.longitude]       forKey:@"longitude"];
//    [self.obj setValue:branch.name                                              forKey:@"name"];
//    [self.obj setValue:branch.phone                                             forKey:@"phone"];
//    [self.obj setValue:[NSString stringWithFormat:@"%@",branch.totalSale]       forKey:@"totalSale"];
//    
//    
//}

//- (void)savePrivilege:(CBPrivilegeModel *)privilege
//{
//    [self.obj setValue:privilege.createDate                                     forKey:@"createDate"];
//    [self.obj setValue:privilege.descStr                                        forKey:@"desc"];
//    [self.obj setValue:privilege.detail                                         forKey:@"detail"];
//    [self.obj setValue:privilege.imageURL                                       forKey:@"imageURL"];
//    [self.obj setValue:[NSString stringWithFormat:@"%@",privilege.privilegeID]  forKey:@"privilegeId"];
//}
//
//- (void)saveProduct:(CBProductModel *)product
//{
//    [self.obj setValue:product.cover                                            forKey:@"cover"];
//    [self.obj setValue:[NSString stringWithFormat:@"%@",product.facevalue]      forKey:@"faceValue"];
//    [self.obj setValue:product.name                                             forKey:@"name"];
//    [self.obj setValue:[NSString stringWithFormat:@"%@",product.proID]          forKey:@"productID"];
//    [self.obj setValue:[NSString stringWithFormat:@"%@",product.saledNum]       forKey:@"saleNum"];
//    [self.obj setValue:[NSString stringWithFormat:@"%@",product.salePrice]      forKey:@"salePrice"];
//    [self.obj setValue:[NSString stringWithFormat:@"%@",product.status]         forKey:@"status"];
//
//}


-(NSArray *)read:(NSString *)entityName
{

        NSFetchRequest *fetch=[[NSFetchRequest alloc]init];
        NSEntityDescription *object=[NSEntityDescription entityForName:entityName inManagedObjectContext:self.myDelegate.managedObjectContext];
        [fetch setEntity: object ];
        
        NSSortDescriptor *sort=[[NSSortDescriptor alloc]initWithKey:@"" ascending:NO];
    
        NSArray *sortarr=[[NSArray alloc]initWithObjects:sort, nil];
        [fetch setSortDescriptors:sortarr];
        
        NSError *error;
        NSArray *fetchresult=[self.myDelegate.managedObjectContext executeFetchRequest:fetch error:&error];
        
//        for (NSManagedObject *obj in fetchresult) {
            //        citytext.text=[object valueForKey:@"cityname"];
            //        provincetext.text=[object valueForKey:@"provincename"];
            //NSLog(@"city:%@,province:%@ \n",[object valueForKey:@"cityname"],[object valueForKey:@"provincename"]);
            //NSLog(@"%@",objectid);
//        }
        // NSPredicate *pre=[NSPredicate predicateWithFormat:@"%@="];
        // NSLog(@"%@",fetchresult);
//    if ([entityName isEqualToString:@"Branch"])
//    {
//        
//    } else if([entityName isEqualToString:@"Privileges"])
//    {
//        
//    } else if ([entityName isEqualToString:@"Product"])
//    {
//        
//    }
    NSLog(@"fetchresult is :%@",fetchresult);
    return  fetchresult;
}

- (void)clearShopInfo
{
    

}


@end
