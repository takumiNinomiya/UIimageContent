//
//  UIImageContent.h
//  rssReader
//
//  Created by takumi on 2013/05/10.
//  Copyright (c) 2013年 takumi ninomiya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImageContent : NSObject{
    
    NSString *imageFileName;
    NSString *imageRemoteURL;
    
}

-(NSData*)dataContentFile:(NSString*)remoteURL :(NSString*)fileName;
    
@end
