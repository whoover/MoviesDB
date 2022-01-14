///
/// @Generated by Mockolo
///

import Foundation
import MDBCommonUI
import MDBComponents
import MDBDataLayer
@testable import MDBMain
import MDBModels
import MDBServices
import MDBUtilities
import NeedleFoundation

public class MoviesListViewInputMock: MoviesListViewInput {
  public init() {}

  public private(set) var setupCallCount = 0
  public var setupHandler: ((MoviesListDataSource<MoviesListSection<MoviesListCellModel>>) -> Void)?
  public func setup(dataSource: MoviesListDataSource<MoviesListSection<MoviesListCellModel>>) {
    setupCallCount += 1
    if let setupHandler = setupHandler {
      setupHandler(dataSource)
    }
  }

  public private(set) var reloadDataCallCount = 0
  public var reloadDataHandler: (() -> Void)?
  public func reloadData() {
    reloadDataCallCount += 1
    if let reloadDataHandler = reloadDataHandler {
      reloadDataHandler()
    }
  }

  public private(set) var reloadCellCallCount = 0
  public var reloadCellHandler: ((IndexPath) -> Void)?
  public func reloadCell(indexPath: IndexPath) {
    reloadCellCallCount += 1
    if let reloadCellHandler = reloadCellHandler {
      reloadCellHandler(indexPath)
    }
  }

  public private(set) var setupWithCallCount = 0
  public var setupWithHandler: ((MoviesListState) -> Void)?
  public func setupWith(state: MoviesListState) {
    setupWithCallCount += 1
    if let setupWithHandler = setupWithHandler {
      setupWithHandler(state)
    }
  }

  public private(set) var endRefreshingCallCount = 0
  public var endRefreshingHandler: (() -> Void)?
  public func endRefreshing() {
    endRefreshingCallCount += 1
    if let endRefreshingHandler = endRefreshingHandler {
      endRefreshingHandler()
    }
  }
}

public class MovieDetailsViewInputMock: MovieDetailsViewInput {
  public init() {}

  public private(set) var setupWithCallCount = 0
  public var setupWithHandler: ((MovieDetailsState) -> Void)?
  public func setupWith(state: MovieDetailsState) {
    setupWithCallCount += 1
    if let setupWithHandler = setupWithHandler {
      setupWithHandler(state)
    }
  }

  public private(set) var setupCallCount = 0
  public var setupHandler: ((MovieRuntimeModel) -> Void)?
  public func setup(movieModel: MovieRuntimeModel) {
    setupCallCount += 1
    if let setupHandler = setupHandler {
      setupHandler(movieModel)
    }
  }

  public private(set) var updateCallCount = 0
  public var updateHandler: ((UIImage) -> Void)?
  public func update(image: UIImage) {
    updateCallCount += 1
    if let updateHandler = updateHandler {
      updateHandler(image)
    }
  }
}

public class MovieDetailsPresenterInputMock: MovieDetailsPresenterInput {
  public init() {}

  public private(set) var interactorDidLoadCallCount = 0
  public var interactorDidLoadHandler: (() -> Void)?
  public func interactorDidLoad() {
    interactorDidLoadCallCount += 1
    if let interactorDidLoadHandler = interactorDidLoadHandler {
      interactorDidLoadHandler()
    }
  }

  public private(set) var handleCallCount = 0
  public var handleHandler: ((MovieDetailsState) -> Void)?
  public func handle(state: MovieDetailsState) {
    handleCallCount += 1
    if let handleHandler = handleHandler {
      handleHandler(state)
    }
  }

  public private(set) var handleOnLoadingStateCallCount = 0
  public var handleOnLoadingStateHandler: (() -> Void)?
  public func handleOnLoadingState() {
    handleOnLoadingStateCallCount += 1
    if let handleOnLoadingStateHandler = handleOnLoadingStateHandler {
      handleOnLoadingStateHandler()
    }
  }

