


@interface IconDownloader : NSObject
@property (nonatomic, readwrite) NSString *strIconURL;
@property (nonatomic, copy) void (^completionHandler)(UIImage *image);

- (void)startDownload;
- (void)cancelDownload;

@end
