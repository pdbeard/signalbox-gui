# 🚦 Signalbox Quickshell GUI - Complete!

## Project Overview

A beautiful, modern GUI interface for the Signalbox script management system, built with Quickshell and QML.

## What Was Created

### Core Files
- ✅ `manifest.json` - Quickshell manifest
- ✅ `Shell.qml` - Main application window with tabbed interface
- ✅ `signalbox_backend.py` - Python bridge between QML and Signalbox CLI

### View Components
- ✅ `ScriptsView.qml` - Scripts list with run/log management
- ✅ `GroupsView.qml` - Groups display with execution controls
- ✅ `LogsView.qml` - Log browser and viewer
- ✅ `ConfigView.qml` - Configuration display

### Helper Scripts
- ✅ `setup.sh` - Automated setup and dependency checking
- ✅ `launch.sh` - Simple launcher
- ✅ `test_backend.sh` - Backend testing utility

### Documentation
- ✅ `README.md` - Complete documentation with architecture details
- ✅ `QUICKSTART.md` - Quick start guide for new users

## Features Implemented

### 🎨 UI/UX
- Modern dark theme using Catppuccin colors
- Tabbed navigation (Scripts, Groups, Logs, Config)
- Real-time status updates in status bar
- Color-coded status indicators
- Search/filter functionality
- Responsive layout

### 📜 Script Management
- View all scripts with status (success/failed/not run)
- Run individual scripts
- Run all scripts at once
- View logs for any script
- Clear logs individually or all at once
- Last run time and status display

### 📦 Group Management
- Visual group cards
- Shows execution mode (parallel/serial)
- Display scheduled groups with cron expressions
- Run entire groups
- Export systemd/cron configurations
- Script count per group

### 📋 Log Viewing
- Sidebar script selector
- Execution history list with timestamps
- Modal log viewer
- Clear logs functionality
- Chronological ordering

### ⚙️ Configuration
- Display all settings by category
- Links to Signalbox documentation
- Reload configuration
- Validate configuration with visual feedback

### 🔧 Backend
- JSON-based communication
- Supports all Signalbox CLI commands
- Error handling and reporting
- Async execution support
- Proper timeout handling

## Architecture

```
┌─────────────────────────────────────────┐
│         Shell.qml (Main Window)         │
│  ┌───────────────────────────────────┐  │
│  │  TabBar: Scripts|Groups|Logs|Cfg  │  │
│  └───────────────────────────────────┘  │
│  ┌───────────────────────────────────┐  │
│  │      Content Area (Views)         │  │
│  │  - ScriptsView.qml                │  │
│  │  - GroupsView.qml                 │  │
│  │  - LogsView.qml                   │  │
│  │  - ConfigView.qml                 │  │
│  └───────────────────────────────────┘  │
│  ┌───────────────────────────────────┐  │
│  │      Status Bar                   │  │
│  └───────────────────────────────────┘  │
└─────────────────────────────────────────┘
              ↕ JSON via stdin/stdout
┌─────────────────────────────────────────┐
│     signalbox_backend.py (Bridge)       │
│  - Request/Response handling            │
│  - Command mapping                      │
│  - Error management                     │
└─────────────────────────────────────────┘
              ↕ Direct Python imports
┌─────────────────────────────────────────┐
│     Signalbox CLI (main.py)             │
│  - Script execution                     │
│  - Configuration management             │
│  - Log handling                         │
└─────────────────────────────────────────┘
```

## Getting Started

### Quick Setup
```bash
cd ~/dev/quickshell
bash setup.sh
```

### Launch
```bash
./launch.sh
# or
quickshell -c .
```

### Test Backend
```bash
./test_backend.sh
```

## Directory Structure

```
quickshell/
├── manifest.json              # Quickshell app manifest
├── Shell.qml                  # Main application window
├── ScriptsView.qml           # Scripts tab
├── GroupsView.qml            # Groups tab
├── LogsView.qml              # Logs tab
├── ConfigView.qml            # Config tab
├── signalbox_backend.py      # Backend bridge
├── setup.sh                  # Setup script
├── launch.sh                 # Launcher
├── test_backend.sh           # Testing utility
├── README.md                 # Full documentation
├── QUICKSTART.md             # Quick start guide
└── PROJECT_SUMMARY.md        # This file
```

