//
//  KZCityPickerView.m
//  KZCityPicker
//
//  Created by Khazan Gu on 2020/5/16.
//

#import "KZCityPickerView.h"


@interface KZCityPickerView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, copy) NSArray *dataSource;

@property (nonatomic, strong) UITableView *provincesTableView;

@property (nonatomic, strong) UITableView *citysTableView;

@property (nonatomic, assign) NSInteger selectedProvice;

@property (nonatomic, copy) void(^completedHandler)(NSDictionary *provice, NSDictionary *city);

@end

@implementation KZCityPickerView

- (void)selected:(void (^)(NSDictionary * _Nonnull, NSDictionary * _Nonnull))handler {
    
    self.completedHandler = handler;
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self loadJson];
        
        [self initSubviews];
        
    }
    
    return self;
}

- (void)loadJson {
    
    NSBundle *bundle = [NSBundle bundleForClass:[KZCityPickerView class]];
    
    NSString *resourcePath = [bundle resourcePath];

    NSString *bundlePath = [resourcePath stringByAppendingPathComponent:@"KZCityPicker.bundle"];

    NSBundle *currentBundle = [NSBundle bundleWithPath:bundlePath];
        
    NSString *filePath = [currentBundle pathForResource:@"where" ofType:@"json"];

    NSData *fileData = [NSData dataWithContentsOfFile:filePath];
    
    NSError *error;
    
    NSArray *arr = [NSJSONSerialization JSONObjectWithData:fileData options:NSJSONReadingMutableLeaves error:&error];
    
    self.dataSource = arr;
    
}

- (void)initSubviews {
    
    CGFloat width = self.bounds.size.width;
    
    CGFloat height = self.bounds.size.height;
    
    CGFloat viewHeight = 48.0;
    
    CGFloat lineHeight = 1 / [UIScreen mainScreen].scale;
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, height / 2.0)];
    
    [self addSubview:cancelButton];
    
    cancelButton.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    
    [cancelButton addTarget:self action:@selector(disappear) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *completeView = [[UIView alloc] initWithFrame:CGRectMake(0, height / 2.0, width, viewHeight)];
    
    [self addSubview:completeView];
    
    UIButton *completeButton = [[UIButton alloc] initWithFrame:CGRectMake(width - 88.0, 0, 88.0, viewHeight)];
    
    [completeView addSubview:completeButton];
    
    [completeButton addTarget:self action:@selector(complete) forControlEvents:UIControlEventTouchUpInside];
    
    [completeButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"完成" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:20], NSForegroundColorAttributeName: [UIColor blackColor]}] forState:UIControlStateNormal];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, height / 2.0 + viewHeight, width, 1 / [UIScreen mainScreen].scale)];
    
    line.backgroundColor = [UIColor blackColor];
    
    [self addSubview:line];
    
    self.provincesTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, height / 2.0 + viewHeight + lineHeight, width / 2.0, height / 2.0 - viewHeight - lineHeight) style:UITableViewStylePlain];
    
    [self addSubview:self.provincesTableView];
    
    self.citysTableView = [[UITableView alloc] initWithFrame:CGRectMake(width / 2.0, height / 2.0 + viewHeight + lineHeight, width / 2.0, height / 2.0 - viewHeight - lineHeight) style:UITableViewStylePlain];
    
    [self addSubview:self.citysTableView];

    self.provincesTableView.delegate = self;
    self.provincesTableView.dataSource = self;
    
    self.citysTableView.dataSource = self;
    self.citysTableView.dataSource = self;
    
    [self.provincesTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"KZPCell"];
    [self.citysTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"KZCCell"];

    self.provincesTableView.showsVerticalScrollIndicator = NO;
    self.citysTableView.showsVerticalScrollIndicator = NO;
    
    [self.provincesTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    [self.citysTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];

}

- (void)disappear {
    
    [self removeFromSuperview];
    
}

- (void)complete {
    
    [self removeFromSuperview];
    
    if (!self.completedHandler) {
        return;
    }
    
    if (self.dataSource.count <= self.selectedProvice) {
        return;
    }
    
    NSDictionary *provice = self.dataSource[self.selectedProvice];
    
    NSArray *districts = [provice objectForKey:@"districts"];

    NSIndexPath *selectedCityIndexPath = [self.citysTableView indexPathForSelectedRow];
    
    if (districts.count <= selectedCityIndexPath.row) {
        return;
    }
    
    NSDictionary *city = districts[selectedCityIndexPath.row];
    
    self.completedHandler(provice, city);
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == self.provincesTableView) {
        
        return self.dataSource.count;
        
    } else if (tableView == self.citysTableView) {
        
        if (self.dataSource.count > self.selectedProvice) {
            
            NSDictionary *provice = self.dataSource[self.selectedProvice];
            
            return [[provice objectForKey:@"districts"] count];
        }
        
    }
    
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    
    if (tableView == self.provincesTableView) {
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"KZPCell" forIndexPath:indexPath];
        
        if (self.dataSource.count > indexPath.row) {
            
            NSDictionary *provice = self.dataSource[indexPath.row];
            
            cell.textLabel.text = [provice objectForKey:@"name"];
            
        }
        
    } else {
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"KZCCell" forIndexPath:indexPath];
        
        if (self.dataSource.count > self.selectedProvice) {
            
            NSDictionary *provice = self.dataSource[self.selectedProvice];
            
            NSArray *districts = [provice objectForKey:@"districts"];
            
            if (districts.count > indexPath.row) {
                
                NSDictionary *city = districts[indexPath.row];

                cell.textLabel.text = [city objectForKey:@"name"];

            }
            
        }

    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.provincesTableView) {
        
        self.selectedProvice = indexPath.row;
        
        [self.citysTableView reloadData];
        
        [self.citysTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
        
    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
