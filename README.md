# Signalbox GUI 🚦

A beautiful Quickshell-based GUI interface for the [Signalbox](../signalbox) script management system.

![Signalbox GUI](screenshot.png)

## Features

✨ **Modern UI**
- Clean, dark-themed interface using Catppuccin colors
- Responsive layout with tabbed navigation
- Real-time status updates

📜 **Script Management**
- View all scripts with status indicators
- Run individual scripts or all scripts at once
- Quick access to logs
- Filter/search scripts

📦 **Group Management**
- Visual group cards showing execution modes
- Run entire groups with one click
- Export systemd/cron configurations
- See scheduled groups at a glance

📋 **Log Viewing**
- Browse execution history
- View log contents in-app
- Clear logs individually or all at once
- Sidebar script selector

⚙️ **Configuration**
- View all global settings
- Quick access to documentation
- Validate configuration with one click

## Prerequisites

### Required Software

1. **Quickshell** - QML-based shell framework
   ```bash
   # Installation varies by distro
   # Check: https://quickshell.outfoxxed.me/
   ```

2. **Python 3.8+** with dependencies
   ```bash
   cd ../signalbox
   pip install -r requirements.txt
   ```

3. **Qt 6** with QML modules
   ```bash
   # Most distros:
   sudo pacman -S qt6-base qt6-declarative  # Arch
   sudo apt install qt6-base-dev qml6-module-qtquick  # Ubuntu/Debian
   ```

### Directory Structure

Your workspace should look like this:
```
dev/
├── signalbox/          # The signalbox CLI tool
│   ├── main.py
│   ├── config.yaml
│   ├── scripts/
│   └── groups/
└── quickshell/         # This GUI (current directory)
    ├── manifest.json
    ├── Shell.qml
    ├── signalbox_backend.py
    └── *.qml views
```

## Installation

1. **Clone/place both projects** in the same parent directory:
   ```bash
   cd ~/dev  # or wherever you keep projects
   # Ensure both signalbox/ and quickshell/ are here
   ```

2. **Make backend executable**:
   ```bash
   chmod +x quickshell/signalbox_backend.py
   ```

3. **Test the backend** (optional):
   ```bash
   cd quickshell
   echo '{"id": 1, "command": "list", "args": []}' | python3 signalbox_backend.py
   ```

## Running the GUI

### Option 1: Via Quickshell

```bash
cd ~/dev/quickshell
quickshell -c .
```

### Option 2: As a Quickshell Widget

1. Copy/link to Quickshell config directory:
   ```bash
   ln -s ~/dev/quickshell ~/.config/quickshell/signalbox
   ```

2. Add to your Quickshell configuration:
   ```qml
   import "./signalbox" as SignalboxGUI
   
   SignalboxGUI.Shell {
       // Your customizations
   }
   ```

### Option 3: Standalone Window

The GUI automatically creates a `PanelWindow` that you can position:
- Edit `Shell.qml` to adjust window size/position
- Default: 1200x800 pixels

## Usage

### Scripts Tab 📜

**View Scripts**
- All scripts listed with status indicators
  - 🟢 Green = Success
  - 🔴 Red = Failed  
  - ⚫ Gray = Not run
- Last run time and status shown

**Run Scripts**
- Click "▶ Run" on individual scripts
- Click "▶ Run All" to execute all scripts
- Status updates automatically after execution

**Manage Logs**
- Click 📋 to view logs for a script
- Click 🗑 to clear logs for a script

**Search**
- Use search box to filter by name or description

### Groups Tab 📦

**View Groups**
- Cards show group info and script count
- Badges indicate execution mode:
  - 🟢 Green = Parallel
  - 🔵 Blue = Serial
- Scheduled groups show ⏰ cron expression

**Run Groups**
- Click "▶ Run Group" to execute
- Respects group's execution mode (serial/parallel)

**Export Scheduling**
- Click 📤 on scheduled groups
- Export systemd or cron configs
- Files saved to signalbox/systemd/ or signalbox/cron/

### Logs Tab 📋

**Select Script**
- Choose from sidebar (left)
- Shows all available scripts

**View History**
- All execution logs listed with timestamps
- Click "📄 View" to see full log content
- Logs open in modal dialog

**Clear Logs**
- Click "🗑 Clear Logs" to remove all logs for selected script

### Config Tab ⚙️

**View Settings**
- Organized by category:
  - 📁 Paths
  - ⚙️ Execution
  - 📝 Logging
  - 🎨 Display
  - ✓ Validation

**Documentation**
- Quick links to Signalbox documentation
- Opens in your default text editor/viewer

**Reload**
- Click "🔄 Reload" to refresh config from disk

### Top Bar Actions

**🔄 Refresh**
- Reloads current tab's data
- Updates script/group status

**✓ Validate**
- Runs signalbox configuration validation
- Shows errors/warnings in status bar

**Status Bar**
- Bottom bar shows operation results
- Color-coded messages:
  - 🟢 Green = Success
  - 🟡 Yellow = In progress
  - 🔴 Red = Error

