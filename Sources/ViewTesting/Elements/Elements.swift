import SwiftUI

enum Elements {
    enum UI {
        typealias _Text = TypeDerivedElement<Text>
        typealias _Image = TypeDerivedElement<Image>
        typealias _Button = TypeDerivedElement<Button<AnyView>>
        typealias _Toggle = TypeDerivedElement<Toggle<AnyView>>
    }

    enum Modifiers {
        struct _Refreshable: ReflectionElement { let node: ReflectionNode }
        struct _Task: ReflectionElement { let node: ReflectionNode }
        struct _OnAppear: ReflectionElement { let node: ReflectionNode }
    }

    enum PropertyWrappers {
        final class DummyObservableObject: ObservableObject {}
        typealias _State = TypeDerivedElement<State<Any>>
        typealias _Binding = TypeDerivedElement<Binding<Any>>
        typealias _Environment = TypeDerivedElement<Environment<Any>>
        typealias _EnvironmentObject = TypeDerivedElement<EnvironmentObject<DummyObservableObject>>
    }

    enum Native {
        typealias _Bool = TypeDerivedElement<Bool>
        typealias _String = TypeDerivedElement<String>
        typealias _closure = TypeDerivedElement<() -> Void>
        typealias _asyncClosure = TypeDerivedElement<() async -> Void>
    }
}

extension Elements.Modifiers._Refreshable {
    func doRefresh() async {
        await node.asyncActions[0].castValue()
    }
}

extension Elements.Modifiers._Task {
    func doTask() async {
        await node.asyncActions[0].castValue()
    }
}

extension Elements.Modifiers._OnAppear {
    func doOnAppear() {
        node.actions[0].castValue()
    }
}

extension Elements.UI._Text {
    var string: String {
        node.strings[0].castValue
    }
}

extension Elements.UI._Image {
    var name: String {
        node.strings[0].castValue
    }
}

extension Elements.UI._Button {
    func tap() {
        node.actions[0].castValue()
    }
}

extension Elements.UI._Toggle {
    private enum DummyEnum {
        case case0
        case case1
    }

    var isOn: Binding<Bool> {
        let binding = node.bindings[0]
        if let boolBinding = binding.node.object as? Binding<Bool> {
            return boolBinding
        }
        let dummyBinding = CastingUtils.memoryCast(binding.node.object, Binding<DummyEnum>.self)
        return Binding {
            dummyBinding.wrappedValue == .case0
        } set: {
            dummyBinding.wrappedValue = $0 ? .case0 : .case1
        }
    }

    func toggle() {
        isOn.wrappedValue.toggle()
    }
}
