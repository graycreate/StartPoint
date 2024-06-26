//
//  View.swift
//  V2er
//
//  Created by Seth on 2020/6/25.
//  Copyright © 2020 lessmore.io. All rights reserved.
//

import SwiftUI
import Combine


public extension UIEdgeInsets {
  var edgeInset: EdgeInsets {
    return EdgeInsets(top: self.top, leading: self.left, bottom: self.bottom, trailing: self.right)
  }
}

public extension View {
  public func debug(_ force: Bool = true, _ color: Color = .green) -> some View {
    //        print(Mirror(reflecting: self).subjectType)
    return self.modifier(DebugModifier(force, color))
  }
}


struct DebugModifier: ViewModifier {
  private var force: Bool
  private var color: Color
  public init(_ force: Bool = true, _ color: Color) {
    self.force = force
    self.color = color
  }
  
  func body(content: Content) -> some View {
#if DEBUG
    if !isSimulator() && !force {
      content
    } else {
      content
        .border(color, width: 1)
    }
#else
    content
#endif
  }
}

public extension View {
  func navigatable() -> some View {
    self.modifier(NavigationViewModifier())
  }
}

struct NavigationViewModifier: ViewModifier {
  func body(content: Content) -> some View {
    NavigationView {
      content
    }
    .ignoresSafeArea(.container)
    .navigationBarHidden(true)
  }
}

struct RoundedEdgeModifier: ViewModifier {
  var width: CGFloat = 2
  var color: Color = .black
  var cornerRadius: CGFloat = 16.0
  var corners: UIRectCorner
  
  init(radius: CGFloat, corners: UIRectCorner, width: CGFloat, color: Color) {
    self.cornerRadius = radius
    self.width = width
    self.color = color
    self.corners = corners
  }
  
  func body(content: Content) -> some View {
    if cornerRadius == -1 {
      content
        .clipShape(Circle())
        .padding(width)
        .overlay(Circle().stroke(color, lineWidth: width))
    } else {
      content
      //        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        .clipShape(ClipCornerShape(radius: cornerRadius, corners: corners))
        .overlay {
          //          RoundedRectangle(cornerRadius: cornerRadius)
          ClipCornerShape(radius: cornerRadius, corners: corners)
            .stroke(color, lineWidth: width)
            .padding(0)
        }
    }
  }
}


extension UINavigationController: UIGestureRecognizerDelegate {
  override open func viewDidLoad() {
    super.viewDidLoad()
    interactivePopGestureRecognizer?.delegate = self
  }
  
  public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    return viewControllers.count > 1
  }
}


struct KeyboardResponsiveModifier: ViewModifier {
  @State private var offset: CGFloat = 0
  
  func body(content: Content) -> some View {
    content
      .padding(.bottom, offset)
      .onAppear {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notif in
          let value = notif.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
          let height = value.height
          let bottomInset = UIDevice.safeArea.bottom
          withAnimation {
            self.offset = height - (bottomInset)
          }
        }
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { notif in
          withAnimation {
            self.offset = 0
          }
        }
      }
  }
}

extension View {
  func keyboardAware() -> ModifiedContent<Self, KeyboardResponsiveModifier> {
    return modifier(KeyboardResponsiveModifier())
  }
}



struct SizePreferenceKey: PreferenceKey {
  static var defaultValue: CGSize = .zero
  static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}

struct ClipCornerShape: Shape {
  var radius: CGFloat = .infinity
  var corners: UIRectCorner = .allCorners
  
  func path(in rect: CGRect) -> Path {
    let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
    return Path(path.cgPath)
  }
}

