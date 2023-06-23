import SwiftUI

// two options to animate number while user only deal with `Int`:
// 1)
// extend Int to be VectorArithmetic so it's animatable
extension Int: VectorArithmetic {
    mutating public func scale(by rhs: Double) {
        self = Int(Double(self) * rhs)
    }

    public var magnitudeSquared: Double {
        Double(self * self)
    }
}

struct AnimatableNumberModifier: AnimatableModifier {
    var animatableData: Int

    init(number: Int) {
        animatableData = number
    }

    func body(content: Content) -> some View {
        content
            .overlay(
                Text("\(animatableData)")
            )
    }
}

// 2) or just animate `Double`, but use `Int` in init so user only deal with `Int`, not `Double`
struct AnimatableNumberModifier2: AnimatableModifier {
    var animatableData: Double

    init(number: Int) {
        animatableData = Double(number)
    }

    func body(content: Content) -> some View {
        content
            .overlay(
                Text("\(Int(animatableData))")
            )
    }
}

extension View {
    func animatingOverlay(for number: Int) -> some View {
        modifier(AnimatableNumberModifier(number: number))
    }

    func animatingOverlay2(for number: Int) -> some View {
        modifier(AnimatableNumberModifier2(number: number))
    }
}


struct AnimatableNumber: View {
    @State private var number: Int = 0

    var body: some View {
        VStack(spacing: 20) {
            Color.clear
                .frame(width: 50, height: 50)
                .animatingOverlay(for: number)

            Color.clear
                .frame(width: 50, height: 50)
                .animatingOverlay2(for: number)

            Button {
                withAnimation {
                    number = .random(in: 0 ..< 200)
                }
            } label: {
                Text("Create random number")
            }
        }
    }
}

struct AnimatableNumber_Previews: PreviewProvider {
    static var previews: some View {
        AnimatableNumber()
    }
}
