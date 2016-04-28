//
//  DeskViewController.m
//  iPad-Food
//
//  Created by 吴鹏先 on 16/4/8.
//  Copyright © 2016年 wpx. All rights reserved.
//

#import "DeskViewController.h"
#import "DeskCollectionCell.h"
#import "STPopup.h"
@interface DeskViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong)NSArray *deskList;
@end

@implementation DeskViewController

- (instancetype)init
{
    if (self = [super init]) {
        self.contentSizeInPopup = CGSizeMake(0,0);
        self.landscapeContentSizeInPopup = CGSizeMake(550, 650);
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.collectionView.delegate=self;
    self.collectionView.dataSource=self;
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
    //指定布局方式为垂直
    flow.scrollDirection = UICollectionViewScrollDirectionVertical;
    flow.minimumLineSpacing = 15;//最小行间距(当垂直布局时是行间距，当水平布局时可以理解为列间距)
    flow.minimumInteritemSpacing = 10;//两个单元格之间的最小间距
    [self.collectionView setCollectionViewLayout:flow];
    self.deskList=@[@"第一桌",@"第二桌",@"第三卓",@"第四桌",@"第五桌",@"第六桌",@"第七桌",@"第八桌",@"第九桌"];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark CollectionView代理方法
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.collectionView registerNib:[UINib nibWithNibName:@"DeskCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"DeskView"];
    
    
    DeskCollectionCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"DeskView" forIndexPath:indexPath];
    
    cell.backgroundColor=[UIColor whiteColor];
    [cell setDeskNUm:self.deskList[indexPath.row]];
    
    return cell;

}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{

    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width=self.collectionView.frame.size.width / 3 - 10;
    CGFloat height=width/1.22;
    return CGSizeMake(width, height);
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.deskList.count;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    [ud setObject:self.deskList[indexPath.row] forKey:@"deskNum"];
    [self dismissViewControllerAnimated:YES completion:nil];
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
