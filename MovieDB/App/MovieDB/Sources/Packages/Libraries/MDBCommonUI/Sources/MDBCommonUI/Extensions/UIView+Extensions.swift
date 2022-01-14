//
//  UIViewExtensions.swift
//  MDBCommonUI
//
//

import UIKit

/// Extension to make snapshots
public extension UIView {
  func snapshotImage(opaque: Bool = true,
                     scale: CGFloat = UIScreen.main.scale * 2,
                     afterScreenUpdates: Bool = false) -> UIImage?
  {
    UIGraphicsBeginImageContextWithOptions(bounds.size, opaque, scale)
    drawHierarchy(in: bounds, afterScreenUpdates: afterScreenUpdates)
    let snapshotImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return snapshotImage
  }

  func snapshotView(opaque: Bool = true,
                    scale: CGFloat = UIScreen.main.scale * 2,
                    afterScreenUpdates: Bool = false) -> UIView?
  {
    if let snapshotImage = snapshotImage(opaque: opaque, scale: scale, afterScreenUpdates: afterScreenUpdates) {
      return UIImageView(image: snapshotImage)
    } else {
      return nil
    }
  }

  func snapshotLayer(opaque: Bool = true,
                     scale: CGFloat = UIScreen.main.scale * 2) -> UIImage?
  {
    UIGraphicsBeginImageContextWithOptions(bounds.size, opaque, scale)
    guard let context = UIGraphicsGetCurrentContext() else {
      return nil
    }
    layer.render(in: context)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    return image
  }
}

public extension UIView {
  /// Метод делает размытую UIImage из текущей вьюхи.
  /// - Parameter radius: Позволяет регулировать степерь размытия radius = pt.
  /// - Returns: Возвращает размытую вьюху в виде UIImage.
  func blur(radius: CGFloat) -> UIImage? {
    guard let blur = CIFilter(name: "CIGaussianBlur"),
          let image = snapshotImage()
    else {
      return nil
    }

    blur.setValue(CIImage(image: image), forKey: kCIInputImageKey)
    blur.setValue(radius, forKey: kCIInputRadiusKey)

    let ciContext = CIContext(options: nil)

    guard let result = blur.value(forKey: kCIOutputImageKey) as? CIImage,
          let cgImage = ciContext.createCGImage(result, from: bounds)
    else {
      return nil
    }

    return UIImage(cgImage: cgImage)
  }

  /// Упрощенный способ закруглить только определенные края вьюхи
  /// - Parameters:
  ///   - corners: перечисление нужных углов закругления (пример: [.topLeft, .topRight])
  ///   - radius: радиус закругления
  func roundingCorners(corners: CACornerMask, radius: CGFloat) {
    layer.cornerRadius = radius
    layer.maskedCorners = corners
    clipsToBounds = true
  }

  func findAll<T: UIView>() -> [T] {
    var views: [T] = []

    if let neededView = self as? T {
      views.append(neededView)
    }

    func findAllRecursively(view: UIView, array: inout [T]) {
      for subview in view.subviews {
        if let neededView = subview as? T {
          array.append(neededView)
        }

        findAllRecursively(view: subview, array: &array)
      }
    }

    findAllRecursively(view: self, array: &views)

    return views
  }
}
