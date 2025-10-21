import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: root
    
    property var backend
    property var logsData: []
    property string selectedScript: ""
    
    function refresh() {
        if (selectedScript) {
            loadHistory(selectedScript)
        }
    }
    
    function loadHistory(scriptName) {
        selectedScript = scriptName
        backend.callCommand("history", [scriptName], function(data, error) {
            if (!error) {
                logsData = data
            }
        })
    }
    
    RowLayout {
        anchors.fill: parent
        spacing: 0
        
        // Script selector sidebar
        Rectangle {
            Layout.preferredWidth: 250
            Layout.fillHeight: true
            color: "#181825"
            
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 15
                spacing: 10
                
                Text {
                    text: "Select Script"
                    font.pixelSize: 16
                    font.bold: true
                    color: "#cdd6f4"
                }
                
                TextField {
                    id: scriptSearchField
                    placeholderText: "Search..."
                    Layout.fillWidth: true
                    
                    background: Rectangle {
                        color: "#313244"
                        radius: 5
                        border.color: parent.activeFocus ? "#89b4fa" : "#45475a"
                        border.width: 1
                    }
                    
                    color: "#cdd6f4"
                }
                
                ScrollView {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    
                    ListView {
                        id: scriptSelector
                        model: [] // Would be populated from backend
                        spacing: 5
                        
                        delegate: Rectangle {
                            width: scriptSelector.width
                            height: 40
                            color: selectedScript === modelData ? "#45475a" : "transparent"
                            radius: 5
                            
                            MouseArea {
                                anchors.fill: parent
                                onClicked: loadHistory(modelData)
                                hoverEnabled: true
                                
                                onEntered: parent.color = selectedScript === modelData ? "#45475a" : "#313244"
                                onExited: parent.color = selectedScript === modelData ? "#45475a" : "transparent"
                            }
                            
                            Text {
                                anchors.fill: parent
                                anchors.leftMargin: 10
                                text: modelData
                                color: "#cdd6f4"
                                verticalAlignment: Text.AlignVCenter
                                font.pixelSize: 13
                            }
                        }
                    }
                }
            }
        }
        
        // Logs content
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "#1e1e2e"
            
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 15
                
                // Header
                RowLayout {
                    Layout.fillWidth: true
                    
                    Text {
                        text: selectedScript ? "Logs: " + selectedScript : "Select a script to view logs"
                        font.pixelSize: 20
                        font.bold: true
                        color: "#cdd6f4"
                    }
                    
                    Item { Layout.fillWidth: true }
                    
                    Button {
                        text: "🗑 Clear Logs"
                        visible: selectedScript !== ""
                        onClicked: clearScriptLogs()
                        
                        background: Rectangle {
                            color: parent.hovered ? "#f38ba8" : "#eba0ac"
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
                
                // Logs list
                ScrollView {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    visible: selectedScript !== ""
                    
                    ListView {
                        id: logsList
                        model: root.logsData
                        spacing: 10
                        
                        delegate: Rectangle {
                            width: logsList.width
                            height: 60
                            color: "#313244"
                            radius: 8
                            
                            border.color: logMouseArea.containsMouse ? "#89b4fa" : "transparent"
                            border.width: 2
                            
                            MouseArea {
                                id: logMouseArea
                                anchors.fill: parent
                                hoverEnabled: true
                                onClicked: viewLogContent(modelData.filename)
                            }
                            
                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 15
                                spacing: 10
                                
                                Column {
                                    Layout.fillWidth: true
                                    spacing: 5
                                    
                                    Text {
                                        text: modelData.timestamp
                                        font.pixelSize: 14
                                        font.family: "monospace"
                                        color: "#cdd6f4"
                                    }
                                    
                                    Text {
                                        text: modelData.filename
                                        font.pixelSize: 11
                                        color: "#6c7086"
                                    }
                                }
                                
                                Button {
                                    text: "📄 View"
                                    onClicked: viewLogContent(modelData.filename)
                                    
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
                        }
                    }
                }
                
                // Empty state
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: "transparent"
                    visible: selectedScript === ""
                    
                    Column {
                        anchors.centerIn: parent
                        spacing: 20
                        
                        Text {
                            text: "📋"
                            font.pixelSize: 64
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                        
                        Text {
                            text: "Select a script from the sidebar\nto view its execution history"
                            font.pixelSize: 16
                            color: "#6c7086"
                            horizontalAlignment: Text.AlignHCenter
                        }
                    }
                }
            }
        }
    }
    
    // Log viewer dialog
    Dialog {
        id: logViewerDialog
        title: "Log Content"
        width: 800
        height: 600
        modal: true
        
        property string logContent: ""
        
        ScrollView {
            anchors.fill: parent
            
            TextArea {
                text: logViewerDialog.logContent
                readOnly: true
                font.family: "monospace"
                font.pixelSize: 11
                color: "#cdd6f4"
                wrapMode: TextEdit.NoWrap
                
                background: Rectangle {
                    color: "#1e1e2e"
                }
            }
        }
    }
    
    function viewLogContent(filename) {
        backend.callCommand("logs", [selectedScript], function(data, error) {
            if (!error) {
                logViewerDialog.logContent = data.content || ""
                logViewerDialog.open()
            }
        })
    }
    
    function clearScriptLogs() {
        backend.callCommand("clear-logs", [selectedScript], function(data, error) {
            if (!error) {
                refresh()
            }
        })
    }
}
