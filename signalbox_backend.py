#!/usr/bin/env python3
"""
Signalbox Backend for Quickshell GUI
Bridges QML frontend with signalbox CLI commands
"""

import sys
import json
import os
import subprocess
from pathlib import Path
from datetime import datetime

# Add signalbox directory to path
SIGNALBOX_PATH = Path(__file__).parent.parent / "signalbox"
sys.path.insert(0, str(SIGNALBOX_PATH))

# Import signalbox modules
try:
    from main import load_config, load_global_config
except ImportError:
    print(json.dumps({"error": "Failed to import signalbox modules"}), file=sys.stderr)
    sys.exit(1)

class SignalboxBackend:
    def __init__(self):
        self.signalbox_dir = SIGNALBOX_PATH
        self.main_script = self.signalbox_dir / "main.py"
        
    def run_command(self, command, args=None):
        """Run a signalbox CLI command and return the result"""
        if args is None:
            args = []
            
        cmd = ["python3", str(self.main_script), command] + args
        
        try:
            result = subprocess.run(
                cmd,
                cwd=str(self.signalbox_dir),
                capture_output=True,
                text=True,
                timeout=30
            )
            
            return {
                "success": result.returncode == 0,
                "stdout": result.stdout,
                "stderr": result.stderr,
                "returncode": result.returncode
            }
        except subprocess.TimeoutExpired:
            return {
                "success": False,
                "error": "Command timed out"
            }
        except Exception as e:
            return {
                "success": False,
                "error": str(e)
            }
    
    def list_scripts(self):
        """Get list of all scripts with their status"""
        try:
            os.chdir(self.signalbox_dir)
            config = load_config()
            
            scripts = []
            for script in config.get('scripts', []):
                scripts.append({
                    "name": script.get('name', ''),
                    "description": script.get('description', ''),
                    "command": script.get('command', ''),
                    "last_run": script.get('last_run', ''),
                    "last_status": script.get('last_status', 'not run')
                })
            
            return {"success": True, "data": scripts}
        except Exception as e:
            return {"success": False, "error": str(e)}
    
    def list_groups(self):
        """Get list of all groups"""
        try:
            os.chdir(self.signalbox_dir)
            config = load_config()
            
            groups = []
            for group in config.get('groups', []):
                groups.append({
                    "name": group.get('name', ''),
                    "description": group.get('description', ''),
                    "scripts": group.get('scripts', []),
                    "schedule": group.get('schedule'),
                    "execution": group.get('execution', 'serial'),
                    "stop_on_error": group.get('stop_on_error', False)
                })
            
            return {"success": True, "data": groups}
        except Exception as e:
            return {"success": False, "error": str(e)}
    
    def run_script(self, script_name):
        """Run a specific script"""
        result = self.run_command("run", [script_name])
        
        if result["success"]:
            return {
                "success": True,
                "message": f"Script '{script_name}' executed successfully",
                "output": result["stdout"]
            }
        else:
            return {
                "success": False,
                "error": result.get("stderr", result.get("error", "Unknown error"))
            }
    
    def run_group(self, group_name):
        """Run a script group"""
        result = self.run_command("run-group", [group_name])
        
        if result["success"]:
            return {
                "success": True,
                "message": f"Group '{group_name}' executed successfully",
                "output": result["stdout"]
            }
        else:
            return {
                "success": False,
                "error": result.get("stderr", result.get("error", "Unknown error"))
            }
    
    def run_all(self):
        """Run all scripts"""
        result = self.run_command("run-all")
        
        if result["success"]:
            return {
                "success": True,
                "message": "All scripts executed",
                "output": result["stdout"]
            }
        else:
            return {
                "success": False,
                "error": result.get("stderr", result.get("error", "Unknown error"))
            }
    
    def get_logs(self, script_name):
        """Get latest log for a script"""
        result = self.run_command("logs", [script_name])
        
        if result["success"]:
            return {
                "success": True,
                "content": result["stdout"]
            }
        else:
            return {
                "success": False,
                "error": result.get("stderr", result.get("error", "No logs found"))
            }
    
    def get_history(self, script_name):
        """Get execution history for a script"""
        result = self.run_command("history", [script_name])
        
        if result["success"]:
            # Parse history output
            lines = result["stdout"].strip().split('\n')[1:]  # Skip header
            history = []
            
            for line in lines:
                if line.strip() and not line.startswith('History'):
                    parts = line.strip().split(' - ')
                    if len(parts) >= 2:
                        history.append({
                            "filename": parts[0].strip(),
                            "timestamp": parts[1].strip() if len(parts) > 1 else ""
                        })
            
            return {"success": True, "data": history}
        else:
            return {"success": False, "error": "No history found"}
    
    def clear_logs(self, script_name):
        """Clear logs for a script"""
        result = self.run_command("clear-logs", [script_name])
        
        return {
            "success": result["success"],
            "message": f"Logs cleared for '{script_name}'" if result["success"] else "Failed to clear logs"
        }
    
    def clear_all_logs(self):
        """Clear all logs"""
        result = self.run_command("clear-all-logs")
        
        return {
            "success": result["success"],
            "message": "All logs cleared" if result["success"] else "Failed to clear logs"
        }
    
    def show_config(self):
        """Get global configuration"""
        try:
            os.chdir(self.signalbox_dir)
            config = load_global_config()
            
            return {"success": True, "data": config}
        except Exception as e:
            return {"success": False, "error": str(e)}
    
    def get_setting(self, key):
        """Get a specific configuration setting"""
        result = self.run_command("get-setting", [key])
        
        if result["success"]:
            return {
                "success": True,
                "value": result["stdout"].strip()
            }
        else:
            return {"success": False, "error": "Setting not found"}
    
    def validate(self):
        """Validate configuration files"""
        result = self.run_command("validate")
        
        return {
            "success": result["returncode"] == 0,
            "message": result["stdout"],
            "errors": result["stderr"] if result["stderr"] else None
        }
    
    def export_systemd(self, group_name, user=False):
        """Export systemd files for a group"""
        args = [group_name]
        if user:
            args.append("--user")
        
        result = self.run_command("export-systemd", args)
        
        return {
            "success": result["success"],
            "message": result["stdout"] if result["success"] else result.get("stderr", "Export failed")
        }
    
    def export_cron(self, group_name):
        """Export cron configuration for a group"""
        result = self.run_command("export-cron", [group_name])
        
        return {
            "success": result["success"],
            "message": result["stdout"] if result["success"] else result.get("stderr", "Export failed")
        }
    
    def list_schedules(self):
        """Get list of scheduled groups"""
        result = self.run_command("list-schedules")
        
        if result["success"]:
            return {
                "success": True,
                "output": result["stdout"]
            }
        else:
            return {"success": False, "error": "No schedules found"}
    
    def handle_request(self, request):
        """Handle incoming request from QML"""
        command = request.get("command")
        args = request.get("args", [])
        request_id = request.get("id")
        
        # Map commands to methods
        command_map = {
            "list": lambda: self.list_scripts(),
            "list-groups": lambda: self.list_groups(),
            "list-schedules": lambda: self.list_schedules(),
            "run": lambda: self.run_script(args[0]) if args else {"error": "No script name"},
            "run-all": lambda: self.run_all(),
            "run-group": lambda: self.run_group(args[0]) if args else {"error": "No group name"},
            "logs": lambda: self.get_logs(args[0]) if args else {"error": "No script name"},
            "history": lambda: self.get_history(args[0]) if args else {"error": "No script name"},
            "clear-logs": lambda: self.clear_logs(args[0]) if args else {"error": "No script name"},
            "clear-all-logs": lambda: self.clear_all_logs(),
            "show-config": lambda: self.show_config(),
            "get-setting": lambda: self.get_setting(args[0]) if args else {"error": "No key"},
            "validate": lambda: self.validate(),
            "export-systemd": lambda: self.export_systemd(args[0], "--user" in args) if args else {"error": "No group name"},
            "export-cron": lambda: self.export_cron(args[0]) if args else {"error": "No group name"},
        }
        
        if command in command_map:
            try:
                result = command_map[command]()
                
                response = {
                    "id": request_id,
                    "data": result.get("data") if result.get("success") else None,
                    "error": result.get("error") if not result.get("success") else None,
                    "message": result.get("message"),
                    "success": result.get("success", False)
                }
                
                return response
            except Exception as e:
                return {
                    "id": request_id,
                    "error": str(e),
                    "success": False
                }
        else:
            return {
                "id": request_id,
                "error": f"Unknown command: {command}",
                "success": False
            }

def main():
    """Main loop - read JSON requests from stdin, write responses to stdout"""
    backend = SignalboxBackend()
    
    # Ensure we're in the signalbox directory
    os.chdir(backend.signalbox_dir)
    
    for line in sys.stdin:
        try:
            request = json.loads(line.strip())
            response = backend.handle_request(request)
            print(json.dumps(response), flush=True)
        except json.JSONDecodeError as e:
            error_response = {
                "id": None,
                "error": f"Invalid JSON: {str(e)}",
                "success": False
            }
            print(json.dumps(error_response), flush=True)
        except Exception as e:
            error_response = {
                "id": None,
                "error": f"Backend error: {str(e)}",
                "success": False
            }
            print(json.dumps(error_response), flush=True)

if __name__ == "__main__":
    main()
