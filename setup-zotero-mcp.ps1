# Zotero MCP setup for Claude Desktop (Windows)
# What it does:
#   1) Installs mcp-remote globally
#   2) Prints the exact "zotero" config block to paste into claude_desktop_config.json
#
# Run in PowerShell:  powershell -ExecutionPolicy Bypass -File .\setup-zotero-mcp.ps1

Write-Host "Installing mcp-remote globally..." -ForegroundColor Cyan
npm install -g mcp-remote

$node  = (Get-Command node).Source
$proxy = Join-Path $env:APPDATA "npm\node_modules\mcp-remote\dist\proxy.js"
$nodeJson  = $node.Replace('\','\\')
$proxyJson = $proxy.Replace('\','\\')

Write-Host ""
Write-Host "Add this 'zotero' entry to the mcpServers object in:" -ForegroundColor Green
Write-Host "  $env:APPDATA\Claude\claude_desktop_config.json" -ForegroundColor Green
Write-Host ""
Write-Output @"
"zotero": {
  "command": "$nodeJson",
  "args": [
    "$proxyJson",
    "http://127.0.0.1:23120/mcp"
  ]
}
"@
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "  1) Fully quit and reopen Claude Desktop (from the tray)." -ForegroundColor Yellow
Write-Host "  2) Make sure Zotero is running with the MCP plugin server enabled (port 23120)." -ForegroundColor Yellow
Write-Host "  3) For tags/import, enable 'Enable Write Operations' in the plugin and restart Zotero." -ForegroundColor Yellow
