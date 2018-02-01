# DKViewModel

[![CI Status](http://img.shields.io/travis/drinking/DKViewModel.svg?style=flat)](https://travis-ci.org/drinking/DKViewModel)
[![Version](https://img.shields.io/cocoapods/v/DKViewModel.svg?style=flat)](http://cocoapods.org/pods/DKViewModel)
[![License](https://img.shields.io/cocoapods/l/DKViewModel.svg?style=flat)](http://cocoapods.org/pods/DKViewModel)
[![Platform](https://img.shields.io/cocoapods/p/DKViewModel.svg?style=flat)](http://cocoapods.org/pods/DKViewModel)

## M-V-VM中的VM

`DKViewModel`是通过ReactiveObjc框架（原ReactiveCocoa）实现MVVM思想中的ViewModel层。其中`DKListViewModel`封装了iOS中UITableView的常见状态和行为，是一个典型的VM实现。

### 状态变更

`DKRequestStatus`定义了列表的常见状态，通常为网络请求的状态。分别对应枚举`请求未开始`、`加载完成`、 `请求出错`。

通过订阅来响应状态的变化。其中`请求未开始`  、 `请求出错`的常见做法是展示相应的占位图。当接收到`加载完成`、 `没有更多数据`状态时，ViewModel中的`listData`已经完成填充列表数据，只需要reloadData即可完成列表cell的更新。`dataLoaded`提供了详细的数组变化情况，可以针对列表做局部变化，无需reload所有。

````objective-c
     @weakify(self)
    [viewModel subscribePrePorgress:^{
        @strongify(self)
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    } notStarted:^{
        @strongify(self)
        [self updateTableViewStatusText:@"Request not started"];
    } dataLoaded:^(NSArray *list, NSArray *pathsToDelete, NSArray *pathsToInsert, NSArray *pathsToMove, NSArray *destinationPaths) {
        @strongify(self)
        self.tableView.tableFooterView.frame = CGRectZero;
        [self.tableView reloadData];
    } error:^(NSError *error) {
        @strongify(self)
        [self updateTableViewStatusText:@"Request Error!"];
    }];
````

也可以使用简化版本，进行最基础的列表需求。
````objective-c
[viewModel subscribeDataLoaded:^(NSArray *list) {
    do somthing 
} error:^(NSError *error) {
    do somthing        
}]
````

### 下拉刷新和加载更多

`DKListViewModel`内部定义了`pageNum`、`perPage`用来标示当前加载的页码和每页加载的数据量，与框架`MJRefresh`配合使用，可以方便地实现`pageNum`的自增和复原。

```objective-c
self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.tableViewModel refresh];
    }];
    
self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self.tableViewModel nextPage];
    }];
```

### 构建TableViewModel

将网络请求和数据处理通过Block来构造VM实例可以满足大部分的需求。`pageOffset`表示当前已请求数据偏移量，让后端甄别该从何处返回新的数据。最后将处理好的数据和是否还有更多数据的BOOL变量一起以Tuple的形式返回给ViewModel实例，使其可以进行下一步状态更新的操作。

```objective-c
[DKListViewModel instanceWithRequestBlock:^(DKListViewModel *instance,
            id <RACSubscriber> subscriber, NSInteger pageOffset) {  
	  //request data by pageOffset
  	  //transport result as Tuple (NSArray, @(BOOL) to ViewModel 
      [subscriber sendNext:RACTuplePack(array, @(hasMore))];            
}];
	
```

更为复杂的ViewModel通过继承来定制就可以了。

## Installation

DKViewModel is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "DKViewModel"
```

## Author

drinking, pan49@126.com

## License

DKViewModel is available under the MIT license. See the LICENSE file for more info.


