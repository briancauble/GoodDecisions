//
//  MinimalDecisionViewController.m
//  GoodDecisions
//
//  Created by Abigail Fritz on 3/6/15.
//  Copyright (c) 2015 Brian Cauble. All rights reserved.
//


#import "MinimalDecisionViewController.h"
#import "WhyCollectionViewCell.h"
#import "DataManager.h"
#import "DecisionHeaderCollectionReusableView.h"
#import "Decision.h"
#import "RatingView.h"

@interface MinimalDecisionViewController ()

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, weak) IBOutlet UILabel *decisionPromptLabel;
@property (nonatomic, weak) IBOutlet RatingView *ratingView;

@property (nonatomic, strong) NSArray *whyData;
@property (nonatomic, strong) NSArray *whatData;

@end


@interface MinimalDecisionViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@end

@implementation MinimalDecisionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if(!self.type){
        self.type = [DecisionType objectWithoutDataWithObjectId:@"QEUzoJRlNC"];
    }
    [self.type fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        self.decisionPromptLabel.text =  self.type.defaultReminderPrompt;
    }];
    PFQuery *whyQuery = [PFQuery queryWithClassName:@"DecisionInfluence"];
    [whyQuery orderByAscending:@"sortIndex"];
    [whyQuery whereKey:@"type" equalTo:self.type];
    [whyQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.whyData = objects;
        [self.collectionView reloadData];
    }];
    
    PFQuery *whatQuery = [PFQuery queryWithClassName:@"DecisionDetail"];
    [whatQuery orderByAscending:@"sortIndex"];
    [whatQuery whereKey:@"type" equalTo:self.type];
    //    [whyQuery whereKey:@"type" containedIn:[DataManager sharedManager].decisionTypes];
    [whatQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.whatData = objects;
        [self.collectionView reloadData];
    }];
    
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.collectionView.contentInset = (UIEdgeInsets){0,0,75,0};
    self.collectionView.scrollIndicatorInsets = (UIEdgeInsets){0,0,75,0};

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions

-(IBAction)dismiss:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)saveAndDismiss:(id)sender{
    
    Decision *decision = [Decision new];

    NSArray * selectedItems = self.collectionView.indexPathsForSelectedItems;

    for (NSIndexPath *indexPath in selectedItems) {
        if (indexPath.section) {
            decision.detail = self.whatData[indexPath.item];
        }else{
            decision.influence = self.whyData[indexPath.item];

        }
    }
    
    

    decision.user = [PFUser currentUser];
    decision.type = self.type;
    decision.score = @(self.ratingView.selectedValue);
    [decision saveEventually];
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
        decision.location = geoPoint;
        [decision saveEventually];
    }];

    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - CollectionView DataSource 

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return section?[self.whatData count]:[self.whyData count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"WhyCell";
    
    WhyCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    PFObject *object = indexPath.section?self.whatData[indexPath.item]:self.whyData[indexPath.item];
    cell.textLabel.text = object[@"name"];
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = 20;
    return cell;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    DecisionHeaderCollectionReusableView *view = nil;
    if(kind == UICollectionElementKindSectionHeader){
        view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SectionHeader" forIndexPath:indexPath];
        view.titleLabel.text = indexPath.section?@"What":@"Why";
    }
    return view;
    
}

#pragma mark - CollectionView Delegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSArray * selectedItems = self.collectionView.indexPathsForSelectedItems;

    for (NSIndexPath * selectedItem in selectedItems) {
        if ((selectedItem.section == indexPath.section) && (selectedItem.row != indexPath.item)) {
            [self.collectionView deselectItemAtIndexPath:selectedItem animated:NO];
        }
    }

}


#pragma mark - Delegate Flow Layout

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    NSUInteger itemCount = 0;
    if (!section) {
        itemCount = [self.whyData count];
    }else{
        itemCount = [self.whatData count];
    }
    CGFloat totalItemWidth = collectionViewLayout.itemSize.width + collectionViewLayout.minimumInteritemSpacing;
    CGFloat maxWidth = self.collectionView.frame.size.width;
    CGFloat itemsPerRow =MIN(itemCount, floorf(maxWidth/totalItemWidth)) ;
    
    CGFloat rowWidth = itemsPerRow * totalItemWidth;
    CGFloat xInset = (maxWidth-rowWidth)/2;
        return (UIEdgeInsets){0,xInset,0,xInset};
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
