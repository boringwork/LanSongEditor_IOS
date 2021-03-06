//
//  AEPreviewVC2.m
//  LanSongEditor_all
//
//  Created by sno on 2018/8/28.
//  Copyright © 2018 sno. All rights reserved.
//

#import "AEPreviewVC2.h"

@interface AEPreviewVC2 ()
{
    DrawPadAEPreview *aePreview;
    DrawPadAEExecute *aeExecute;
    
    LanSongView2 *lansongView;
    BitmapPen *bmpPen;
    CGSize drawpadSize;
    VideoPen *videoPen;
    
    UILabel *labProgress;
    
    //-------Ae中的素材
    
    NSURL *bgVideoURL;
    
    NSURL *mvColor;
    NSURL *mvMask;
    
    NSString *jsonPath;
    
    UIImage *jsonImage0;
    UIImage *jsonImage1;
    UIImage *jsonImage3;
    
}
@end

@implementation AEPreviewVC2

- (void)viewDidLoad {
    [super viewDidLoad];
     self.view.backgroundColor=[UIColor lightGrayColor];
    
    bgVideoURL=nil;
    jsonImage0=nil;
    jsonPath=nil;
    bgVideoURL=nil;
    mvMask=nil;
    mvColor=nil;
    
    [self createData];
    [self startAEPreview:NO];
    
    
    UIView *view=[self newButton:lansongView index:201 hint:@"替换图片"];
    view=[self newButton:view index:202 hint:@"预览+实时编码"];
    view=[self newButton:view index:203 hint:@"后台处理(另一种形式)"];
    
    
    //显示进度;
    labProgress=[[UILabel alloc] init];
    labProgress.textColor=[UIColor redColor];
    [self.view addSubview:labProgress];
    
    CGSize size=self.view.frame.size;
    [labProgress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(view.mas_bottom);
        make.left.mas_equalTo(view.mas_left);
        make.size.mas_equalTo(CGSizeMake(size.width, 40));
    }];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [self stopAeExecute];
    [self stopAePreview];
}
/**
 准备各种素材
 */
-(void)createData
{
    
//    bgVideoURL=[[NSBundle mainBundle] URLForResource:@"aobamaEx" withExtension:@"mp4"];
//    jsonImage0=[LSTODOImageUtil createImageWithText:@"演示微商小视频,文字可以任意修改,可以替换为图片,可以替换为视频;" imageSize:CGSizeMake(255, 185)];
//    NSString *jsonName=@"aobama";
//    jsonPath=[LanSongFileUtil copyResourceFile:jsonName withSubffix:@"json" dstDir:jsonName];
//
//
//    mvColor=[[NSBundle mainBundle] URLForResource:@"ao_color" withExtension:@"mp4"];
//    mvMask = [[NSBundle mainBundle] URLForResource:@"ao_mask" withExtension:@"mp4"];
  
    
    NSString *jsonName=@"zaoan";
    mvColor=[[NSBundle mainBundle] URLForResource:@"zaoan_mvColor" withExtension:@"mp4"];
    mvMask=[[NSBundle mainBundle] URLForResource:@"zaoan_mvMask" withExtension:@"mp4"];
    jsonPath=[LanSongFileUtil copyResourceFile:jsonName withSubffix:@"json" dstDir:jsonName];
    jsonImage0=[UIImage imageNamed:@"zaoan"];
    
}
-(void)startAEPreview:(BOOL)isEncode
{
    [self stopAePreview];
    [self stopAeExecute];
    
    if(bgVideoURL!=nil){
         aePreview=[[DrawPadAEPreview alloc] initWithURL:bgVideoURL];
    }else{
        aePreview=[[DrawPadAEPreview alloc] init];
    }
   
    LOTAnimationView *lottieView=[aePreview addAEJsonPath:jsonPath];
    
    
    [lottieView updateImageWithKey:@"image_0" image:jsonImage0];
//    [lottieView updateVideoImageWithKey:@"image_0" url:sampleURL];
//
//    BOOL ret=[lottieView setVideoImageFrameBlock:@"image_0" updateblock:^UIImage *(NSString *imgId, CGFloat framePts, UIImage *image) {
//        return image;
//    }];
    
    
    
    drawpadSize=aePreview.drawpadSize;  //容器大小,应该在增加图层后获取;
    
    //创建显示窗口
    CGSize size=self.view.frame.size;
    lansongView=[LanSongUtils createLanSongView:size drawpadSize:drawpadSize];
    [self.view addSubview:lansongView];
    [aePreview addLanSongView:lansongView];
    
     if(mvColor!=nil && mvMask!=nil){
         [aePreview addMVPen:mvColor withMask:mvMask];
     }
    
    
    __weak typeof(self) weakSelf = self;
    [aePreview setProgressBlock:^(CGFloat progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf drawpadProgress:progress];
        });
       
    }];
    
    [aePreview setCompletionBlock:^(NSString *path) {
            if(isEncode==NO){
                  dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf startAEPreview:NO];  //如果没有编码,则让他循环播放
                      });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf drawpadCompleted:path];
                });
            }
    }];
    videoPen=aePreview.videoPen;
    //开始执行,并编码
    if(isEncode){
       [aePreview startWithEncode];
    }else{
        [aePreview start];
    }
}