  public private(set) var handleAlertStateWithCallCount = 0
  public var handleAlertStateWithHandler: ((Error) -> Void)?
  public func handleAlertStateWith(error: Error) {
    handleAlertStateWithCallCount += 1
    if let handleAlertStateWithHandler = handleAlertStateWithHandler {
      handleAlertStateWithHandler(error)
    }
  }

  public private(set) var updateCallCount = 0
  public var updateHandler: ((UIImage) -> Void)?
  public func update(image: UIImage) {
    updateCallCount += 1
    if let updateHandler = updateHandler {
      updateHandler(image)
    }
  }
}

public class MoviesListPresenterInputMock: MoviesListPresenterInput {
  public init() {}
  public init(numberOfCells: Int = 0) {
    self.numberOfCells = numberOfCells
  }

  public private(set) var numberOfCellsSetCallCount = 0
  public var numberOfCells: Int = 0 { didSet { numberOfCellsSetCallCount += 1 } }

  public private(set) var interactorDidLoadCallCount = 0
  public var interactorDidLoadHandler: (() -> Void)?
  public func interactorDidLoad() {
    interactorDidLoadCallCount += 1
    if let interactorDidLoadHandler = interactorDidLoadHandler {
      interactorDidLoadHandler()
    }
  }

  public private(set) var resetListCallCount = 0
  public var resetListHandler: (() -> Void)?
  public func resetList() {
    resetListCallCount += 1
    if let resetListHandler = resetListHandler {
      resetListHandler()
    }
  }

  public private(set) var updateCallCount = 0
  public var updateHandler: (([MovieRuntimeModel]) -> Void)?
  public func update(movies: [MovieRuntimeModel]) {
    updateCallCount += 1
    if let updateHandler = updateHandler {
      updateHandler(movies)
    }
  }

  public private(set) var getImagePathCallCount = 0
  public var getImagePathHandler: ((IndexPath) -> (String?))?
  public func getImagePath(indexPath: IndexPath) -> String? {
    getImagePathCallCount += 1
    if let getImagePathHandler = getImagePathHandler {
      return getImagePathHandler(indexPath)
    }
    return nil
  }

  public private(set) var isImageLoadingNeededCallCount = 0
  public var isImageLoadingNeededHandler: ((IndexPath) -> (Bool))?
  public func isImageLoadingNeeded(indexPath: IndexPath) -> Bool {
    isImageLoadingNeededCallCount += 1
    if let isImageLoadingNeededHandler = isImageLoadingNeededHandler {
      return isImageLoadingNeededHandler(indexPath)
    }
    return false
  }

  public private(set) var updateImageCallCount = 0
  public var updateImageHandler: ((UIImage, IndexPath) -> Void)?
  public func update(image: UIImage, indexPath: IndexPath) {
    updateImageCallCount += 1
    if let updateImageHandler = updateImageHandler {
      updateImageHandler(image, indexPath)
    }
  }

  public private(set) var movieModelCallCount = 0
  public var movieModelHandler: ((IndexPath) -> (MovieRuntimeModel?))?
  public func movieModel(indexPath: IndexPath) -> MovieRuntimeModel? {
    movieModelCallCount += 1
    if let movieModelHandler = movieModelHandler {
      return movieModelHandler(indexPath)
    }
    return nil
  }

  public private(set) var handleCallCount = 0
  public var handleHandler: ((MoviesListState) -> Void)?
  public func handle(state: MoviesListState) {
    handleCallCount += 1
    if let handleHandler = handleHandler {
      handleHandler(state)
    }
  }

  public private(set) var handleOnLoadingStateCallCount = 0
  public var handleOnLoadingStateHandler: (() -> Void)?
  public func handleOnLoadingState() {
    handleOnLoadingStateCallCount += 1
    if let handleOnLoadingStateHandler = handleOnLoadingStateHandler {
      handleOnLoadingStateHandler()
    }
  }

  public private(set) var handleAlertStateWithCallCount = 0
  public var handleAlertStateWithHandler: ((Error) -> Void)?
  public func handleAlertStateWith(error: Error) {
    handleAlertStateWithCallCount += 1
    if let handleAlertStateWithHandler = handleAlertStateWithHandler {
      handleAlertStateWithHandler(error)
    }
  }
}

