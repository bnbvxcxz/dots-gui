pragma Singleton
import QtQuick

QtObject {
	<* for name, value in colors *>
	readonly property color {{name}}: "{{value.default.hex}}"
	<* endfor *>

	// Fallback typography (overridden automatically by BarMetrics via qt6ct)
	readonly property string fontFamily: "JetBrainsMono NFP"
	readonly property int fontSize: 10
	readonly property int cornerRadius: 10

	// Base Layout Metrics (pre-PPI scaling)
	readonly property int baseBarHeight: 22
	readonly property int basePillPadding: 6
	readonly property int baseSpacing: 4
	readonly property int baseDrawerWidth: 360
	readonly property int baseDrawerHeight: 600
}