## Customization

### Colors

The GUI uses the [Catppuccin Mocha](https://github.com/catppuccin/catppuccin) color palette. To customize:

Edit the color values in any `.qml` file:
```qml
Rectangle {
    color: "#1e1e2e"  // Background
    // Other Catppuccin colors:
    // #313244 - Surface
    // #45475a - Overlay
    // #cdd6f4 - Text
    // #89b4fa - Blue
    // #a6e3a1 - Green
    // #f38ba8 - Red
}
```

### Window Size

Edit `Shell.qml`:
```qml
PanelWindow {
    width: 1200   // Change width
    height: 800   // Change height
}
```

### Font Sizes

Search for `font.pixelSize` in any `.qml` file and adjust values.

## Architecture

### Components

```
Shell.qml                 - Main window and layout
├── ScriptsView.qml      - Scripts list and management
├── GroupsView.qml       - Groups display and execution
├── LogsView.qml         - Log browsing and viewing
└── ConfigView.qml       - Configuration display

signalbox_backend.py     - Python bridge to signalbox CLI
```

### Communication Flow

```
QML UI → signalbox_backend.py → signalbox/main.py → CLI commands
       ← JSON responses      ← Python objects    ← Output/data
```

**Process Communication**
1. QML creates a `Process` running `signalbox_backend.py`
2. Requests sent as JSON via stdin
3. Backend executes signalbox commands
4. Responses returned as JSON via stdout
5. QML updates UI with results

### Backend API

The backend accepts JSON requests:
```json
{
  "id": 1,
  "command": "list",
  "args": []
}
```

Supported commands:
- `list` - Get all scripts
- `list-groups` - Get all groups
- `list-schedules` - Get scheduled groups
- `run` - Run a script (args: [script_name])
- `run-all` - Run all scripts
- `run-group` - Run a group (args: [group_name])
- `logs` - Get latest log (args: [script_name])
- `history` - Get log history (args: [script_name])
- `clear-logs` - Clear script logs (args: [script_name])
- `clear-all-logs` - Clear all logs
- `show-config` - Get configuration
- `get-setting` - Get specific setting (args: [key])
- `validate` - Validate configuration
- `export-systemd` - Export systemd files (args: [group_name])
- `export-cron` - Export cron config (args: [group_name])

Response format:
```json
{
  "id": 1,
  "success": true,
  "data": { },
  "error": null,
  "message": "Success message"
}
```

## Troubleshooting

### GUI doesn't start

**Check Quickshell installation:**
```bash
which quickshell
quickshell --version
```

**Check Qt installation:**
```bash
qmake --version  # Should show Qt 6.x
```

### Backend errors

**Test backend manually:**
```bash
cd quickshell
echo '{"id":1,"command":"list","args":[]}' | python3 signalbox_backend.py
```

**Check Python path:**
- Backend expects signalbox at `../signalbox/`
- Verify: `ls ../signalbox/main.py`

### Scripts not showing

**Verify signalbox works:**
```bash
cd ../signalbox
python3 main.py list
```

**Check paths:**
- Backend uses relative path to signalbox
- Both projects must be in same parent directory

### Permission errors

**Make backend executable:**
```bash
chmod +x quickshell/signalbox_backend.py
```

**Check signalbox permissions:**
```bash
chmod +x signalbox/main.py
```

## Development

### Adding New Features

1. **Add backend command** in `signalbox_backend.py`:
   ```python
   def new_command(self, args):
       # Implementation
       return {"success": True, "data": result}
   ```

2. **Add to command map**:
   ```python
   command_map = {
       "new-command": lambda: self.new_command(args),
       # ...
   }
   ```

3. **Call from QML**:
   ```qml
   backend.callCommand("new-command", [], function(data, error) {
       if (!error) {
           // Handle data
       }
   })
   ```

### Testing

**Test backend commands:**
```bash
cd quickshell
python3 -c "
import json
from signalbox_backend import SignalboxBackend
backend = SignalboxBackend()
result = backend.list_scripts()
print(json.dumps(result, indent=2))
"
```

**Test QML components:**
- Use Quickshell's built-in debugging
- Add `console.log()` statements in QML
- Check Quickshell output for errors

## Contributing

Contributions welcome! Please:
1. Test with various signalbox configurations
2. Follow existing code style
3. Update documentation for new features
4. Test on multiple window managers/compositors

## License

MIT License - Same as Signalbox

Copyright (c) 2025 pdbeard

## Credits

- **Signalbox** - The awesome script management CLI
- **Quickshell** - The QML-based shell framework
- **Catppuccin** - The beautiful color palette
- **Qt/QML** - The UI framework

## Links

- [Signalbox Repository](https://github.com/pdbeard/signalbox)
- [Signalbox GUI Repository](https://github.com/pdbeard/signalbox-gui)
- [Quickshell Documentation](https://quickshell.outfoxxed.me/)
- [Catppuccin Theme](https://github.com/catppuccin/catppuccin)

---

Made with 🚦 for better script management
