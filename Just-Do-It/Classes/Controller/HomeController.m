//
//  HomeController.m
//  JustDoIt
//
//  Created by apple on 16/1/26.
//  洗碗
/*  规则
  1. 洗过的人加星星
  2. 忠实老客 可删减
  3. 神秘过客 可删减
  4. 一轮清空
  5. 怎么样才算一轮
  6. 统计人数。照相。名字
  7. 3个数组 总、已选、未选
  8. 后期声效
  9. 洗过显示日期
  10. 常客
  11. 首页、加人页 删除
  12. 弹出有：删除、编辑、移至哪组、
  13. 如果剩下一个人，直接这个人必须洗。然后下一轮
 */
//#warning Todo  -1.每个区域提示该提示OK 0.新一轮要提示OK 1.常稀变成玩之后应该有个效果。有个效果OK 5.手动加洗过和取消洗过OK 2.点击编辑修改 3.轮完自动清空(不要自动清空) 4. 加完之后模糊OK


#import "HomeController.h"
#import "AddPersonController.h"
#import "MiHeader.h"
#import "CustomCollectionView.h"
#import "CollectionViewCell.h"
#import "MiAudioTool.h"
#import "PlayViewController.h"
#import "MiActionSheet.h"
#import "PlayViewController.h"

#import "MiAlertView.h"

#define musicCount 5
#define colletionViewHeight 80 * 2 + 10 * 3
#define colletionViewWidth ScreenWidth - 20

@interface HomeController ()<AddPersonControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,PlayViewControllerDelegate,AVAudioPlayerDelegate>
{
    int _musicIndex;
}
@property(nonatomic,weak) CustomCollectionView *ofentcollectionView;
@property(nonatomic,weak) CustomCollectionView *unOfentcollectionView;
@property(nonatomic,weak) CustomCollectionView *playCollectionView;
@property(nonatomic,strong) UIScrollView *scrView;
@property(nonatomic,strong) NSMutableArray *ofens;
@property(nonatomic,strong) NSMutableArray *unOfens;
@property(nonatomic,strong) NSMutableArray *plays;

@property(nonatomic,weak)UILabel *ofenLable;
@property(nonatomic,weak)UILabel *unOfenLabel;
@property(nonatomic,weak)UILabel *playLabel;

@end

static NSString *const cellID = @"Micell";
static NSString *const playCellID = @"playCell";

static NSString *const belongKey = @"belongKey";
static NSString *const belongOfen = @"belongOfen";
static NSString *const belongUnOfen = @"belongUnOfen";



@implementation HomeController

- (NSMutableArray *)ofens
{
     if (!_ofens) {
        _ofens = [NSMutableArray array];
    }
    return _ofens;
}
- (NSMutableArray *)unOfens
{
    if (!_unOfens) {
        _unOfens = [NSMutableArray array];
    }
    return _unOfens;
}
- (NSMutableArray *)plays
{
    if (!_plays) {
        _plays = [NSMutableArray array];
    }
    return _plays;
}


- (UIScrollView *)scrView
{
    if (!_scrView) {
        _scrView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 80, ScreenWidth, ScreenHeight - 65)];
        [self.view addSubview:_scrView];
        _scrView.showsVerticalScrollIndicator = NO;
    }
    return _scrView;
}

- (void)reloadDataForOfenCollectionView
{
    [self.ofentcollectionView reloadData];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
   AVAudioPlayer *player = [MiAudioTool playMusic:@"bgMusic00.mp3"];
    player.delegate = self;
    _musicIndex = 0;
    
// 基本设置
    self.view.backgroundColor = MiRandomColor;
    self.ofens = [NSKeyedUnarchiver unarchiveObjectWithFile:kOfentArrPath];
    self.unOfens = [NSKeyedUnarchiver unarchiveObjectWithFile:kUnOfentArrPath];
    self.plays = [NSKeyedUnarchiver unarchiveObjectWithFile:kPlayArrPath];
    
//    [self setupBgView];
    [self setupTopBtns];
    [self setupOfentCollectionView];
    [self setupPlaycollectionView];
    [self setupUnOfentcollectionView];
    [self notXWCount];
}

