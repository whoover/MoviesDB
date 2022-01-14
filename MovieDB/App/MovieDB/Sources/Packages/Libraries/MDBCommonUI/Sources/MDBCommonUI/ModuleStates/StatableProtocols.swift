import UIKit

protocol ContentStatable {
  func enterContentState()
}

protocol EmptyStatable {
  func enterEmptyState(_ string: String)
}

protocol LoadingStatable {
  func enterLoadingState(_ string: String)
}

protocol ErrorStatable {
  func enterErrorState(_ error: Error)
}
