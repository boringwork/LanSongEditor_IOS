//
//  LanSongFileUtil.h
//  testIOS
//
//  Created by sno on 16/7/22.
//  Copyright © 2016年 sno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LanSongFileUtil : NSObject

/**
 *  判断文件是否存在
 *
 *  @param str 文件路径
 *
 *  @return 存在返回YES,不存在返回NO
 */
+ (BOOL) fileExist:(NSString *)str;

/**
 *  判断文件数组是否存在, 需要array中的所有都是NSString类型的数据.
 *
 *  @param array 里面都是 NSString的数组.
 *
 *  @return 存在返回YES,不存在返回NO
 */
+ (BOOL) fileArrayExist:(NSMutableArray *)array;
/**
 * @brief 创建文件夹
 *
 * @param createDir 创建文件夹路径
 * @
 */
+ (void)createDir:(NSString *)createDir;

/**
 在Docments文件夹下创建新的文件夹;

 @param dirName 文件夹名字
 @return 返回完整的文件夹路径;
 */
+ (NSString *)createDirInDocuments:(NSString *)dirName;
//在指定的文件夹下.
/**
 *  生成这个文件名字, 并不真正在文件夹里创建文件
 *
 *  @param dir    文件夹全路径, 可以是NSHome
 *  @param suffix 后缀名字
 *
 *  @return 返回创建好的文件路径字符串.
 */
+ (NSString *) genNewFileName:(NSString *)dir suffix:(NSString *)suffix;

/**
 *  在默认的文件夹下创建一个路径字符串,
 *
 *  @param suffix 后缀名字
 *
 *  @return  返回创建好的文件路径字符串.
 */
+ (NSString *) genFileNameWithSuffix:(NSString *)suffix;


/**
 *  从文件路劲中获取文件名字.
 
    源字符串   --->     结果字符串
//    “/tmp/scratch.tiff”   --->     “scratch.tiff”
//    “/tmp/scratch”   --->     “scratch”
//    “/tmp/”   --->     “tmp”
//    “scratch”   --->     “scratch”
//    “/”   --->     “/”
 *  @param filePath 文件路径
 *  @return 字符串名字或NULL;
 */
+ (NSString *)getfileNameFromPath:(NSString *)filePath;
/**
 从输入字符串中,得到文件后缀

 @param filePath 输入字符串, 如xxx.mp4;  /tmp/xxx/xxx/test.mp4;
 @return
 */
+(NSString *)getFileExtension:(NSString *)inputText;


/**
 返回文件名, 不带后缀; xxx.mp4返回xxx
 注意不要有路径, 是一个单纯的含后缀的文件名字;
 */
+(NSString *)getStringDeleteExtension:(NSString *)fileName;


/**
 获取dir的路径;
 如 "/tmp/xx/323/ttt.m4a; 则返回 /tmp/xx/323
 */
+(NSString *)getDirPath:(NSString *)inputPath;
/**
 *  删除文件,
 *
 *  @param filepath 文件的完整路径
 */
+(void)deleteFile:(NSString *)filepath;

/**
 删除文件字符串数组中的所有文件.
 */
+(void)deleteAllFiles:(NSMutableArray *)fileArray;

/**
 删除SDK默认文件夹中的所有文件
 */
+(void)deleteAllSDKFiles;
/**
 *  删除文件夹(这里仅仅是删除文件夹里的所有文件,并不删除文件夹名字)
 *
 *  @param dir 文件夹路径
 */
+(void)deleteDir:(NSString *)dir;


/**
 *  返回SDK默认的文件夹, 默认是当前APP的NSDocumentDirectory下创建一个lansongBox文件夹,然后返回.
 *
 *  @return 文件夹路径,
 */
+(NSString *)Path;
/**
 *  在默认的路径中,创建一个mp4路径(只是路径字符串, 没有文件生成)
 *
 *  @return 路径的字符串
 */
+(NSString *)genTmpMp4Path;
/**
 *  创建一个m4a路径(只是路径, 没有文件生成)
 *
 *  @return 路径的字符串
 */
+(NSString *)genTmpM4APath;
/**
 *  创建一个m4a路径(只是路径, 没有文件生成)
 *
 *  @return 路径的字符串
 */
+(NSString *)genTmpMp3Path;