#pragma mark 音乐播放完
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    _musicIndex ++ ;
    if ((musicCount + 1) == _musicIndex) {
        _musicIndex = 0;
    }
    
    [MiAudioTool playMusic:[NSString stringWithFormat:@"bgMusic0%d.mp3",_musicIndex]];
    
}

- (void)setupTopBtns
{
    CGFloat btnCount = 4;
    NSArray *titles = @[@"熟->玩",@"开",@"新一轮",@"加碗"];
    for (int i = 0; i < btnCount; i ++) {
        CGFloat btnW = 80;
        if (ScreenHeight <= 568) {
            btnW = 70;
        }
        CGFloat btnH = 40;
        UIButton *topBtn = [UIButton buttonWithType:0 ];
        [self.view addSubview:topBtn];
        topBtn.frame = CGRectMake(10 + i * (btnW + (ScreenWidth - 20 - btnW * btnCount) /(btnCount -1)) , 25 , btnW, btnH);
        topBtn.backgroundColor = MiRandomColorRGBA(0.8);
        topBtn.clipsToBounds = YES;
        topBtn.layer.cornerRadius = 4;
        topBtn.tag = i + 10;
        topBtn.showsTouchWhenHighlighted = YES;
        [topBtn setTitle:titles[i] forState:(UIControlStateNormal)];
        [topBtn addTarget:self action:@selector(topBtnCilick:) forControlEvents:(UIControlEventTouchUpInside)];
        
        // 对熟->玩进行判断
        if (i == 0) {
            if ([USERDEFAULTS boolForKey:DidAddAllOfentPerson_Key]) {
                [topBtn setTitle:@"已变" forState:(UIControlStateNormal)];
                [topBtn setAlpha:0.5];
            }
        }
        
        // 对“开”进行双击处理
        if (i == 1) {
            UITapGestureRecognizer *doubleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(beginPlayBtnDoubleTap:) ];
            doubleTap.numberOfTapsRequired = 2 ;
            [topBtn addGestureRecognizer:doubleTap];
        }
    }
}

#pragma mark 玩完代理回调-加红心
- (void)playDoneByController:(PlayViewController *)controller mainPerson:(Person *)mainPerson subPerson:(Person *)subPerson presonCount:(int)personCount
{
    [self.plays removeObject:mainPerson];
    if (personCount == 2)     [self.plays removeObject:subPerson];
    [self.playCollectionView reloadData];
    
    // 判断对象属于哪个数组，加红心
    [self loveHandlleWithPerson:mainPerson];
    if (personCount == 2)  [self loveHandlleWithPerson:subPerson];

    // 判断常客剩下多少人没洗完
    [self notXWCount];

    [self reloadDataForOfenCollectionView];
    [self.unOfentcollectionView reloadData];
}

#pragma mark 判断对象属于哪个数组，加红心
- (void)loveHandlleWithPerson:(Person *)didXWPerson
{
    for (int i = 0; i < self.ofens.count; i ++) {
        Person *p = self.ofens[i];
        if (p.ID == didXWPerson.ID) { // 证明是常客
            p.doneXW = YES;
            [self.ofens replaceObjectAtIndex:i withObject:p];
        }
    }
    
    for (int i = 0; i < self.unOfens.count; i ++) {
        Person *p = self.unOfens[i];
        if (p.ID == didXWPerson.ID) { // 证明是常客
            p.doneXW = YES;
            [self.unOfens replaceObjectAtIndex:i withObject:p];
        }
    }
}

