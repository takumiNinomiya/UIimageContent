//
//  UIImageContent.m
//  rssReader
//
//  Created by takumi on 2013/05/10.
//  Copyright (c) 2013年 takumi ninomiya. All rights reserved.
//

#import "UIImageContent.h"

@implementation UIImageContent

-(NSData*)dataContentFile:(NSString*)remoteURL :(NSString*)fileName{
    
    imageRemoteURL = [NSString stringWithString:remoteURL];
    imageFileName = [NSString stringWithString:fileName];
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:fileName ];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL success = [fileManager fileExistsAtPath:dataPath];
    if (success) {
        NSLog(@"load from local");
        NSData *data = [NSData dataWithContentsOfFile:dataPath];
        
        //UIImage *image =  [[UIImage alloc] initWithData:data];
        //UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        //[self.view addSubview:imageView];
        
        return data;
        
    } else {
        
        NSLog(@"load from remote");
        [self loadImageFromRemote:fileName];
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imageRemoteURL,fileName]];
        NSData* imageData = [[NSData alloc] initWithContentsOfURL:url];
        
        return imageData;
        
    }
    
    return NULL;
    
}




- (void)loadImageFromRemote:(NSString*)val
{
    // 読み込むファイルの URL を作成
    //NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",DOMAIN_PATH,IMAGE_PATH,val]];
    
    // 別のスレッドでファイル読み込みをキューに加える
    NSOperationQueue *queue = [NSOperationQueue new];
    NSInvocationOperation *operation = [[NSInvocationOperation alloc]
                                        initWithTarget:self
                                        selector:@selector(loadImage:)
                                        object:val];
    [queue addOperation:operation];
}

// 別スレッドでファイルを読み込む
- (void)loadImage:(NSString *)val
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imageRemoteURL,val]];
    NSData* imageData = [[NSData alloc] initWithContentsOfURL:url];
    
    // 読み込んだらメインスレッドのメソッドを実行
    [self performSelectorOnMainThread:@selector(saveImage:) withObject:imageData waitUntilDone:NO];
}


// ローカルにデータを保存
- (void)saveImage:(NSData *)data
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:imageFileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSLog(@"saveImageFilePath : @%@",dataPath);
    
    BOOL success = [fileManager fileExistsAtPath:dataPath];
    if (success) {
        data = [NSData dataWithContentsOfFile:dataPath];
    } else {
        [data writeToFile:dataPath atomically:YES];
    }
    
    //UIImage *image =  [[UIImage alloc] initWithData:data];
    //UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    //[self.view addSubview:imageView];
}



@end