/**
 *
 *  在当前app下Documents文件夹里,创建一个指定文件名的路径
 *  @param filename 返回该路径的字符串(只是生成一个字符串, 没有真正生成文件)
 *
 *  @return 路径字符串
 */
+(NSString *)genFilePathWithName:(NSString *)filename;

/**
 *  把URL转换为 实际的路径字符串
 *
 *  @param url
 *
 *  @return
 */
+(NSString *)urlToFileString:(NSURL *)url;

/**
 *  把字符串绝对路径, 转换为 URL类型路径
 *
 *  @param path
 *
 *  @return
 */
+(NSURL *)filePathToURL:(NSString *)path;

/**
 *  拷贝资源文件到Documents文件夹下的指定的文件夹;
 * 资源文件是这样的:
 NSString * srcPath = [[NSBundle mainBundle] pathForResource:@"aobama" ofType:@"json"];
 目标文件夹是创建在:Documents的子文件夹;如拷贝到Documents下, 则dstDir=@"";
 
 *  @param name   资源名字
 *  @param fix    后缀
 *  @param dstDir 目标文件夹 可以是@"" 或者 @"image" 或者@"img/2/2/3/"
 *
 *  @return 拷贝成功,返回目标文件名;失败返回NULL
 */
+(NSString *) copyResourceFile:(NSString *)name withSubffix:(NSString *)fix dstDir:(NSString *)dstDir;

/**
 *  拷贝文件
 *  内部是直接拷贝, 阻塞执行;
 
 *  @param sourcePath 源路径
 *  @param toPath     目标文件路径(包含目标文件名)
 *
 *  @return 如果拷贝成功,返回YES,失败返回NO, (可能是内存不足导致失败)
 */
+ (BOOL)copyFile:(NSString *)sourcePath toPath:(NSString *)toPath;

/**
 保存图片, 默认是保存到docment下的lansongBox文件夹中;

 @param image 图片
 @return 保存成功,返回路径;失败,返回nil;
 */
+(NSString *)saveUIImage:(UIImage *)image;


/**
 把图片保存到相册;
 */
+(void)saveUIImageToPhotosAlbum:(UIImage *)image;

+ (UIImage *)createImageWithSingleColor:(UIColor *)color size:(CGSize)size;

/**
 关于获取文件名:
 NSString* index=@"/Users/junzoo/Library/Application Support/iPhone Simulator/7.0.3/Applications/63925F20-AF97-4610-AF1C-B6B4157D1D92/Documents/DownLoad/books/2013_50.zip";
 
 
 对路径截取的9种操作
 NSLog(@"1=%@",[index lastPathComponent]);
 NSLog(@"2=%@",[index stringByDeletingLastPathComponent]);
 NSLog(@"3=%@",[index pathExtension]);
 NSLog(@"4=%@",[index stringByDeletingPathExtension]);
 NSLog(@"5=%@",[index stringByAbbreviatingWithTildeInPath]);
 NSLog(@"6=%@",[index stringByExpandingTildeInPath]);
 NSLog(@"7=%@",[index stringByStandardizingPath]);
 NSLog(@"8=%@",[index stringByResolvingSymlinksInPath]);
 NSLog(@"9=%@",[[index lastPathComponent] stringByDeletingPathExtension]);
 
 处理后的结果:
 1=2013_50.zip
 2=/Users/junzoo/Library/Application Support/iPhone Simulator/7.0.3/Applications/63925F20-AF97-4610-AF1C-B6B4157D1D92/Documents/DownLoad/books
 3=zip
 4=/Users/junzoo/Library/Application Support/iPhone Simulator/7.0.3/Applications/63925F20-AF97-4610-AF1C-B6B4157D1D92/Documents/DownLoad/books/2013_50
 5=~/Documents/DownLoad/books/2013_50.zip
 6=/Users/junzoo/Library/Application Support/iPhone Simulator/7.0.3/Applications/63925F20-AF97-4610-AF1C-B6B4157D1D92/Documents/DownLoad/books/2013_50.zip
 7=/Users/junzoo/Library/Application Support/iPhone Simulator/7.0.3/Applications/63925F20-AF97-4610-AF1C-B6B4157D1D92/Documents/DownLoad/books/2013_50.zip
 8=/Users/junzoo/Library/Application Support/iPhone Simulator/7.0.3/Applications/63925F20-AF97-4610-AF1C-B6B4157D1D92/Documents/DownLoad/books/2013_50.zip
 9=2013_50
 */
@end