#pragma mark 顶部按钮点击
- (void)topBtnCilick:(UIButton *)topBtn
{
    if (topBtn.tag == 10) { // 熟->玩
        if ([topBtn.currentTitle isEqualToString:@"熟->玩"] && ![USERDEFAULTS boolForKey:DidAddAllOfentPerson_Key]) {
            // 将全部熟客的变成玩的
            if (self.ofens.count == 0) {
                return;
            }
             [self btnNoUse];
            // 如果之前游戏区有的对象的就不加进去
            NSMutableArray * temOfens = [NSMutableArray array];
            for (int i = 0; i < self.ofens.count;i++ ) {
               Person *ofentP = self.ofens[i];
                if (!ofentP.inPlaying) [self.plays addObject:ofentP];
                ofentP.inPlaying = YES;
                [temOfens addObject:ofentP];
            }
        [self.ofens removeAllObjects];
        [self.ofens addObjectsFromArray:temOfens];
        [self reloadDataForOfenCollectionView];
        [self.playCollectionView reloadData];
        }
    }
    else if (topBtn.tag == 11) // 开
    {
        if (self.plays.count < 2) {
            [MiPop show:@"2个人都没有。玩蛋蛋？"];
            return;
        }
        PlayViewController *playVc = [[PlayViewController alloc] init];
        playVc.playArray  = [self.plays mutableCopy];
        playVc.delegate = self;
        [self presentViewController:playVc animated:YES completion:nil];
    }
     else if (topBtn.tag == 12) // 新一轮
     {
//         for (Person *p  in self.ofens) {
//             if (p.inPlaying) {
//                 
//            
//         }
         // 提示
         [MiAlertView alertWithTitle:@"确定要来新一轮吗？感觉还有漏网之鱼" complete:^{
             [self newRoundHanddle];
         }];
     }
     else if (topBtn.tag == 13) // 加碗
    {
        AddPersonController *add = [[AddPersonController alloc] init];
        add.delegate = self;
        [self presentViewController:add animated:YES completion:nil];
    }
}

#pragma mark - --------抽取的处理方法--------
#pragma mark  判断常客剩下多少人没洗完做相应处理
- (void)notXWCount
{
    if (self.ofens.count== 0) return;
    
    int i = 0 ;
    for (Person *p in self.ofens) {
        if (p.doneXW == NO) {
            i++;
        }
    }
    if (i == 1) {
        [MiPop show:@"熟客区只剩1个人没洗碗了！"];
    }
    if (i == 0) {
        [MiPop show:@"熟客已循环完！"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MiAlertView alertWithTitle:@"是否开始新的循环" complete:^{
                [self newRoundHanddle];
            }];
        });
    }
}

#pragma mark  新一轮处理（）
- (void)newRoundHanddle
{
    // 改变第一个按钮
    [self btnRecover];
    
    // 清空玩的数组
    [self.plays removeAllObjects];
    [self.playCollectionView reloadData];
    
    // 全部人心清空。
    NSMutableArray *tempOfenArr = [NSMutableArray arrayWithArray:self.ofens];
    NSMutableArray *tempUnOfenArr = [NSMutableArray arrayWithArray:self.unOfens];
    [self.ofens removeAllObjects];
    [self.unOfens removeAllObjects];
    for (Person *p  in tempOfenArr) {
        p.doneXW = NO;
        p.inPlaying = NO;
        [self.ofens addObject:p];
    }
    for (Person *p  in tempUnOfenArr) {
        p.doneXW = NO;
        p.inPlaying = NO;
        [self.unOfens addObject:p];
    }
    [self.ofentcollectionView reloadData];
    [self.unOfentcollectionView reloadData];
}

#pragma mark 熟->玩
- (void)btnRecover
{
    // 改变第一个按钮
    UIButton *ofenToPlayBtn =  [self.view viewWithTag:10];
    [ofenToPlayBtn setTitle:@"熟->玩" forState:(UIControlStateNormal)];
    [ofenToPlayBtn setAlpha:1];
    [USERDEFAULTS setBool:NO forKey:DidAddAllOfentPerson_Key];
    ofenToPlayBtn.enabled = YES;
}
#pragma mark 熟->玩不能点击
- (void)btnNoUse
{
    UIButton *topBtn =  [self.view viewWithTag:10];
    [USERDEFAULTS setBool:YES forKey:DidAddAllOfentPerson_Key];
    [topBtn setTitle:@"已变" forState:(UIControlStateNormal) ];
    topBtn.enabled = NO;
    [topBtn setAlpha:0.5];
}


