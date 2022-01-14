//
//  CACornerMaskExtension.swift
//  MDBCommonUI
//
//

/// Extension to `CACornerMask` with custom computed properties.
public extension CACornerMask {
  static var topLeft: CACornerMask { .layerMinXMinYCorner }
  static var topRight: CACornerMask { .layerMaxXMinYCorner }
  static var bottomLeft: CACornerMask { .layerMinXMaxYCorner }
  static var bottomRight: CACornerMask { .layerMaxXMaxYCorner }

  static var topCorners: CACornerMask { [.topLeft, .topRight] }
  static var bottomCorners: CACornerMask { [.bottomLeft, .bottomRight] }
  static var allCorners: CACornerMask { [.topCorners, .bottomCorners] }

  static var none: CACornerMask { [] }
}
