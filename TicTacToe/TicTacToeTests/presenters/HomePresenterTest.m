#import <OCMock/OCMock.h>
#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "HomePresenter.h"
#import "HomeView.h"
#import "HomeViewController.h"

@interface HomePresenterTest : XCTestCase {
  id mockView_;
  id mockViewController_;
  HomePresenter *presenter_;
}

@end

@implementation HomePresenterTest

- (void)setUp {
  [super setUp];

  mockView_ = OCMStrictClassMock([HomeView class]);
  mockViewController_ = OCMStrictClassMock([HomeViewController class]);
  OCMStub([mockViewController_ homeView]).andReturn(mockView_);

  presenter_ = [HomePresenter new];
  [presenter_ setViewController:mockViewController_];
}

- (void)tearDown {
  OCMVerifyAll(mockView_);
  OCMVerifyAll(mockViewController_);

  [super tearDown];
}

- (void)testCreateViewController {
  HomeViewController *viewController = [HomePresenter createViewController];
  XCTAssertNotNil(viewController);

  HomePresenter *presenter = (HomePresenter *) [viewController presenter];
  XCTAssertNotNil(presenter);
}

- (void)testAddTargetsToButtons {
  id mockOButton = OCMStrictClassMock([UIButton class]);
  id mockXButton = OCMStrictClassMock([UIButton class]);
  id mockXOButton = OCMStrictClassMock([UIButton class]);

  OCMStub([mockView_ playOButton]).andReturn(mockOButton);
  OCMStub([mockView_ playXButton]).andReturn(mockXButton);
  OCMStub([mockView_ playXOButton]).andReturn(mockXOButton);

  OCMExpect([mockOButton addTarget:presenter_
                            action:[OCMArg anySelector]
                  forControlEvents:UIControlEventTouchUpInside]);
  OCMExpect([mockXButton addTarget:presenter_
                            action:[OCMArg anySelector]
                  forControlEvents:UIControlEventTouchUpInside]);
  OCMExpect([mockXOButton addTarget:presenter_
                             action:[OCMArg anySelector]
                   forControlEvents:UIControlEventTouchUpInside]);

  [presenter_ viewLoaded];

  OCMVerifyAll(mockOButton);
  OCMVerifyAll(mockXButton);
  OCMVerifyAll(mockXOButton);
}

@end