#pragma mark- 配置CollectionView
- (void)setupOfentCollectionView
{
    CustomCollectionView *ofentcollectionView = [[CustomCollectionView alloc] initWithFrame:CGRectMake(10, 0, colletionViewWidth, colletionViewHeight) ];
    [self.scrView addSubview:ofentcollectionView];
    ofentcollectionView.delegate = self;
    ofentcollectionView.dataSource = self;
    [ofentcollectionView registerNib:[UINib nibWithNibName:@"CollectionViewCell" bundle:nil] forCellWithReuseIdentifier:cellID];
    self.ofentcollectionView = ofentcollectionView;
    ofentcollectionView.backgroundColor = MiRandomColorRGBA(0.2);
    ofentcollectionView.clipsToBounds = YES;
    ofentcollectionView.layer.cornerRadius = 5;
    
    UILabel *ofenLabel = [self creatLabelWithTitle:@"长期蛀虫" frame:ofentcollectionView.frame];
    [self.scrView addSubview:ofenLabel];
    self.ofenLable = ofenLabel;
}

- (UILabel *)creatLabelWithTitle:(NSString *)title frame:(CGRect)frame
{
    UILabel *label = [[UILabel alloc] init];
    label.text = title;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:40];
    label.frame = frame;
    label.textColor = MiRandomColor;
    return label;
}

- (void)setupPlaycollectionView
{
    CustomCollectionView *playcollectionView = [[CustomCollectionView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.ofentcollectionView.frame) + 15, colletionViewWidth, itemWH_Play * itemRow_Play + 5 * (itemRow_Play * 2 )) forPalycollectionViewLayout:nil];
    [self.scrView  addSubview:playcollectionView];
    playcollectionView.delegate = self;
    playcollectionView.dataSource = self;
    [playcollectionView registerNib:[UINib nibWithNibName:@"PlayCell" bundle:nil] forCellWithReuseIdentifier:playCellID];
    self.playCollectionView = playcollectionView;
    playcollectionView.backgroundColor = MiRandomColorRGBA(0.2);
    playcollectionView.clipsToBounds = YES;
    playcollectionView.layer.cornerRadius = 5;

    UILabel *playLabel = [self creatLabelWithTitle:@"玩家区" frame:playcollectionView.frame];
    [self.scrView addSubview:playLabel];
    self.playLabel = playLabel;
}

- (void)setupUnOfentcollectionView
{
    CustomCollectionView *unOfentcollectionView = [[CustomCollectionView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.playCollectionView.frame) + 15, colletionViewWidth, colletionViewHeight)];
    [self.scrView  addSubview:unOfentcollectionView];
    unOfentcollectionView.delegate = self;
    unOfentcollectionView.dataSource = self;
    [unOfentcollectionView registerNib:[UINib nibWithNibName:@"CollectionViewCell" bundle:nil] forCellWithReuseIdentifier:cellID];
    self.unOfentcollectionView = unOfentcollectionView;
    unOfentcollectionView.backgroundColor = MiRandomColorRGBA(0.2);

    unOfentcollectionView.clipsToBounds = YES;
    unOfentcollectionView.layer.cornerRadius = 5;
    
    // 在最后的控件设置ContenSize
    if (ScreenHeight > 568) {  // i6以上
        self.scrView.contentSize = CGSizeMake(0, CGRectGetMaxY(self.unOfentcollectionView.frame) + 30);
    }
   else {
        self.scrView.contentSize = CGSizeMake(0, CGRectGetMaxY(self.unOfentcollectionView.frame) + 30);
    }

    UILabel *unofenLabel = [self creatLabelWithTitle:@"有空蹭饭区" frame:unOfentcollectionView.frame];
    [self.scrView addSubview:unofenLabel];
    self.unOfenLabel = unofenLabel;
}


#pragma mark-
#pragma mark  增加成功 回调
- (void)AddPersonController:(AddPersonController *)controller person:(Person *)person
{
    [self btnRecover];

    // 按照身份分类
    (person.ofent) ? [self.ofens addObject:person] : [self.unOfens addObject:person];
    [self reloadDataForOfenCollectionView];
    [self.unOfentcollectionView reloadData];
}