/**
 后台执行
 */
-(void)startAeExecute
{
    [self stopAePreview];
    [self stopAeExecute];
    
    if(bgVideoURL!=nil){
         aeExecute=[[DrawPadAEExecute alloc] initWithURL:bgVideoURL];
    }else{
        aeExecute=[[DrawPadAEExecute alloc] init];
    }
    //增加lottie层
    if(jsonPath!=nil){
        LOTAnimationView *lottieView=[aeExecute addAEJsonPath:jsonPath];
        if(jsonImage0!=nil){
            [lottieView updateImageWithKey:@"image_0" image:jsonImage0];
        }
        // [lottieView updateImageWithKey:@"image_1" image:jsonImage1];  //增加其他各种图片;
    }
    
    //再增加mv图层;
    if(mvColor!=nil && mvMask!=nil){
        [aeExecute addMVPen:mvColor withMask:mvMask];
    }
    
    //开始执行
    __weak typeof(self) weakSelf = self;
    [aeExecute setProgressBlock:^(CGFloat progess) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf drawpadProgress:progess];
        });
    }];
    
    [aeExecute setCompletionBlock:^(NSString *dstPath) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf drawpadCompleted:dstPath];
        });
    }];
    [aeExecute start];
}
-(void)stopAePreview
{
    if (aePreview!=nil) {
        [aePreview cancel];
        aePreview=nil;
    }
}
-(void)stopAeExecute
{
    if (aeExecute!=nil) {
        [aeExecute cancel];
        aeExecute=nil;
    }
}

-(void)drawpadProgress:(CGFloat) progress
{
    if(aePreview!=nil){
        int percent=(int)(progress*100/aePreview.duration);
        labProgress.text=[NSString stringWithFormat:@"当前进度 %f,百分比是:%d",progress,percent];
    }else if(aeExecute!=nil){
        int percent=(int)(progress*100/aeExecute.duration);
        labProgress.text=[NSString stringWithFormat:@"当前进度 %f,百分比是:%d",progress,percent];
    }else{
    }
}
-(void)drawpadCompleted:(NSString *)path
{
    aeExecute=nil;
    VideoPlayViewController *vce=[[VideoPlayViewController alloc] init];
    vce.videoPath=path;
    [self.navigationController pushViewController:vce animated:NO];
}
-(UIButton *)newButton:(UIView *)topView index:(int)index hint:(NSString *)hint
{
    UIButton *btn=[[UIButton alloc] init];
    btn.tag=index;
    
    [btn setTitle:hint forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    btn.backgroundColor=[UIColor whiteColor];
    
    [btn addTarget:self action:@selector(onClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn];
    
    CGSize size=self.view.frame.size;
    CGFloat padding=size.height*0.04;
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topView.mas_bottom).with.offset(padding);
        make.left.mas_equalTo(self.view.mas_left);
        make.size.mas_equalTo(CGSizeMake(size.width, 50));  //按钮的高度.
    }];
    
    return btn;
}
-(void)onClicked:(UIView *)sender
{
    sender.backgroundColor=[UIColor whiteColor];
    UIViewController *pushVC=nil;
    
    switch (sender.tag) {
        case 201:  //替换图片
        {
            [LanSongUtils showDialog:@"为演示代码简洁, 这里暂时省去选择图片的代码"];
            //  jsonImage0= 图片暂时不变;
            break;
        }
        case 202:  //预览+实时编码
        {
            [self startAEPreview:YES];
            break;
        }
        case 203:  //后台处理(另一种形式)
        {
            [self startAeExecute];
            break;
        }
        default:
            break;
    }
    if (pushVC!=nil) {
        [self.navigationController pushViewController:pushVC animated:YES];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)dealloc
{
    [self stopAeExecute];
    [self stopAePreview];
}
@end