public extension View {
  func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
    background{
      GeometryReader { geometryProxy in
        Color.clear
          .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
      }
    }
    .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
  }
  
  func greedyWidth(_ alignment: Alignment = .center) -> some View {
    frame(maxWidth: .infinity, alignment: alignment)
  }
  
  func greedyHeight(_ alignment: Alignment = .center) -> some View {
    frame(maxHeight: .infinity, alignment: alignment)
  }
  
  func greedyFrame(_ alignment: Alignment = .center) -> some View {
    frame(maxWidth: .infinity, maxHeight: .infinity, alignment: alignment)
  }
  
  public func visualBlur(style: UIBlurEffect.Style = .systemMaterial, color: Color = .clear, alpha: CGFloat = 1.0) -> some View {
    return self.background(VEBlur(style: style, bg: color, alpha: alpha))
  }
  
  func forceClickable() -> some View {
    return self.background(Color.almostClear)
  }
  
  func clip(radius: CGFloat = -1,
                   corners: UIRectCorner = [.topLeft, .topRight, .bottomLeft, .bottomRight],
                   strokeSize: CGFloat = 1,
                   strokeColor: Color = Color.border
  ) -> some View {
    self.modifier(RoundedEdgeModifier(radius: radius, corners: corners,
                                      width: strokeSize, color: strokeColor))
  }
  
  func clipCorner(_ radius: CGFloat, corners: UIRectCorner = [.topLeft, .topRight, .bottomLeft, .bottomRight]) -> some View {
    clipShape(ClipCornerShape(radius: radius, corners: corners) )
  }
  
  func hide(_ hide: Bool = true) -> some View {
    self.opacity(hide ? 0.0 : 1.0)
    //        return self.modifier(HideModifier(hide: hide, keepLayout: keepLayout))
  }
  func remove(_ remove: Bool = true) -> some View{
    self.modifier(HideModifier(remove: remove))
  }
  
  func divider(_ opacity: CGFloat = 1.0) -> some View {
    self.modifier(DividerModifier(opacity: opacity))
  }
}

struct HideModifier: ViewModifier {
  let remove: Bool
  
  @ViewBuilder
  func body(content: Content) -> some View {
    if !remove {
      content
    }
  }
}

struct DividerModifier: ViewModifier {
  let opacity: CGFloat
  
  func body(content: Content) -> some View {
    VStack(spacing: 0) {
      content
      Divider()
        .opacity(opacity)
    }
  }
}



public extension Divider {
  func light() -> some View {
    frame(height: 0.2)
  }
}

public enum Visibility: CaseIterable {
  case visible, // view is fully visible
       invisible, // view is hidden but takes up space
       gone // view is fully removed from the view hierarchy
}

public extension View {
  @ViewBuilder func visibility(_ visibility: Visibility) -> some View {
    if visibility != .gone {
      if visibility == .visible {
        self
      } else {
        hidden()
      }
    }
  }
  
  
  //  func hapticOnTap(style: UIImpactFeedbackGenerator.FeedbackStyle = .light) -> some View {
  //    self.onTapGesture {
  //      let impact = UIImpactFeedbackGenerator(style: style)
  //      impact.impactOccurred()
  //    }
  //  }
}

//struct EmptyView: View {
//    var body: some View {
//        Color.clear.frame(width: 0, height: 0)
//    }
//}

public extension LocalizedStringKey {
  static let empty: LocalizedStringKey = ""
}

public extension View {
  func to<Destination: View>(if: Binding<Bool>? = nil, @ViewBuilder destination: () -> Destination, action: (()->Void)? = nil) -> some View {
    self.modifier(NavigationLinkModifider(if: `if`, action: action, destination: destination()))
  }
}

struct NavigationLinkModifider<Destination: View>: ViewModifier {
  var `if`: Binding<Bool>?
  let action: (()->Void)?
  let destination: Destination
  
  func body(content: Content) -> some View {
    Group {
      if `if` == nil {
        NavigationLink {
          destination
        } label: {
          content
        }
      } else {
        NavigationLink(destination: destination, isActive: `if`!) {
          EmptyView()
        }
      }
    }
    .simultaneousGesture(TapGesture().onEnded {
      self.action?()
    })
    
  }
}


public extension View {
  func withHostingWindow(_ callback: @escaping (UIWindow?) -> Void) -> some View {
    self.background(HostingWindowFinder(callback: callback))
  }
}

struct HostingWindowFinder: UIViewRepresentable {
  var callback: (UIWindow?) -> ()
  
  func makeUIView(context: Context) -> UIView {
    let view = UIView()
    DispatchQueue.main.async { [weak view] in
      self.callback(view?.window)
    }
    return view
  }
  
  func updateUIView(_ uiView: UIView, context: Context) {
  }
}


public extension View {
  
  func colorful(
    colors: [Color] = [.titleGradStartColor, .titleGradEndColor],
    startPoint: UnitPoint = .leading,
    endPoint: UnitPoint = .trailing) -> some View
  {
    self.foregroundStyle (
      LinearGradient(
        colors: colors,
        startPoint: startPoint,
        endPoint: endPoint
      )
    )
  }
}

struct ViewBorderModifier: ViewModifier {
  var color: Color
  var radius: CGFloat
  var hide: Bool
  
  func body(content: Content) -> some View {
    if hide {
      content
    } else {
      content
        .shadow(color: color, radius: radius)
    }
  }
}

struct EmptyModifier: ViewModifier {
  func body(content: Content) -> some View {
    content
  }
}

