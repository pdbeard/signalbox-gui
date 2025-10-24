import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

ShellRoot {
    id: root
    
    // Backend process to communicate with signalbox
    Process {
        id: signalboxBackend

        // Enable stdin for communication
        stdinEnabled: true

        // Command to execute the backend script
        command: ["python3", Qt.resolvedUrl("signalbox_backend.py").toString().replace("file://", "")]

        // Set the working directory to the backend script's location
        workingDirectory: "../signalbox-gui"

        // Automatically start the process
        running: true

        // Example of writing to stdin
        Component.onCompleted: {
            signalboxBackend.write(JSON.stringify({ command: "list" }) + "\n");
        }

        // Restart the process if it stops
        onRunningChanged: if (!running) running = true

        property var pendingCallbacks: ({})
        property int requestId: 0

        function callCommand(command, args, callback) {
            const id = requestId++
            pendingCallbacks[id] = callback

            const request = {
                id: id,
                command: command,
                args: args
            }

            signalboxBackend.write(JSON.stringify(request) + "\n")
}
        stdout: SplitParser {
            onRead: data => {
                try {
                    const response = JSON.parse(data)
                    const callback = signalboxBackend.pendingCallbacks[response.id]
                    if (callback) {
                        callback(response.data, response.error)
                        delete signalboxBackend.pendingCallbacks[response.id]
                    }
                } catch (e) {
                    console.error("Failed to parse backend response:", e)
                }
            }
        }

        stderr: SplitParser {
            onRead: data => console.error("Backend error:", data)
        }
    }
    
    FloatingWindow {
        id: mainWindow
        
        width: 1200
        height: 800
        
        color: "#1e1e2e"
        
        ColumnLayout {
            anchors.fill: parent
            spacing: 0
            
            // Header
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 60
                color: "#313244"
                
                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 15
                    spacing: 15
                    
                    // Logo/Title
                    Row {
                        spacing: 10
                        
                        Text {
                            text: "🚦"
                            font.pixelSize: 32
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        
                        Column {
                            spacing: 2
                            anchors.verticalCenter: parent.verticalCenter
                            
                            Text {
                                text: "Signalbox"
                                font.pixelSize: 24
                                font.bold: true
                                color: "#cdd6f4"
                            }
                            
                            Text {
                                text: "Script Management System"
                                font.pixelSize: 11
                                color: "#a6adc8"
                            }
                        }
                    }
                    
                    Item { Layout.fillWidth: true }
                    
                    // Refresh button
                    Button {
                        text: "🔄 Refresh"
                        onClicked: {
                            if (tabBar.currentIndex === 0) scriptsView.refresh()
                            else if (tabBar.currentIndex === 1) groupsView.refresh()
                            else if (tabBar.currentIndex === 2) logsView.refresh()
                        }
                        
                        background: Rectangle {
                            color: parent.hovered ? "#45475a" : "#313244"
                            radius: 5
                            border.color: "#585b70"
                            border.width: 1
                        }
                        
                        contentItem: Text {
                            text: parent.text
                            color: "#cdd6f4"
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                    }
                    
                    // Validate button
                    Button {
                        text: "✓ Validate"
                        onClicked: validateConfig()
                        
                        background: Rectangle {
                            color: parent.hovered ? "#45475a" : "#313244"
                            radius: 5
                            border.color: "#585b70"
                            border.width: 1
                        }
                        
                        contentItem: Text {
                            text: parent.text
                            color: "#a6e3a1"
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                    }
                }
            }
            
            // Tab bar
            TabBar {
                id: tabBar
                Layout.fillWidth: true
                Layout.preferredHeight: 45
                
                background: Rectangle {
                    color: "#181825"
                }
                
                TabButton {
                    text: "📜 Scripts"
                    
                    background: Rectangle {
                        color: parent.checked ? "#313244" : "transparent"
                        
                        Rectangle {
                            anchors.bottom: parent.bottom
                            width: parent.width
                            height: 2
                            color: "#89b4fa"
                            visible: parent.parent.checked
                        }
                    }
                    
                    contentItem: Text {
                        text: parent.text
                        color: parent.checked ? "#cdd6f4" : "#6c7086"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.pixelSize: 14
                    }
                }
                
                TabButton {
                    text: "📦 Groups"
                    
                    background: Rectangle {
                        color: parent.checked ? "#313244" : "transparent"
                        
                        Rectangle {
                            anchors.bottom: parent.bottom
                            width: parent.width
                            height: 2
                            color: "#89b4fa"
                            visible: parent.parent.checked
                        }
                    }
                    
                    contentItem: Text {
                        text: parent.text
                        color: parent.checked ? "#cdd6f4" : "#6c7086"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.pixelSize: 14
                    }
                }
                
                TabButton {
                    text: "📋 Logs"
                    
                    background: Rectangle {
                        color: parent.checked ? "#313244" : "transparent"
                        
                        Rectangle {
                            anchors.bottom: parent.bottom
                            width: parent.width
                            height: 2
                            color: "#89b4fa"
                            visible: parent.parent.checked
                        }
                    }
                    
                    contentItem: Text {
                        text: parent.text
                        color: parent.checked ? "#cdd6f4" : "#6c7086"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.pixelSize: 14
                    }
                }
                
                TabButton {
                    text: "⚙️ Config"
                    
                    background: Rectangle {
                        color: parent.checked ? "#313244" : "transparent"
                        
                        Rectangle {
                            anchors.bottom: parent.bottom
                            width: parent.width
                            height: 2
                            color: "#89b4fa"
                            visible: parent.parent.checked
                        }
                    }
                    
                    contentItem: Text {
                        text: parent.text
                        color: parent.checked ? "#cdd6f4" : "#6c7086"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.pixelSize: 14
                    }
                }
            }
            
            // Content area
            StackLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                currentIndex: tabBar.currentIndex
                
                // Scripts view
                ScriptsView {
                    id: scriptsView
                    backend: signalboxBackend
                }
                
                // Groups view
                GroupsView {
                    id: groupsView
                    backend: signalboxBackend
                }
                
                // Logs view
                LogsView {
                    id: logsView
                    backend: signalboxBackend
                }
                
                // Config view
                ConfigView {
                    id: configView
                    backend: signalboxBackend
                }
            }
            
            // Status bar
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 30
                color: "#181825"
                
                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 8
                    spacing: 10
                    
                    Text {
                        id: statusText
                        text: "Ready"
                        color: "#a6adc8"
                        font.pixelSize: 11
                    }
                    
                    Item { Layout.fillWidth: true }
                    
                    Text {
                        text: "Signalbox v0.1.0"
                        color: "#6c7086"
                        font.pixelSize: 10
                    }
                }
            }
        }
        
        function validateConfig() {
            statusText.text = "Validating configuration..."
            statusText.color = "#f9e2af"
            
            signalboxBackend.callCommand("validate", [], function(data, error) {
                if (error) {
                    statusText.text = "Validation failed: " + error
                    statusText.color = "#f38ba8"
                } else {
                    statusText.text = data.message || "Configuration is valid"
                    statusText.color = data.success ? "#a6e3a1" : "#f38ba8"
                }
            })
        }
        
        Component.onCompleted: {
            scriptsView.refresh()
            groupsView.refresh()
        }
    }
}
