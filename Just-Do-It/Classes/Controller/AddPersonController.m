//
//  AddPersonController.m
//  JustDoIt
//
//  Created by apple on 16/1/26.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "AddPersonController.h"
#import "MiActionSheet.h"
#import "Person.h"
#import <AVFoundation/AVFoundation.h>
#import "MiHeader.h"


@interface AddPersonController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UIButton *iconBtn;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;
@property (weak, nonatomic) IBOutlet UIButton *doneBtn;

// 录音相关
@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic, strong) CADisplayLink *link;
@property (nonatomic, assign) double slientDuration;
@property (weak, nonatomic) IBOutlet UIView *line;

// 其他
@property (nonatomic, strong) Person *p;
@property(nonatomic,copy)NSString * soundPath;

@end

@implementation AddPersonController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.canDrag = YES;
    self.doneBtn.clipsToBounds = YES;
    self.doneBtn.layer.cornerRadius = 4;
    self.doneBtn.showsTouchWhenHighlighted = YES;
    self.doneBtn.alpha = 0.8;
    self.iconBtn.clipsToBounds = YES;
    self.iconBtn.layer.cornerRadius = self.iconBtn.bounds.size.width * 0.5;

       // 初始化Person对象 和 分配ID
    self.p = [[Person alloc] init];;
    self.p.ID = (int)[USERDEFAULTS integerForKey:ID_Key] + 1;
    [USERDEFAULTS setInteger:self.p.ID forKey:ID_Key];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     [self.doneBtn setBackgroundImage:[self imageWithColor:MiRandomColor]  forState:(UIControlStateNormal)];
    [self.doneBtn setBackgroundImage:[self imageWithColor:MiRandomColor]  forState:(UIControlStateHighlighted)];
//    self.segment.backgroundColor = MiRandomColor;
    self.segment.tintColor = MiRandomColor;
    self.line.backgroundColor = MiRandomColorRGBA(0.8);
    
}
#pragma mark 颜色变图片
- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark 完成
- (IBAction)done:(id)sender {

 // 判断各种东西写完了没。
    //1.
//    if (!self.soundPath) {
//         NSLog(@"没录音");
//        return;
//    }
    if (!self.nameTF.text.length) {
        [MiPop show:@"没名字，搞毛？"];
        return;
    }
    if (!self.iconBtn.currentImage) {
        [MiPop show:@"没头像，玩毛线？"];
        return;
    }

    //  名字 图片 身份 赋值
    self.p.name = self.nameTF.text;
    self.p.iconImg =  self.iconBtn.currentImage;
    self.p.ofent = !self.segment.selectedSegmentIndex;

    //  通知代理
    [self.delegate AddPersonController:self person:self.p];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark 说话录音
- (IBAction)saying:(id)sender {
     NSLog(@"说话中");
    // 录音URL
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"Mi%d.caf",self.p.ID]]; // 注意格式变了就得下面的采样率就得变
    NSURL *url = [NSURL fileURLWithPath:path];
    
    // 1.创建录音器
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    // 音频格式
    setting[AVFormatIDKey] = @(kAudioFormatAppleIMA4);
    // 音频采样率
    setting[AVSampleRateKey] = @(8000.0);
    // 音频通道数
    setting[AVNumberOfChannelsKey] = @(1);
    // 线性音频的位深度
    setting[AVLinearPCMBitDepthKey] = @(8);
   
    // 录音状态
    AVAudioRecorder *recorder = [[AVAudioRecorder alloc] initWithURL:url settings:setting error:nil];
    
    // 允许测量分贝
    recorder.meteringEnabled = YES;
    
    // 2.缓冲
    [recorder prepareToRecord];
    
    // 3.录音
    [recorder record];
    
    self.recorder = recorder;
    
    // 4.开启定时器
    self.slientDuration = 0;
    [self.link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    
    self.soundPath = path;
    
    
     NSLog(@"path:%@",path);
    
}
#pragma mark 说完
- (IBAction)sayDone:(id)sender {
    NSLog(@"停止说话");
    [self.recorder stop];
    // 停止定时器
    [self.link invalidate];
    self.link = nil;

    // 记录路径
    self.p.soundPath =  self.soundPath ;
}