#pragma mark - CollectionView代理 & 数据源
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    // 如果熟客区全部人都洗过或者剩下一个人。提醒
    if (collectionView == self.ofentcollectionView) {
        [NSKeyedArchiver archiveRootObject:self.ofens toFile:kOfentArrPath];
        self.ofenLable.hidden = self.ofens.count;
 
    }
    else if (collectionView == self.unOfentcollectionView)
    {
        [NSKeyedArchiver archiveRootObject:self.unOfens toFile:kUnOfentArrPath];
        self.unOfenLabel.hidden = self.unOfens.count;
    }
    else
    {
        [NSKeyedArchiver archiveRootObject:self.plays toFile:kPlayArrPath];
        self.playLabel.hidden = self.plays.count;
    }

    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    if (collectionView == self.ofentcollectionView) {
          return self.ofens.count ;
    }
    else if(collectionView == self.unOfentcollectionView)
    {
        return self.unOfens.count;
    }
    else
    {
        return  self.plays.count;
    }
  
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCell *cell = nil;
   
    if (collectionView == self.ofentcollectionView) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
        cell.p =  self.ofens[indexPath.row];
        cell.clipsToBounds = YES;
        cell.layer.cornerRadius = 4;
        cell.tag = 0 + indexPath.row;
    }
    else if (collectionView == self.unOfentcollectionView)
    {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
        cell.p =  self.unOfens[indexPath.row];
        cell.clipsToBounds = YES;
        cell.layer.cornerRadius = 4;
        cell.tag = 10000 + indexPath.row;
    }
    
    else
    {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:playCellID forIndexPath:indexPath];
        cell.clipsToBounds = YES;
        cell.layer.cornerRadius = itemWH_Play * 0.5;
        cell.tag = 1000 + indexPath.row;
        cell.p = self.plays[indexPath.row];
    }
    // 加手势
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellDoubleTap:)];
//    doubleTap.numberOfTapsRequired = 2;
    [cell addGestureRecognizer:doubleTap];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(cellLongPress:)];
    [cell addGestureRecognizer:longPress];

    return cell;
}

