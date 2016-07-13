


#import <Foundation/Foundation.h>

#import "TFHppleElement.h"

@interface TFHpple : NSObject {
@private
  NSData * data;
  BOOL isXML;
}

- (id) initWithData:(NSData *)theData isXML:(BOOL)isDataXML;
- (id) initWithXMLData:(NSData *)theData;
- (id) initWithHTMLData:(NSData *)theData;

+ (TFHpple *) hppleWithData:(NSData *)theData isXML:(BOOL)isDataXML;
+ (TFHpple *) hppleWithXMLData:(NSData *)theData;
+ (TFHpple *) hppleWithHTMLData:(NSData *)theData;

- (NSArray *) searchWithXPathQuery:(NSString *)xPathOrCSS;
- (TFHppleElement *) peekAtSearchWithXPathQuery:(NSString *)xPathOrCSS;

@property (retain) NSData * data;

@end
