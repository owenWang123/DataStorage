//
//  ViewController.m
//  FmdbDemo
//
//  Created by 皓天 on 2019/6/26.
//  Copyright © 2019 admin. All rights reserved.
//

#import "ViewController.h"
#import "StudentModel.h"
#import "FMDBdata.h"
#import "FMDBtransaction.h"
#import "FMDBqueue.h"
#import "FMDBaddColumn.h"
#import "FMDBmoveTable.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *sourceArr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configUI];
}
- (void)configUI{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"dbCell"];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 4;
    }
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc]init];
    headerView.backgroundColor = [UIColor redColor];

    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, self.view.bounds.size.width -30, 25)];
    [headerView addSubview:titleLab];
    titleLab.font = [UIFont systemFontOfSize:14];
    titleLab.textColor = [UIColor whiteColor];
    if (section == 0) {
        titleLab.text = @"常规操作";
    }else if (section == 1) {
        titleLab.text = @"事务操作";
    }else if (section == 2) {
        titleLab.text = @"线程操作";
    }else {
        titleLab.text = @"数据库升级";
    }
    
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dbCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSArray *sectionArr = self.sourceArr[indexPath.section];
    cell.textLabel.text = sectionArr[indexPath.row];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        /** ⚠️ 常规操作：增、删、改、查 ⚠️**/
        switch (indexPath.row) {
            case 0:
            {
                StudentModel *model = [[StudentModel alloc]init];
                model.ID = 1;
                model.name = @"Tom";
                model.gender = YES;
                model.score = 80;
                
                FMDBdata *dataBase = [FMDBdata sharedInstance];
                [dataBase handleInsert:model];
            }
                break;
            case 1:
            {
                FMDBdata *dataBase = [FMDBdata sharedInstance];
                [dataBase handleDelete:1];
            }
                break;
            case 2:
            {
                FMDBdata *dataBase = [FMDBdata sharedInstance];
                [dataBase handleUpdateScore:90 withID:1];
            }
                break;
            case 3:
            {
                FMDBdata *dataBase = [FMDBdata sharedInstance];
                NSMutableArray *dataArr = [dataBase handleQuery:1];
                NSLog(@"Query:%@",dataArr);
            }
                
            default:
                break;
        }
    }else if (indexPath.section == 1){
        /** ⚠️ 事务操作 ⚠️**/
        switch (indexPath.row) {
            case 0:
            {
                FMDBtransaction *dataBase = [FMDBtransaction sharedInstance];
                [dataBase handleTransaction];
            }
                break;
            case 1:
            {
                FMDBtransaction *dataBase = [FMDBtransaction sharedInstance];
                [dataBase handleNotransaction];
            }
                break;
                
            default:
                break;
        }
    }else if (indexPath.section == 2){
        /** ⚠️ 线程操作 ⚠️**/
        switch (indexPath.row) {
            case 0:
            {
                FMDBqueue *dataBase = [FMDBqueue sharedInstance];
                [dataBase handleQueueMutilLine];
            }
                break;
            case 1:
            {
                FMDBqueue *dataBase = [FMDBqueue sharedInstance];
                [dataBase handleNormalMutilLine];
            }
                break;
                
            default:
                break;
        }
    }else if (indexPath.section == 3){
        /** ⚠️ 数据库升级 ⚠️**/
        switch (indexPath.row) {
            case 0:
            {
                // 使用时先插入数据
                FMDBaddColumn *addColumn = [FMDBaddColumn sharedInstance];
                [addColumn checkDataBaseUpdate:@"t_student" column:@"phone"];
            }
                break;
            case 1:
            {
                
            }
                break;
                
            default:
                break;
        }
    }
}
- (NSMutableArray *)sourceArr{
    if (_sourceArr == nil) {
        NSArray *tmpArr = @[@[@"insert db",
                              @"delete db",
                              @"update db",
                              @"query db"],
                            @[@"transaction db",
                              @"notransaction db"],
                            @[@"queueMutilLine db",
                              @"normalMutilLine db"],
                            @[@"新增字段(先insert db一条数据)",
                              @"表迁移"]];
        _sourceArr = [NSMutableArray arrayWithArray:tmpArr];
    }
    return _sourceArr;
}

@end