#pragma mark cell长按
- (void)cellLongPress:(UILongPressGestureRecognizer *)longPress
{
    NSInteger tag = longPress.view.tag;
    if (longPress.state == UIGestureRecognizerStateBegan) {
    if (tag < 100) { // 长按了熟客

        Person *p = self.ofens[tag];
        NSString *  title = (p.isDoneXW) ? @"其实此人还没洗碗" : @"其实此人洗过碗了";
        MiActionSheet *action = [[MiActionSheet alloc] initWithTitle:@"魂淡选择操作吧" cancelButtonTitle:@"取消" otherButtonTitles:@[@"移至蹭饭族",@"干掉",title]];
        
        action.titleBtnClick =  ^(NSInteger index ){
            if (index == 0) { // 移动至稀客

                Person *p = self.ofens[tag];
                p.ofent = NO;
                [self.unOfens addObject:p];
                [self.ofens removeObject:p];
                [self.unOfentcollectionView reloadData];
                
            }
            else if (index == 1) // 删除
            {
                [self.ofens removeObjectAtIndex:tag];
            }
            else if (index == 2) // 变为相反洗碗状态
            {
                p.doneXW = !p.isDoneXW;
                p.inPlaying =  [title isEqualToString:@"其实此人还没洗碗"] ?   NO : YES;
                
                if([title isEqualToString:@"其实此人洗过碗了"] && p.inPlaying)
                {
                    if (self.plays.count > 0) {
                        int idx = 0;
                        for (int i = 0; i< self.plays.count; i ++) {
                            Person *playPerson = self.plays[i];
                            if (playPerson.ID == p.ID) {
                                idx = i;
                            }
                        }
                        [self.plays removeObjectAtIndex:idx];
                        [self.playCollectionView reloadData];
                    }
                }
                
                [self.ofens replaceObjectAtIndex:tag withObject:p];
            }
            [self reloadDataForOfenCollectionView];
        };
 
    }
     else if (tag >= 10000) // 长按稀客
    {
        Person *p = self.unOfens[tag - 10000];
        NSString *  title = (p.isDoneXW) ? @"其实此人还没洗碗" : @"其实此人洗过碗了";
        MiActionSheet *action = [[MiActionSheet alloc] initWithTitle:@"魂淡选择操作吧" cancelButtonTitle:@"取消" otherButtonTitles:@[@"移至蛀虫族",@"干掉",title]];
        action.titleBtnClick =  ^(NSInteger index ){
            if (index == 0) { // 移动至常客
                [self.ofens addObject:p];
                p.ofent = YES;
                [self.unOfens removeObject:p];
                [self reloadDataForOfenCollectionView];
            }
            else if (index == 1) // 删除
            {
                [self.unOfens removeObjectAtIndex:tag - 10000];
            }
            else if (index == 2) // 变为相反洗碗状态
            {
                p.doneXW = !p.isDoneXW;
                p.inPlaying =  [title isEqualToString:@"其实此人还没洗碗"] ?   NO : YES;
                
                // 如果洗过，找到在游戏区的人，把他弄掉
                if([title isEqualToString:@"其实此人洗过碗了"] && p.inPlaying)
                {
                    if (self.plays.count > 0) {
                        int idx = 0;
                        for (int i = 0; i< self.plays.count; i ++) {
                            Person *playPerson = self.plays[i];
                            if (playPerson.ID == p.ID) {
                                idx = i;
                            }
                        }
                        [self.plays removeObjectAtIndex:idx];
                        [self.playCollectionView reloadData];
                    }
                }
                
                [self.unOfens replaceObjectAtIndex:tag- 10000 withObject:p];
            }
            [self.unOfentcollectionView reloadData];
        };
        
    }
    else // 长按了玩的人
    {
        MiActionSheet *action = [[MiActionSheet alloc] initWithTitle:@"魂淡选择操作吧" cancelButtonTitle:@"取消" otherButtonTitles:@[@"Kill-All"]];
        action.titleColor = [UIColor redColor];
        action.titleBtnClick =  ^(NSInteger index ){
            if (index == 0) {
                
                // 判断属于哪个数组？然后inplay属性变为NO
                [self setNoInPlayingForArray];
                
                [self.ofentcollectionView reloadData];
                [self.unOfentcollectionView reloadData];
                [self.plays removeAllObjects];
                [self.playCollectionView reloadData];
                
                // 该死的按钮
                [self btnRecover];
            }
        };
    }
    }
}
#pragma mark  判断游戏区的对象属于哪个数组？然后inplay属性变为NO
- (void)setNoInPlayingForArray
{
    for (int i = 0; i < self.plays.count; i ++) {
        [self setNoInPlayingForPerson:self.plays[i]];
    }
}

- (void)setNoInPlayingForPerson:(Person *)person
{
        NSDictionary *dic =  [self belongArrayWithPerson:person];
        int idx = (int)[dic[@"idx"] integerValue];
        if ([dic[belongKey] isEqualToString:belongOfen]) { // 常客
            Person *p =  self.ofens[idx];
            p.inPlaying = NO;
            [self.ofens replaceObjectAtIndex:idx withObject:p];
        }
        else
        {
            Person *p =  self.unOfens[idx];
            p.inPlaying = NO;
            [self.unOfens replaceObjectAtIndex:idx withObject:p];
        }
}


