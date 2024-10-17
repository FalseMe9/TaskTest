import SwiftUI

extension Image{
    func scale(size:CGFloat)->some View{
        self
            .resizable()
            .scaledToFit()
            .frame(width: size, height: size)
    }
}