public class MovieDetailsInteractorInputMock: MovieDetailsInteractorInput {
  public init() {}

  public private(set) var viewDidLoadCallCount = 0
  public var viewDidLoadHandler: (() -> Void)?
  public func viewDidLoad() {
    viewDidLoadCallCount += 1
    if let viewDidLoadHandler = viewDidLoadHandler {
      viewDidLoadHandler()
    }
  }

  public private(set) var onAllertDismissedCallCount = 0
  public var onAllertDismissedHandler: (() -> Void)?
  public func onAllertDismissed() {
    onAllertDismissedCallCount += 1
    if let onAllertDismissedHandler = onAllertDismissedHandler {
      onAllertDismissedHandler()
    }
  }

  public private(set) var loadImageIfNeededCallCount = 0
  public var loadImageIfNeededHandler: ((String) -> Void)?
  public func loadImageIfNeeded(path: String) {
    loadImageIfNeededCallCount += 1
    if let loadImageIfNeededHandler = loadImageIfNeededHandler {
      loadImageIfNeededHandler(path)
    }
  }
}

public class MoviesListInteractorDependencyMock: MoviesListInteractorDependency {
  public init() {}
  public init(saveImagesService: ImageSaveServiceProtocol, networkingProvider: NetworkingProviderProtocol, databaseService: DatabaseServiceProtocol) {
    _saveImagesService = saveImagesService
    _networkingProvider = networkingProvider
    _databaseService = databaseService
  }

  public private(set) var saveImagesServiceSetCallCount = 0
  private var _saveImagesService: ImageSaveServiceProtocol! { didSet { saveImagesServiceSetCallCount += 1 } }
  public var saveImagesService: ImageSaveServiceProtocol {
    get { _saveImagesService }
    set { _saveImagesService = newValue }
  }

  public private(set) var networkingProviderSetCallCount = 0
  private var _networkingProvider: NetworkingProviderProtocol! { didSet { networkingProviderSetCallCount += 1 } }
  public var networkingProvider: NetworkingProviderProtocol {
    get { _networkingProvider }
    set { _networkingProvider = newValue }
  }

  public private(set) var databaseServiceSetCallCount = 0
  private var _databaseService: DatabaseServiceProtocol! { didSet { databaseServiceSetCallCount += 1 } }
  public var databaseService: DatabaseServiceProtocol {
    get { _databaseService }
    set { _databaseService = newValue }
  }
}

public class MovieDetailsInteractorDependencyMock: MovieDetailsInteractorDependency {
  public init() {}
  public init(saveImagesService: ImageSaveServiceProtocol, networkingProvider: NetworkingProviderProtocol) {
    _saveImagesService = saveImagesService
    _networkingProvider = networkingProvider
  }

  public private(set) var saveImagesServiceSetCallCount = 0
  private var _saveImagesService: ImageSaveServiceProtocol! { didSet { saveImagesServiceSetCallCount += 1 } }
  public var saveImagesService: ImageSaveServiceProtocol {
    get { _saveImagesService }
    set { _saveImagesService = newValue }
  }

  public private(set) var networkingProviderSetCallCount = 0
  private var _networkingProvider: NetworkingProviderProtocol! { didSet { networkingProviderSetCallCount += 1 } }
  public var networkingProvider: NetworkingProviderProtocol {
    get { _networkingProvider }
    set { _networkingProvider = newValue }
  }
}

public class MoviesListInteractorInputMock: MoviesListInteractorInput {
  public init() {}

  public private(set) var movieModelCallCount = 0
  public var movieModelHandler: ((IndexPath) -> (MovieRuntimeModel?))?
  public func movieModel(indexPath: IndexPath) -> MovieRuntimeModel? {
    movieModelCallCount += 1
    if let movieModelHandler = movieModelHandler {
      return movieModelHandler(indexPath)
    }
    return nil
  }