public extension View {
  func viewBorder(color: Color = .black, radius: CGFloat = 1, hide: Bool = false) -> some View {
    //    return self
    return self.modifier(ViewBorderModifier(color: color, radius: radius, hide: hide))
  }
  
}

extension Text {
  public func font(_ size: CGFloat = 17, weight: Font.Weight? = nil, design: Font.Design? = nil) -> Text {
    return self.font(.system(size: size, design: design ?? .default).weight(weight ?? .regular))
  }
}

extension UIApplication {
  var currentScene: UIWindowScene? {
    connectedScenes
      .first { $0.activationState == .foregroundActive } as? UIWindowScene
  }
}


struct AdaptsToKeyboard: ViewModifier {
  @State var currentHeight: CGFloat = 0
  
  func body(content: Content) -> some View {
    GeometryReader { geometry in
      content
        .padding(.bottom, self.currentHeight)
        .onAppear(perform: {
          NotificationCenter.Publisher(center: NotificationCenter.default, name: UIResponder.keyboardWillShowNotification)
            .merge(with: NotificationCenter.Publisher(center: NotificationCenter.default, name: UIResponder.keyboardWillChangeFrameNotification))
            .compactMap { notification in
              withAnimation(.easeOut(duration: 0.16)) {
                notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
              }
            }
            .map { rect in
              rect.height - geometry.safeAreaInsets.bottom
            }
            .subscribe(Subscribers.Assign(object: self, keyPath: \.currentHeight))
          
          NotificationCenter.Publisher(center: NotificationCenter.default, name: UIResponder.keyboardWillHideNotification)
            .compactMap { notification in
              CGFloat.zero
            }
            .subscribe(Subscribers.Assign(object: self, keyPath: \.currentHeight))
        })
    }
  }
}

public extension View {
  func adaptsToKeyboard() -> some View {
    return modifier(AdaptsToKeyboard())
  }
}


// @available(iOS 13.4, *) - needed for iOS
struct Draggable<Preview: View>: ViewModifier {
  let condition: Bool
  let data: () -> NSItemProvider
  let preview: Preview
  
  init(condition: Bool, data: @escaping () -> NSItemProvider, preview: Preview) {
    self.condition = condition
    self.data = data
    self.preview = preview
  }
  
  @ViewBuilder
  func body(content: Content) -> some View {
    if condition {
      content.onDrag(data)
    } else {
      content
    }
  }
}

// @available(iOS 13.4, *) - needed for iOS
public extension View {
  func drag<V>(if condition: Bool, _ data: @escaping () -> NSItemProvider, @ViewBuilder preview: () -> V)
        -> some View where V : View {
    self.modifier(Draggable(condition: condition, data: data, preview: preview()))
  }
}

public extension Text {
    init(_ string: String, configure: ((inout AttributedString) -> Void)) {
        var attributedString = AttributedString(string) /// create an `AttributedString`
        configure(&attributedString) /// configure using the closure
        self.init(attributedString) /// initialize a `Text`
    }
}


public extension View {
  public func stroke(color: Color = .white, width: CGFloat = 1) -> some View {
        modifier(StrokeModifer(strokeSize: width, strokeColor: color))
    }
}

struct StrokeModifer: ViewModifier {
    private let id = UUID()
    var strokeSize: CGFloat = 1
    var strokeColor: Color = .blue

    func body(content: Content) -> some View {
        if strokeSize > 0 {
            appliedStrokeBackground(content: content)
        } else {
            content
        }
    }

    private func appliedStrokeBackground(content: Content) -> some View {
        content
            .padding(strokeSize*2)
            .background(
                Rectangle()
                    .foregroundColor(strokeColor)
                    .mask(alignment: .center) {
                        mask(content: content)
                    }
            )
    }

    func mask(content: Content) -> some View {
        Canvas { context, size in
            context.addFilter(.alphaThreshold(min: 0.01))
            context.drawLayer { ctx in
                if let resolvedView = context.resolveSymbol(id: id) {
                    ctx.draw(resolvedView, at: .init(x: size.width/2, y: size.height/2))
                }
            }
        } symbols: {
            content
                .tag(id)
                .blur(radius: strokeSize)
        }
    }
}


public extension View {
  // Convert SwiftUI view to a UIImage
  @MainActor func asImage() -> UIImage? {
    let renderer = ImageRenderer(content: self)
    renderer.scale = UIScreen.main.scale
    if let image = renderer.uiImage {
      if let data = image.pngData(), let pngImage = UIImage(data: data) {
        return pngImage
      }
    }
    return nil
  }
}
