//
//  FileUtility.h
//  SportzCal
//
//  Created by Sitanshu Joshi on 1/9/14.
//  Copyright (c) 2014 zymrinc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileUtility : NSObject

//Static Object of Single-Ton
+ (FileUtility *)utility;

#pragma mark Get Document Path
- (NSString *) documentDirectoryPath;
- (NSURL *) documentDirectoryURL;

#pragma mark modification operation
/**
 *  This method will rename file at specific path
 *  We just need to specify the old file name which we want to rename and new file name.
 *
 *  @param oldFileName
 *  @param newFileName
 */
- (void) renameFile:(NSString *)oldFileName newFileName:(NSString *)newFileName;
/**
 *  This will delate the file from the path
 *
 *  @param filePath
 */
- (void) deleteFile:(NSString *)filePath;
/**
 *  This method will append text to end of file
 *  We need to specify the text we want to append and file path
 *
 *  @param stringToAppend
 *  @param filePath
 */

#pragma mark Craete Dirctory/File
/**
 *  This method will create file at specific path
 *  We need to specify file name and path at which we need create file.
 *  We also need to specify the data we want to write to file.
 *
 *  @param name
 *  @param folder
 *  @param data
 */
- (void)createFile:(NSString *)name atFolder:(NSString *)folder withString:(NSString *)data;
/**
 *  This will craete file with file name, folder path & NSData given as parameter.
 *
 *  @param name
 *  @param folder
 *  @param data
 */
- (void)createFile:(NSString *)name atFolder:(NSString *)folder withData:(NSData *)data;
/**
 *  This method will create directory at specific path
 *  We need to specify directory name and path at which you need create directory.
 *
 *  @param directoryName
 *  @param filePath
 */
- (void)createDirectory:(NSString *)directoryName atFilePath:(NSString *)filePath;

#pragma mark Check Availibility
/**
 *  This will check availibility of file.
 *
 *  @param folder
 *  @param file
 *
 *  @return idFileExistOrNot
 */
-(BOOL)checkFileIsExistOnDocumentDirectoryFolder:(NSString *)folder withFileName:(NSString *)file;
/**
 *  This will check that given file is directory or not.
 *
 *  @param path
 *  @param isDirectory 
 */
- (BOOL)checkDirectoryExistsAtPath:(NSString *)path isDirectory:(BOOL )isDirectory;


@end
