import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: root
    
    property var backend
    property var scriptsData: []
    
    function refresh() {
        backend.callCommand("list", [], function(data, error) {
            if (!error) {
                scriptsData = data
            }
        })
    }
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 15
        
        // Header with search
        RowLayout {
            Layout.fillWidth: true
            spacing: 10
            
            Text {
                text: "Available Scripts"
                font.pixelSize: 20
                font.bold: true
                color: "#cdd6f4"
            }
            
            Item { Layout.fillWidth: true }
            
            TextField {
                id: searchField
                placeholderText: "Search scripts..."
                Layout.preferredWidth: 250
                
                background: Rectangle {
                    color: "#313244"
                    radius: 5
                    border.color: parent.activeFocus ? "#89b4fa" : "#45475a"
                    border.width: 1
                }
                
                color: "#cdd6f4"
            }
            
            Button {
                text: "▶ Run All"
                onClicked: runAllScripts()
                
                background: Rectangle {
                    color: parent.hovered ? "#94e2d5" : "#89dceb"
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
        
        // Scripts list
        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            
            ListView {
                id: scriptsList
                model: root.scriptsData.filter(script => 
                    searchField.text === "" || 
                    script.name.toLowerCase().includes(searchField.text.toLowerCase()) ||
                    script.description.toLowerCase().includes(searchField.text.toLowerCase())
                )
                spacing: 10
                
                delegate: Rectangle {
                    width: scriptsList.width
                    height: 80
                    color: "#313244"
                    radius: 8
                    
                    border.color: mouseArea.containsMouse ? "#89b4fa" : "transparent"
                    border.width: 2
                    
                    MouseArea {
                        id: mouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                    }
                    
                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 15
                        spacing: 15
                        
                        // Status indicator
                        Rectangle {
                            Layout.preferredWidth: 12
                            Layout.preferredHeight: 12
                            radius: 6
                            color: {
                                if (modelData.last_status === "success") return "#a6e3a1"
                                if (modelData.last_status === "failed") return "#f38ba8"
                                return "#6c7086"
                            }
                        }
                        
                        Column {
                            Layout.fillWidth: true
                            spacing: 5
                            
                            Text {
                                text: modelData.name
                                font.pixelSize: 16
                                font.bold: true
                                color: "#cdd6f4"
                            }
                            
                            Text {
                                text: modelData.description
                                font.pixelSize: 12
                                color: "#a6adc8"
                            }
                            
                            Text {
                                text: modelData.last_run ? 
                                    "Last run: " + modelData.last_run + " - " + modelData.last_status : 
                                    "Never run"
                                font.pixelSize: 11
                                color: "#6c7086"
                            }
                        }
                        
                        Button {
                            text: "▶ Run"
                            onClicked: runScript(modelData.name)
                            
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
                            }
                        }
                        
                        Button {
                            text: "📋"
                            onClicked: viewLogs(modelData.name)
                            
                            background: Rectangle {
                                color: parent.hovered ? "#89dceb" : "#74c7ec"
                                radius: 5
                            }
                            
                            contentItem: Text {
                                text: parent.text
                                color: "#1e1e2e"
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                font.pixelSize: 16
                            }
                        }
                        
                        Button {
                            text: "🗑"
                            onClicked: clearLogs(modelData.name)
                            
                            background: Rectangle {
                                color: parent.hovered ? "#f38ba8" : "#eba0ac"
                                radius: 5
                            }
                            
                            contentItem: Text {
                                text: parent.text
                                color: "#1e1e2e"
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                font.pixelSize: 16
                            }
                        }
                    }
                }
            }
        }
    }
    
    function runScript(name) {
        backend.callCommand("run", [name], function(data, error) {
            if (!error) {
                refresh()
            }
        })
    }
    
    function runAllScripts() {
        backend.callCommand("run-all", [], function(data, error) {
            if (!error) {
                refresh()
            }
        })
    }
    
    function viewLogs(name) {
        // Switch to logs tab and filter by script
        // This would need to be implemented with proper signal handling
    }
    
    function clearLogs(name) {
        backend.callCommand("clear-logs", [name], function(data, error) {
            if (!error) {
                refresh()
            }
        })
    }
}
