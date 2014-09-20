//
//  SOLabel.h
//  Couchfunk
//
//  Created by Cathleen Scharfe on 08.11.12.
//
//

#import <UIKit/UIKit.h>

typedef enum
{
    VerticalAlignmentTop = 0, // default
    VerticalAlignmentMiddle,
    VerticalAlignmentBottom,
} VerticalAlignment;

@interface SOLabel : UILabel
{
@private
    VerticalAlignment _verticalAlignment;
}

@property (nonatomic, readwrite, assign) VerticalAlignment verticalAlignment;

@end