//
//  FileUtility.m
//  SportzCal
//
//  Created by Sitanshu Joshi on 1/9/14.
//  Copyright (c) 2014 zymrinc. All rights reserved.
//

#import "FileUtility.h"

static FileUtility *utility;

@implementation FileUtility

+(FileUtility *)utility{
    if(!utility){
        utility = [[FileUtility alloc] init];
    }
    return utility;
}

#pragma mark Dicument Path
- (NSString *)documentDirectoryPath{
    @autoreleasepool {
        NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentPath = [searchPaths objectAtIndex:0];
        return documentPath;
    }
}
- (NSURL *)documentDirectoryURL{
    @autoreleasepool {
        NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentPath = [searchPaths objectAtIndex:0];
        return [NSURL fileURLWithPath:documentPath];
    }
}

#pragma mark Create File/Directory
- (void)createDirectory:(NSString *)directoryName atFilePath:(NSString *)filePath {
    @autoreleasepool {
        NSString *filePathAndDirectory = [filePath stringByAppendingPathComponent:directoryName];
        NSError *error;
        if (![[NSFileManager defaultManager] createDirectoryAtPath:filePathAndDirectory withIntermediateDirectories:NO attributes:nil error:&error]){
            NSLog(@"error%@", error);
        }
    }
}
- (void)createFile:(NSString *)name atFolder:(NSString *)folder withString:(NSString *)data{
    @autoreleasepool {
        NSString *filePath = [folder stringByAppendingPathComponent:name];
        if (!data) {
            data = @"/*==============================================================*/";
        }
        [data writeToFile:filePath atomically:TRUE encoding:NSUTF8StringEncoding error:NULL];
    }
}
- (void)createFile:(NSString *)name atFolder:(NSString *)folder withData:(NSData *)data{
    @autoreleasepool {
        NSString *filePath = [folder stringByAppendingPathComponent:name];
        if (data) {
            [data writeToFile:filePath atomically:YES];
        }
    }
}
#pragma mark File Maintaining
- (void) renameFile:(NSString *)oldFileName newFileName:(NSString *)newFileName{
    @autoreleasepool {
        NSError *error;
        NSString *filePath = [[self documentDirectoryPath] stringByAppendingPathComponent:oldFileName];
        NSString *newFilePath = [[self documentDirectoryPath] stringByAppendingPathComponent:newFileName];
        
        // Attempt the move
        if ([[NSFileManager defaultManager] moveItemAtPath:filePath toPath:newFilePath error:&error] != YES)
            NSLog(@"Unable to move file: %@", [error localizedDescription]);
    }
}

- (void) deleteFile:(NSString *)filePath{
    @autoreleasepool {
        NSError *error;
        if ([[NSFileManager defaultManager] removeItemAtPath:filePath error:&error] != YES)
            NSLog(@"Unable to delete file: %@", [error localizedDescription]);
    }
}

#pragma mark Append Str to file
/*
- (void) appendToEndOfFile:(NSString *)stringToAppend FilePath:(NSString *)filePath{
    @autoreleasepool {
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:filePath];
        [fileHandle seekToEndOfFile];
        stringToAppend = [NSString stringWithFormat:@"%@%@\n%@",kSeparator_Dash,[[UtilityMethods utilityMethod] getStringDateFromDate:[NSDate new] inDateFormate:kDT_Formatter_Simple],stringToAppend];
        [fileHandle writeData:[stringToAppend dataUsingEncoding:NSUTF8StringEncoding]];
        [fileHandle closeFile];
    }
}*/

#pragma mark Check Availibility
-(BOOL)checkFileIsExistOnDocumentDirectoryFolder:(NSString *)folder withFileName:(NSString *)file {
    @autoreleasepool {
        BOOL isExist = false;
        NSString* foofile = [folder stringByAppendingPathComponent:file];
        isExist = [[NSFileManager defaultManager] fileExistsAtPath:foofile];
        return isExist;
    }
}
- (BOOL)checkDirectoryExistsAtPath:(NSString *)path isDirectory:(BOOL)isDirectory {
    @autoreleasepool {
        BOOL isthere = false;
        BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory];
        if (exists) {
            /* file exists */
            if (isDirectory) {
                /* file is a directory */
                isthere = true;
            }
        }
        
        return isthere;
    }
}



@end
