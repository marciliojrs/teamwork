import Layout
import NVActivityIndicatorView

extension RuntimeType {
    @objc static let nvActivityIndicatorType = RuntimeType([
        "blank": .blank,
        "ballPulse": .ballPulse,
        "ballGridPulse": .ballGridPulse,
        "ballClipRotate": .ballClipRotate,
        "squareSpin": .squareSpin,
        "ballClipRotatePulse": .ballClipRotatePulse,
        "ballClipRotateMultiple": .ballClipRotateMultiple,
        "ballPulseRise": .ballPulseRise,
        "ballRotate": .ballRotate,
        "cubeTransition": .cubeTransition,
        "ballZigZag": .ballZigZag,
        "ballZigZagDeflect": .ballZigZagDeflect,
        "ballTrianglePath": .ballTrianglePath,
        "ballScale": .ballScale,
        "lineScale": .lineScale,
        "lineScaleParty": .lineScaleParty,
        "ballScaleMultiple": .ballScaleMultiple,
        "ballPulseSync": .ballPulseSync,
        "ballBeat": .ballBeat,
        "lineScalePulseOut": .lineScalePulseOut,
        "lineScalePulseOutRapid": .lineScalePulseOutRapid,
        "ballScaleRipple": .ballScaleRipple,
        "ballScaleRippleMultiple": .ballScaleRippleMultiple,
        "ballSpinFadeLoader": .ballSpinFadeLoader,
        "lineSpinFadeLoader": .lineSpinFadeLoader,
        "triangleSkewSpin": .triangleSkewSpin,
        "pacman": .pacman,
        "ballGridBeat": .ballGridBeat,
        "semiCircleSpin": .semiCircleSpin,
        "ballRotateChase": .ballRotateChase,
        "orbit": .orbit,
        "audioEqualizer": .audioEqualizer,
        "circleStrokeSpin": .circleStrokeSpin
    ] as [String: NVActivityIndicatorType])
}

extension NVActivityIndicatorView {
    public override class func create(with node: LayoutNode) throws -> NVActivityIndicatorView {
        let type = (try node.value(forExpression: "activityType") as? NVActivityIndicatorType) ?? .blank
        let color = (try node.value(forExpression: "color") as? UIColor) ?? .black
        let padding = (try node.value(forExpression: "padding") as? CGFloat) ?? 0.0

        return NVActivityIndicatorView(frame: .zero, type: type, color: color, padding: padding)
    }

    public override class var parameterTypes: [String: RuntimeType] {
        return ["activityType": .nvActivityIndicatorType, "color": .uiColor, "padding": .cgFloat]
    }
}
