# Signalbox GUI - Quick Start Guide

## 1. Prerequisites Check

Make sure you have:
- ✅ Python 3.8+ installed
- ✅ Quickshell installed
- ✅ Both `signalbox/` and `quickshell/` in the same parent directory

## 2. Install

```bash
cd ~/dev/quickshell  # or wherever you cloned to
bash setup.sh
```

The setup script will:
- ✓ Check all dependencies
- ✓ Install Python packages if needed
- ✓ Make backend executable
- ✓ Test the connection

## 3. Run

### Simple way:
```bash
quickshell -c ~/dev/quickshell
```

### Persistent way (add to your shell):
```bash
# In your Quickshell config:
ln -s ~/dev/quickshell ~/.config/quickshell/signalbox

# Then in your main Quickshell configuration:
import "./signalbox/Shell.qml"
```

## 4. First Launch

When the GUI opens, you'll see:

1. **Scripts Tab (📜)** - All your scripts listed
   - Green dot = last run succeeded
   - Red dot = last run failed
   - Gray dot = never run

2. **Groups Tab (📦)** - Your script groups
   - Shows execution mode (parallel/serial)
   - Scheduled groups have ⏰ icon

3. **Logs Tab (📋)** - View execution history
   - Select script from sidebar
   - Click to view log contents

4. **Config Tab (⚙️)** - Configuration viewer
   - See all settings
   - Links to documentation

## 5. Common Tasks

### Run a script
1. Go to Scripts tab
2. Find your script
3. Click "▶ Run"
4. Watch status bar for result

### Run a group
1. Go to Groups tab
2. Find your group
3. Click "▶ Run Group"
4. All scripts in group execute

### View logs
1. Go to Logs tab
2. Select script from sidebar
3. Click "📄 View" on any log entry
4. Log opens in modal

### Export scheduling
1. Go to Groups tab
2. Find scheduled group (has ⏰)
3. Click "📤" button
4. Choose "Export systemd" or "Export cron"
5. Files saved to signalbox directory

### Validate config
1. Click "✓ Validate" in top bar
2. Watch status bar for results
3. Green = all good
4. Red = issues found

## 6. Keyboard Shortcuts

Currently none implemented, but you can add them by editing the QML files!

## 7. Troubleshooting

### "Backend error" messages
```bash
# Test backend manually:
cd ~/dev/quickshell
echo '{"id":1,"command":"list","args":[]}' | python3 signalbox_backend.py
```

### Scripts not showing
```bash
# Verify signalbox works:
cd ~/dev/signalbox
python3 main.py list
```

### GUI won't start
```bash
# Check Quickshell:
quickshell --version

# Check Qt:
qmake --version  # Should be Qt 6.x
```

## 8. Tips

- **Refresh**: Click 🔄 in top bar to reload current tab
- **Search**: Use search boxes to filter scripts
- **Colors**: Status indicators are color-coded for quick scanning
- **Scheduled**: Groups with ⏰ can be exported for automation

## 9. What's Next?

- Configure your scripts in `signalbox/scripts/`
- Create groups in `signalbox/groups/`  
- Export schedules for automation
- Customize colors in QML files

## 10. Getting Help

- Read the [full README](README.md)
- Check [Signalbox docs](../signalbox/README.md)
- View [Quickshell docs](https://quickshell.outfoxxed.me/)

---

Enjoy managing your scripts with style! 🚦