#pragma mark 定时器方法
- (void)update
{
    // 1.更新录音器的测量值
    [self.recorder updateMeters];
    
    // 2.获得平均分贝
    float power = [self.recorder averagePowerForChannel:0];
    
     NSLog(@"分贝%.f",power);
    
    // 3.如果小于-30, 开始静音
//    if (power < - 30) {
//        //        [self.recorder pause];
//        
//        self.slientDuration += self.link.duration;
//        
//        if (self.slientDuration >= 2) { // 沉默至少2秒钟
//            [self.recorder stop];
//            
//            // 停止定时器
//            [self.link invalidate];
//            self.link = nil;
//            NSLog(@"--------停止录音");
//        }
//    } else {
//        //        [self.recorder record];
//        self.slientDuration = 0;
//        NSLog(@"**********持续说话");
//    }
}


- (void)down
{
    [self back];
}

#pragma mark 回去
- (IBAction)back {
    
    // 1 取消应该将ID--
   NSInteger ID =  [USERDEFAULTS integerForKey:ID_Key];
    ID--;
    [USERDEFAULTS setInteger:ID forKey:ID_Key];
    
    
    // 2. 判断
    [self dismissViewControllerAnimated:YES completion:nil];
}





#pragma mark 头像点击
- (IBAction)iconBtnCilick:(id)sender {
    MiActionSheet *action =  [[MiActionSheet alloc] initWithTitle:nil  cancelButtonTitle:@"取消"  otherButtonTitles:@[@"拍照",@"从手机相册选择"]];
    
    [self.nameTF resignFirstResponder];
    __weak typeof (self)weakSelf =  self;
//  点击了actionSheet的代理方法
    action.titleBtnClick  = ^ (NSInteger index) {
        if (index == 0) { // 点击了拍照
            // 设置为相机模式
            UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                // 代理
                picker.delegate = weakSelf;
                picker.allowsEditing = YES;
                // 类型
                picker.sourceType = sourceType;
                // 显示
                [weakSelf presentViewController:picker animated:YES completion:nil];
            }
        }
        else if(index == 1) // 点击了从手机相册选择
        {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            // 代理
            picker.delegate = weakSelf;
            // 选择后图片可被编辑
            picker.allowsEditing = YES;
            // 类型
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            // 显示
            [weakSelf presentViewController:picker animated:YES completion:nil];
        }
    };
}
#pragma mark - 相册回调
#pragma mark  UIImagePickerController的代理方法
// 点击了选中就会调用
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // 关闭相册界面
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    // 如果是照相
    if(picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        // 拿到照片
        UIImage *img = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil);
        [MiPop show:@"照片已保存至相册，不用谢"];
        
        UIImageOrientation imageOrientation = img.imageOrientation;
        if(imageOrientation!=UIImageOrientationUp)
        {
            // 原始图片可以根据照相时的角度来显示，但UIImage无法判定，于是出现获取的图片会向左转９０度的现象。
            // 以下为调整图片角度的部分
            UIGraphicsBeginImageContext(img.size);
            [img drawInRect:CGRectMake(0, 0, img.size.width, img.size.height)];
            img = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            // 调整图片角度完毕
        }
        
        [self.iconBtn setImage:img forState:(UIControlStateNormal)];
    }
    // 如果是相册
    else if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) // 相机库
    {
        // 拿到图
        UIImage *img = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        
        [self.iconBtn setImage:img forState:(UIControlStateNormal)];
    }
}

//- (void)writeImgSuccess
//{
//    [MiPop show:@"照片已成功写进相册"];
//}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.nameTF resignFirstResponder];
}



@end
