//
//  MoreController.m
//  newsyc
//
//  Created by Grant Paul on 3/4/11.
//  Copyright 2011 Xuzz Productions, LLC. All rights reserved.
//

#import "HNKit.h"

#import "MoreController.h"
#import "ProfileController.h"
#import "ProfileHeaderView.h"
#import "SubmissionListController.h"
#import "CommentListController.h"
#import "BrowserController.h"

#import "AppDelegate.h"

@implementation MoreController

- (id)initWithSession:(HNSession *)session_ {
    if ((self = [super init])) {
        session = [session_ retain];
    }

    return self;
}

- (void)dealloc {
    [tableView release];
    [session release];
    
    [super dealloc];
}

- (void)loadView {
    [super loadView];
    
    tableView = [[OrangeTableView alloc] initWithFrame:[[self view] bounds]];
    [tableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [[self view] addSubview:tableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"More"];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    [tableView release];
    tableView = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [tableView setOrange:![[NSUserDefaults standardUserDefaults] boolForKey:@"disable-orange"]];
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)table {
    return 3;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0: return 2;
        case 1: return 2;
        case 2: return 4;
        default: return 0;
    }
}

- (CGFloat)tableView:(UITableView *)table heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 44.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    if ([indexPath section] == 0) {
        if ([indexPath row] == 0) {
            [[cell textLabel] setText:@"Best Submissions"];
        } else if ([indexPath row] == 1) {
            [[cell textLabel] setText:@"Active Discussions"];
        } else if ([indexPath row] == 2) {
            [[cell textLabel] setText:@"Classic View"];
        } else if ([indexPath row] == 3) {
            [[cell textLabel] setText:@"Ask HN"];
        }
    } else if ([indexPath section] == 1) {
        if ([indexPath row] == 0) {
            [[cell textLabel] setText:@"Best Comments"];
        } else if ([indexPath row] == 1) {
            [[cell textLabel] setText:@"New Comments"];
        } 
    } else if ([indexPath section] == 2) {
        if ([indexPath row] == 0) {
            [[cell textLabel] setText:@"Startup News FAQ"];
        } else if ([indexPath row] == 1) {
            [[cell textLabel] setText:@"news:yc homepage"];
        } else if ([indexPath row] == 2) {
            [[cell textLabel] setText:@"@Fenng"];
        }else if ([indexPath row] == 3) {
            [[cell textLabel] setText:@"家庭用药"];
        }
    }
    
    return [cell autorelease];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Submissions";
    } else if (section == 1) {
        return @"Comments";
    } else if (section == 2) {
        return @"Other";
    }
    
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (section == 2) {
        return [NSString stringWithFormat:@"Startup News, version %@.\n\n 基于开源的 news:yc 修改而来 \n如发现任何Bug，请微博反馈给 @Fenng", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
    }
    
    return nil;
}

- (void)tableView:(UITableView *)table didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HNEntryListIdentifier type = nil;
    NSString *title = nil;
    Class controllerClass = nil;
    
    if ([indexPath section] == 0) {
        if ([indexPath row] == 0) {
            type = kHNEntryListIdentifierBestSubmissions;
            title = @"Best Submissions";
            controllerClass = [SubmissionListController class];
        } else if ([indexPath row] == 1) {
            type = kHNEntryListIdentifierActiveSubmissions;
            title = @"Active";
            controllerClass = [SubmissionListController class];
        } else if ([indexPath row] == 2) {
            type = kHNEntryListIdentifierClassicSubmissions;
            title = @"Classic";
            controllerClass = [SubmissionListController class];
        } else if ([indexPath row] == 3) {
            type = kHNEntryListIdentifierAskSubmissions;
            title = @"Ask HN";
            controllerClass = [SubmissionListController class];
        }
    } else if ([indexPath section] == 1) {
        if ([indexPath row] == 0) {
            type = kHNEntryListIdentifierBestComments;
            title = @"Best Comments";
            controllerClass = [CommentListController class];
        } else if ([indexPath row] == 1) {
            type = kHNEntryListIdentifierNewComments;
            title = @"New Comments";
            controllerClass = [CommentListController class];
        }
    } else if ([indexPath section] == 2) {
        if ([indexPath row] == 0) {
            BrowserController *controller = [[BrowserController alloc] initWithURL:[NSURL URLWithString:@"http://dbanotes.net/startup_news.html"]/*kHNFAQURL*/];
            [[self navigationController] pushController:[controller autorelease] animated:YES];
            return;
        } else if ([indexPath row] == 1) {
            BrowserController *controller = [[BrowserController alloc] initWithURL:[NSURL URLWithString:@"http://newsyc.me/"]];
            [[self navigationController] pushController:[controller autorelease] animated:YES];
            return;
        } else if ([indexPath row] == 2) {
            BrowserController *controller = [[BrowserController alloc] initWithURL:[NSURL URLWithString:@"http://weibo.com/Fenng"]];
            [[self navigationController] pushController:[controller autorelease] animated:YES];
            return;
        }else if ([indexPath row] == 3) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/id521635095?mt=8"]];
            return;
        }
    }
    
    HNEntryList *list = [HNEntryList session:session entryListWithIdentifier:type];
    UIViewController *controller = [[controllerClass alloc] initWithSource:list];
    [controller setTitle:title];
    
    if (controllerClass == [SubmissionListController class]) {
        [[self navigationController] pushController:[controller autorelease] animated:YES];
    } else {
        [[self navigationController] pushController:[controller autorelease] animated:YES];
    }
}

AUTOROTATION_FOR_PAD_ONLY

@end
