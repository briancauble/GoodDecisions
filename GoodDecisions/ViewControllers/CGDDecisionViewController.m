//
//  CGDDecisionViewController.m
//  GoodDecisions
//
//  Created by Abigail Fritz on 3/6/15.
//  Copyright (c) 2015 Brian Cauble. All rights reserved.
//


#import "CGDDecisionViewController.h"
#import "CGDDecisionInfoCollectionViewCell.h"
#import "DataManager.h"
#import "DecisionHeaderCollectionReusableView.h"
#import "Decision.h"
#import "RatingView.h"
#import "Decision.h"
#import "PFQuery+Local.h"
#import "UIColor+GoodDecisions.h"

@interface CGDDecisionViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, weak) IBOutlet UILabel *decisionPromptLabel;
@property (nonatomic, weak) IBOutlet RatingView *ratingView;
@property (nonatomic, weak) IBOutlet UILabel *decisionSentenceLabel;


@property (nonatomic, strong) NSMutableArray *selectedData;
@property (nonatomic, strong) NSMutableArray *collectionData;

@end



@implementation CGDDecisionViewController


#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.decisionPromptLabel.text =  self.type.defaultReminderPrompt;
    self.collectionData = [@[@[],@[]] mutableCopy];
    self.selectedData = [@[@[],@[]] mutableCopy];

    [self.type findAllInfluencesWithResult:^(NSArray *objects, NSError *error) {
        if (!error) {
            [self.collectionData replaceObjectAtIndex:0 withObject:objects];
            [self.collectionView reloadData];
        }
    }];

    
    [self.type findAllOutcomesWithResult:^(NSArray *objects, NSError *error) {
        if (!error) {
            [self.collectionData replaceObjectAtIndex:1 withObject:objects];
            [self.collectionView reloadData];
        }
    }];
        

    [self updateSentence];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.collectionView.contentInset = (UIEdgeInsets){0.,0.,79.,0.,};
    self.collectionView.scrollIndicatorInsets = (UIEdgeInsets){0.,0.,73.,0.};
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Helpers

-(void)updateSentence{
    
    NSArray * selectedItems = self.collectionView.indexPathsForSelectedItems;
    if (selectedItems.count >1) {
        NSString *what = [[self.selectedData[1] valueForKey:@"name"] componentsJoinedByString:@" and "];
        NSString *why  =  [[self.selectedData[0] valueForKey:@"name"] componentsJoinedByString:@" and "];
        
        if (why && what) {
            self.decisionSentenceLabel.text = [NSString stringWithFormat:@"Because of %@, I %@.", why, what];
        }else{
          self.decisionSentenceLabel.text = @"";
        }
    }else{
        self.decisionSentenceLabel.text = @"";
    }
}

#pragma mark - IBActions

-(IBAction)dismiss:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)saveAndDismiss:(id)sender{
    
    Decision *decision = [Decision new];

    decision.outcomes = self.selectedData[1];
    decision.influences = self.selectedData[0];
    
    
    decision.user = [PFUser currentUser];
    decision.type = self.type;
    decision.score = @(self.ratingView.selectedValue);
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
        if (!error) {
            decision.location = geoPoint;
        }else {
            DDLogWarn(@"%@", error.description);
        }
        [decision saveEventually];
    }];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - CollectionView DataSource 

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.collectionData[section] count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"InfoCell";
    
    CGDDecisionInfoCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    PFObject *object = self.collectionData[indexPath.section][indexPath.item];
    cell.textLabel.text = object[@"name"];
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = 12;
    cell.layer.borderWidth = 2.0;
    cell.layer.borderColor = [[UIColor lightOrangeColor] CGColor];
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    PFObject *object = self.collectionData[indexPath.section][indexPath.item];
    CGSize size =[(NSString*)object[@"name"] sizeWithAttributes:NULL];
    return (CGSize){size.width+40, size.height+12};

}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    DecisionHeaderCollectionReusableView *view = nil;
    if(kind == UICollectionElementKindSectionHeader){
        view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SectionHeader" forIndexPath:indexPath];
        view.titleLabel.text = indexPath.section?@"WHAT DID YOU DO":@"WHY DID YOU DO IT";
    }
    return view;
    
}

#pragma mark - CollectionView Delegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray *currentSelections = [self.selectedData[indexPath.section] mutableCopy];
    [currentSelections addObject:self.collectionData[indexPath.section][indexPath.row]];
    [self.selectedData replaceObjectAtIndex:indexPath.section withObject:currentSelections];
    [self updateSentence];
}



-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray *currentSelections = [self.selectedData[indexPath.section] mutableCopy];
    [currentSelections removeObject:self.collectionData[indexPath.section][indexPath.row]];
    [self.selectedData replaceObjectAtIndex:indexPath.section withObject:currentSelections];
    [self updateSentence];

}

     
     

#pragma mark - Delegate Flow Layout

//-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
//    
//    NSUInteger itemCount = 0;
//    itemCount = [self.collectionData[section] count];
//  
//    
//    CGFloat totalItemWidth = collectionViewLayout.itemSize.width + collectionViewLayout.minimumInteritemSpacing;
//    CGFloat maxWidth = self.collectionView.frame.size.width;
//    CGFloat itemsPerRow =MIN(itemCount, floorf(maxWidth/totalItemWidth)) ;
//    
//    CGFloat rowWidth = itemsPerRow * totalItemWidth;
//    CGFloat xInset = (maxWidth-rowWidth)/2;
//        return (UIEdgeInsets){0,xInset,0,xInset};
//    
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