## Key Technologies

- **Quickshell** - QML-based shell/widget framework
- **Qt 6 / QML** - UI framework and declarative language
- **Python 3** - Backend scripting
- **Catppuccin** - Color palette for theming
- **JSON** - Communication protocol

## Communication Protocol

### Request Format
```json
{
  "id": 1,
  "command": "list",
  "args": ["optional", "arguments"]
}
```

### Response Format
```json
{
  "id": 1,
  "success": true,
  "data": { },
  "error": null,
  "message": "Success"
}
```

### Supported Commands
- `list` - Get all scripts
- `list-groups` - Get all groups
- `list-schedules` - Get scheduled groups
- `run` - Run script
- `run-all` - Run all scripts
- `run-group` - Run group
- `logs` - Get latest log
- `history` - Get log history
- `clear-logs` - Clear script logs
- `clear-all-logs` - Clear all logs
- `show-config` - Get configuration
- `get-setting` - Get specific setting
- `validate` - Validate configuration
- `export-systemd` - Export systemd files
- `export-cron` - Export cron config

## Color Palette (Catppuccin Mocha)

- Background: `#1e1e2e`
- Surface: `#313244`
- Overlay: `#45475a`
- Text: `#cdd6f4`
- Subtext: `#a6adc8`
- Blue: `#89b4fa`
- Green: `#a6e3a1`
- Red: `#f38ba8`
- Yellow: `#f9e2af`
- Teal: `#94e2d5`

## Future Enhancements

Possible additions:
- [ ] Desktop notification support
- [ ] Script editing within GUI
- [ ] Drag-and-drop script organization
- [ ] Custom themes/color schemes
- [ ] Keyboard shortcuts
- [ ] System tray integration
- [ ] Multi-workspace support
- [ ] Real-time log streaming
- [ ] Script templates
- [ ] Backup/restore configurations

## Testing Checklist

Before release:
- [x] Backend communication works
- [x] All views render correctly
- [x] Scripts can be listed
- [x] Scripts can be executed
- [x] Groups can be run
- [x] Logs can be viewed
- [x] Config displays properly
- [x] Error handling works
- [x] Status updates work
- [x] Documentation complete

## Known Limitations

1. **Quickshell Required** - GUI requires Quickshell to be installed
2. **Relative Paths** - Backend expects signalbox at `../signalbox/`
3. **Single Instance** - No multi-window support yet
4. **Read-Only Config** - Cannot edit config from GUI (view only)
5. **No Live Updates** - Must refresh manually to see changes

## Performance Notes

- Backend starts with GUI (persistent process)
- Each command runs synchronously
- Log viewing loads entire log into memory
- Script list refreshes on demand only
- Minimal CPU usage when idle

## Security Considerations

- Backend runs with user permissions
- No elevated privileges required
- Scripts execute with user context
- No network communication
- All operations local to system

## Troubleshooting

See `README.md` for detailed troubleshooting steps.

Common issues:
- Backend path errors → Check relative paths
- Qt errors → Ensure Qt 6 installed
- Quickshell not found → Install Quickshell
- JSON parse errors → Check backend output

## Resources

- [Signalbox Repo](../signalbox/)
- [Quickshell Docs](https://quickshell.outfoxxed.me/)
- [Qt QML Docs](https://doc.qt.io/qt-6/qtqml-index.html)
- [Catppuccin](https://github.com/catppuccin/catppuccin)

## Credits

Created as a GUI frontend for the Signalbox script management system.

- Signalbox CLI by pdbeard
- GUI design using Catppuccin color palette
- Built with Quickshell and Qt/QML

## License

MIT License - Same as Signalbox

---

**Status**: ✅ Complete and ready to use!

**Last Updated**: 2025-10-21
