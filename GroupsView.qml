import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: root
    
    property var backend
    property var groupsData: []
    
    function refresh() {
        backend.callCommand("list-groups", [], function(data, error) {
            if (!error) {
                groupsData = data
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
            spacing: 10
            
            Text {
                text: "Script Groups"
                font.pixelSize: 20
                font.bold: true
                color: "#cdd6f4"
            }
            
            Item { Layout.fillWidth: true }
            
            Button {
                text: "⏰ Scheduled Groups"
                onClicked: showScheduledOnly = !showScheduledOnly
                
                property bool showScheduledOnly: false
                
                background: Rectangle {
                    color: parent.showScheduledOnly ? "#f9e2af" : "#313244"
                    radius: 5
                    border.color: "#585b70"
                    border.width: 1
                }
                
                contentItem: Text {
                    text: parent.text
                    color: parent.parent.showScheduledOnly ? "#1e1e2e" : "#cdd6f4"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }
        
        // Groups grid
        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            
            GridLayout {
                width: parent.width
                columns: 2
                columnSpacing: 15
                rowSpacing: 15
                
                Repeater {
                    model: root.groupsData
                    
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 200
                        color: "#313244"
                        radius: 10
                        
                        border.color: groupMouseArea.containsMouse ? "#89b4fa" : "transparent"
                        border.width: 2
                        
                        MouseArea {
                            id: groupMouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                        }
                        
                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: 15
                            spacing: 10
                            
                            // Group header
                            RowLayout {
                                Layout.fillWidth: true
                                
                                Text {
                                    text: modelData.name
                                    font.pixelSize: 18
                                    font.bold: true
                                    color: "#cdd6f4"
                                    Layout.fillWidth: true
                                }
                                
                                // Execution mode badge
                                Rectangle {
                                    Layout.preferredWidth: 70
                                    Layout.preferredHeight: 24
                                    radius: 12
                                    color: modelData.execution === "parallel" ? "#a6e3a1" : "#89dceb"
                                    
                                    Text {
                                        anchors.centerIn: parent
                                        text: modelData.execution || "serial"
                                        font.pixelSize: 10
                                        font.bold: true
                                        color: "#1e1e2e"
                                    }
                                }
                            }
                            
                            Text {
                                text: modelData.description
                                font.pixelSize: 13
                                color: "#a6adc8"
                                wrapMode: Text.WordWrap
                                Layout.fillWidth: true
                            }
                            
                            // Schedule info
                            Rectangle {
                                Layout.fillWidth: true
                                Layout.preferredHeight: 30
                                color: "#45475a"
                                radius: 5
                                visible: modelData.schedule
                                
                                RowLayout {
                                    anchors.fill: parent
                                    anchors.margins: 8
                                    spacing: 5
                                    
                                    Text {
                                        text: "⏰"
                                        font.pixelSize: 14
                                    }
                                    
                                    Text {
                                        text: modelData.schedule || ""
                                        font.pixelSize: 12
                                        color: "#f9e2af"
                                        font.family: "monospace"
                                    }
                                }
                            }
                            
                            // Scripts count
                            Text {
                                text: (modelData.scripts ? modelData.scripts.length : 0) + " script(s)"
                                font.pixelSize: 11
                                color: "#6c7086"
                            }
                            
                            Item { Layout.fillHeight: true }
                            
                            // Action buttons
                            RowLayout {
                                Layout.fillWidth: true
                                spacing: 8
                                
                                Button {
                                    text: "▶ Run Group"
                                    Layout.fillWidth: true
                                    onClicked: runGroup(modelData.name)
                                    
                                    background: Rectangle {
                                        color: parent.hovered ? "#a6e3a1" : "#94e2d5"
                                        radius: 5
                                    }
                                    
                                    contentItem: Text {
                                        text: parent.text
                                        color: "#1e1e2e"
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                        font.bold: true
                                        font.pixelSize: 12
                                    }
                                }
                                
                                Button {
                                    text: "📤"
                                    Layout.preferredWidth: 40
                                    visible: modelData.schedule
                                    onClicked: exportMenu.open()
                                    
                                    background: Rectangle {
                                        color: parent.hovered ? "#f9e2af" : "#fab387"
                                        radius: 5
                                    }
                                    
                                    contentItem: Text {
                                        text: parent.text
                                        color: "#1e1e2e"
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                        font.pixelSize: 16
                                    }
                                    
                                    Menu {
                                        id: exportMenu
                                        
                                        MenuItem {
                                            text: "Export systemd"
                                            onClicked: exportSystemd(modelData.name)
                                        }
                                        
                                        MenuItem {
                                            text: "Export cron"
                                            onClicked: exportCron(modelData.name)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    function runGroup(name) {
        backend.callCommand("run-group", [name], function(data, error) {
            if (!error) {
                // Show success notification
            }
        })
    }
    
    function exportSystemd(name) {
        backend.callCommand("export-systemd", [name], function(data, error) {
            if (!error) {
                // Show success notification
            }
        })
    }
    
    function exportCron(name) {
        backend.callCommand("export-cron", [name], function(data, error) {
            if (!error) {
                // Show success notification
            }
        })
    }
}