#pragma mark  Cell双击
- (void)cellDoubleTap:(UIGestureRecognizer *)doubleTap
{
   NSInteger tag =  doubleTap.view.tag;
    BOOL shoudAdd = YES;

    if (tag < 100) { // 双击了熟客
        Person * tapPerson =  self.ofens[tag];
   
        if (tapPerson.doneXW == YES) {
            [MiPop show:@"疯了。洗过还要人家洗😂😂😂"];
            return;
        }
        int personIdxInPlays = 0;
        for (int i = 0; i < self.plays.count; i ++) {
           Person *playPerson = self.plays[i];
            if (playPerson.ID == tapPerson.ID) {
                personIdxInPlays = i;
                shoudAdd = NO;
            }
        }
        if (shoudAdd)
        {
            // 熟客下去
            tapPerson.inPlaying = YES;
            [self.ofens replaceObjectAtIndex:tag withObject:tapPerson];
            [self reloadDataForOfenCollectionView];
            [self.plays addObject:tapPerson];
        }
        else
        {
            [self.plays removeObjectAtIndex:personIdxInPlays];
            // 熟客回来
            int idx = (int)[self.ofens indexOfObject:tapPerson];
            tapPerson.inPlaying = NO;
            [self.ofens replaceObjectAtIndex:idx withObject:tapPerson];
            [self btnRecover];
            [self reloadDataForOfenCollectionView];
        }
        
        // 遍历熟客看是否全是在inplaying
        BOOL inplaying = NO;
        for (Person *p in self.ofens) {
            if (p.inPlaying == NO) {
                inplaying = YES;
            }
        }
        (inplaying) ? [self btnRecover] : [self btnNoUse];
        
    }
    else if (tag >= 10000) // 双击了稀客
    {
        Person * tapPerson =  self.unOfens[tag - 10000];
        if (tapPerson.doneXW == YES) {
            [MiPop show:@"疯了。洗过还要人家洗😂😂😂"];
            return;
        }
        // 避免重复加
        int personIdxInPlays = 0;
        for (int i = 0; i < self.plays.count; i ++) {
            Person *playPerson = self.plays[i];
            if (playPerson.ID == tapPerson.ID) {
                shoudAdd = NO;
                personIdxInPlays = i;
            }
        }
        if (shoudAdd)
        {
            // 模糊
            tapPerson.inPlaying = YES;
            [self.unOfens replaceObjectAtIndex:tag-10000 withObject:tapPerson];
            [self.unOfentcollectionView reloadData];
            [self.plays addObject:tapPerson];
        }
        else
        {
            [self.plays removeObjectAtIndex:personIdxInPlays];
            // 熟客回来
            int idx = (int)[self.unOfens indexOfObject:tapPerson];
            tapPerson.inPlaying = NO;
            [self.unOfens replaceObjectAtIndex:idx withObject:tapPerson];
            [self.unOfentcollectionView reloadData];
        }
    }
    else // 双击中间
    {
        Person *p =  self.plays[tag - 1000];
        p.inPlaying = NO;
//        if (p.ofent) {
//            NSUInteger idx = [self.ofens indexOfObject:p];
//            [self.ofens replaceObjectAtIndex:idx withObject:p];
//            [self btnRecover];
//        }
//        else if (p.ofent == NO)
//        {
//            NSUInteger idx = [self.unOfens indexOfObject:p];
//            [self.unOfens replaceObjectAtIndex:idx withObject:p];
//        }
//        else
//        {
             NSLog(@"双击的这个人两个都不属于");
            // 采取遍历比较ID是否相同的方式
            [self setNoInPlayingForPerson:p];
//        }
        [self.plays removeObjectAtIndex:tag - 1000];
        [self.unOfentcollectionView reloadData];
        [self reloadDataForOfenCollectionView];
    }
    
    [self.playCollectionView reloadData];
}

#pragma mark 根据对象ID判断这个对象属于哪个数组并且输出下标
- (NSDictionary *)belongArrayWithPerson:(Person *)person
{
    BOOL isOfent = NO;
    int idx = 0;
    for (int i = 0 ; i < self.ofens.count; i ++) {
        Person *p = self.ofens[i];
        if (p.ID == person.ID) {
            isOfent = YES;  // 是常客
            idx = i;
        }
    }
    if (isOfent == NO) {
        for (int i = 0 ; i < self.unOfens.count; i ++) {
            Person *p = self.unOfens[i];
            if (p.ID == person.ID) {
                isOfent = NO;
                idx = i;
            }
        }
    }
    
    if (isOfent) {
        return @{belongKey : belongOfen ,@"idx" : @(idx)};
    }
    else
    {
        return  @{belongKey : belongUnOfen ,@"idx" : @(idx)};
    }
}

#pragma mark 开的按钮双击
- (void)beginPlayBtnDoubleTap:(UIGestureRecognizer *)doubleTap
{
    if (self.plays.count < 1) {
        [MiPop show:@"2个人都没有。玩蛋蛋？"];
        return;
    }
    PlayViewController *playVc = [[PlayViewController alloc] init];
    playVc.single = YES;
    playVc.playArray  = [self.plays mutableCopy];
    playVc.delegate = self;
    [self presentViewController:playVc animated:YES completion:nil];
}


@end
