import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: root
    
    property var backend
    property var configData: {}
    
    function refresh() {
        backend.callCommand("show-config", [], function(data, error) {
            if (!error) {
                configData = data
            }
        })
    }
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 15
        
        // Header
        RowLayout {
            Layout.fillWidth: true
            
            Text {
                text: "Configuration"
                font.pixelSize: 20
                font.bold: true
                color: "#cdd6f4"
            }
            
            Item { Layout.fillWidth: true }
            
            Button {
                text: "🔄 Reload"
                onClicked: refresh()
                
                background: Rectangle {
                    color: parent.hovered ? "#89dceb" : "#74c7ec"
                    radius: 5
                }
                
                contentItem: Text {
                    text: parent.text
                    color: "#1e1e2e"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.bold: true
                }
            }
        }
        
        // Config sections
        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            
            ColumnLayout {
                width: parent.width
                spacing: 20
                
                // Paths section
                ConfigSection {
                    title: "📁 Paths"
                    items: [
                        {key: "Log Directory", value: configData.paths ? configData.paths.log_dir : ""},
                        {key: "Scripts File", value: configData.paths ? configData.paths.scripts_file : ""},
                        {key: "Groups File", value: configData.paths ? configData.paths.groups_file : ""}
                    ]
                }
                
                // Execution section
                ConfigSection {
                    title: "⚙️ Execution"
                    items: [
                        {key: "Default Timeout", value: configData.execution ? configData.execution.default_timeout + "s" : ""},
                        {key: "Capture Stdout", value: configData.execution ? (configData.execution.capture_stdout ? "Yes" : "No") : ""},
                        {key: "Capture Stderr", value: configData.execution ? (configData.execution.capture_stderr ? "Yes" : "No") : ""},
                        {key: "Max Parallel Workers", value: configData.execution ? configData.execution.max_parallel_workers : ""}
                    ]
                }
                
                // Logging section
                ConfigSection {
                    title: "📝 Logging"
                    items: [
                        {key: "Timestamp Format", value: configData.logging ? configData.logging.timestamp_format : ""},
                        {key: "Include Command", value: configData.logging ? (configData.logging.include_command ? "Yes" : "No") : ""},
                        {key: "Include Return Code", value: configData.logging ? (configData.logging.include_return_code ? "Yes" : "No") : ""}
                    ]
                }
                
                // Display section
                ConfigSection {
                    title: "🎨 Display"
                    items: [
                        {key: "Use Colors", value: configData.display ? (configData.display.use_colors ? "Yes" : "No") : ""},
                        {key: "Show Full Paths", value: configData.display ? (configData.display.show_full_paths ? "Yes" : "No") : ""},
                        {key: "Date Format", value: configData.display ? configData.display.date_format : ""}
                    ]
                }
                
                // Validation section
                ConfigSection {
                    title: "✓ Validation"
                    items: [
                        {key: "Strict Mode", value: configData.validation ? (configData.validation.strict ? "Yes" : "No") : ""},
                        {key: "Warn Unused Scripts", value: configData.validation ? (configData.validation.warn_unused_scripts ? "Yes" : "No") : ""},
                        {key: "Warn Empty Groups", value: configData.validation ? (configData.validation.warn_empty_groups ? "Yes" : "No") : ""}
                    ]
                }
            }
        }
        
        // Documentation links
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 100
            color: "#313244"
            radius: 8
            
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 15
                spacing: 10
                
                Text {
                    text: "📚 Documentation"
                    font.pixelSize: 16
                    font.bold: true
                    color: "#cdd6f4"
                }
                
                RowLayout {
                    spacing: 10
                    
                    LinkButton {
                        text: "Config Guide"
                        onClicked: Qt.openUrlExternally("file://" + Qt.resolvedUrl("../signalbox/documentation/CONFIG_GUIDE.md"))
                    }
                    
                    LinkButton {
                        text: "File Structure"
                        onClicked: Qt.openUrlExternally("file://" + Qt.resolvedUrl("../signalbox/documentation/FILE_STRUCTURE.md"))
                    }
                    
                    LinkButton {
                        text: "Writing Scripts"
                        onClicked: Qt.openUrlExternally("file://" + Qt.resolvedUrl("../signalbox/documentation/WRITING_SCRIPTS.md"))
                    }
                }
            }
        }
    }
    
    Component.onCompleted: refresh()
    
    // Helper component for config sections
    component ConfigSection: Rectangle {
        property string title: ""
        property var items: []
        
        Layout.fillWidth: true
        Layout.preferredHeight: contentColumn.height + 30
        color: "#313244"
        radius: 8
        
        Column {
            id: contentColumn
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 15
            spacing: 10
            
            Text {
                text: title
                font.pixelSize: 16
                font.bold: true
                color: "#cdd6f4"
            }
            
            Repeater {
                model: items
                
                RowLayout {
                    width: parent.width
                    spacing: 10
                    
                    Text {
                        text: modelData.key + ":"
                        font.pixelSize: 13
                        color: "#a6adc8"
                        Layout.preferredWidth: 200
                    }
                    
                    Text {
                        text: modelData.value
                        font.pixelSize: 13
                        font.family: "monospace"
                        color: "#cdd6f4"
                        Layout.fillWidth: true
                    }
                }
            }
        }
    }
    
    // Helper component for link buttons
    component LinkButton: Button {
        background: Rectangle {
            color: parent.hovered ? "#89b4fa" : "transparent"
            radius: 5
            border.color: "#89b4fa"
            border.width: 1
        }
        
        contentItem: Text {
            text: parent.text
            color: "#89b4fa"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: 12
        }
    }
}