  public private(set) var loadImageIfNeededCallCount = 0
  public var loadImageIfNeededHandler: ((IndexPath) -> Void)?
  public func loadImageIfNeeded(indexPath: IndexPath) {
    loadImageIfNeededCallCount += 1
    if let loadImageIfNeededHandler = loadImageIfNeededHandler {
      loadImageIfNeededHandler(indexPath)
    }
  }

  public private(set) var cancelLoadingImageIfNeededCallCount = 0
  public var cancelLoadingImageIfNeededHandler: ((IndexPath) -> Void)?
  public func cancelLoadingImageIfNeeded(indexPath: IndexPath) {
    cancelLoadingImageIfNeededCallCount += 1
    if let cancelLoadingImageIfNeededHandler = cancelLoadingImageIfNeededHandler {
      cancelLoadingImageIfNeededHandler(indexPath)
    }
  }

  public private(set) var viewDidLoadCallCount = 0
  public var viewDidLoadHandler: (() -> Void)?
  public func viewDidLoad() {
    viewDidLoadCallCount += 1
    if let viewDidLoadHandler = viewDidLoadHandler {
      viewDidLoadHandler()
    }
  }

  public private(set) var onAllertDismissedCallCount = 0
  public var onAllertDismissedHandler: (() -> Void)?
  public func onAllertDismissed() {
    onAllertDismissedCallCount += 1
    if let onAllertDismissedHandler = onAllertDismissedHandler {
      onAllertDismissedHandler()
    }
  }

  public private(set) var loadNextPageIfPossibleCallCount = 0
  public var loadNextPageIfPossibleHandler: (() -> Void)?
  public func loadNextPageIfPossible() {
    loadNextPageIfPossibleCallCount += 1
    if let loadNextPageIfPossibleHandler = loadNextPageIfPossibleHandler {
      loadNextPageIfPossibleHandler()
    }
  }

  public private(set) var resetListCallCount = 0
  public var resetListHandler: (() -> Void)?
  public func resetList() {
    resetListCallCount += 1
    if let resetListHandler = resetListHandler {
      resetListHandler()
    }
  }

  public private(set) var requestNextPageIfNeededCallCount = 0
  public var requestNextPageIfNeededHandler: ((IndexPath) -> Void)?
  public func requestNextPageIfNeeded(lastDisplayed indexPath: IndexPath) {
    requestNextPageIfNeededCallCount += 1
    if let requestNextPageIfNeededHandler = requestNextPageIfNeededHandler {
      requestNextPageIfNeededHandler(indexPath)
    }
  }
}

public class MoviesListPresenterDependencyMock: MoviesListPresenterDependency {
  public init() {}
  public init(localizer: LocalizerProtocol, themeManager: ThemeManagerProtocol) {
    _localizer = localizer
    _themeManager = themeManager
  }

  public private(set) var localizerSetCallCount = 0
  private var _localizer: LocalizerProtocol! { didSet { localizerSetCallCount += 1 } }
  public var localizer: LocalizerProtocol {
    get { _localizer }
    set { _localizer = newValue }
  }

  public private(set) var themeManagerSetCallCount = 0
  private var _themeManager: ThemeManagerProtocol! { didSet { themeManagerSetCallCount += 1 } }
  public var themeManager: ThemeManagerProtocol {
    get { _themeManager }
    set { _themeManager = newValue }
  }
}

public class MovieDetailsPresenterDependencyMock: MovieDetailsPresenterDependency {
  public init() {}
  public init(localizer: LocalizerProtocol, themeManager: ThemeManagerProtocol) {
    _localizer = localizer
    _themeManager = themeManager
  }

  public private(set) var localizerSetCallCount = 0
  private var _localizer: LocalizerProtocol! { didSet { localizerSetCallCount += 1 } }
  public var localizer: LocalizerProtocol {
    get { _localizer }
    set { _localizer = newValue }
  }

  public private(set) var themeManagerSetCallCount = 0
  private var _themeManager: ThemeManagerProtocol! { didSet { themeManagerSetCallCount += 1 } }
  public var themeManager: ThemeManagerProtocol {
    get { _themeManager }
    set { _themeManager = newValue }
  }
}
