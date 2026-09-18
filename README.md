# Zotero MCP for Claude Desktop

Connect your local **Zotero** library to **Claude Desktop** so Claude can search your references, read PDF full text, summarize, tag, and organize items into collections.

> 이 저장소는 Claude 데스크톱에서 Zotero 라이브러리를 쓰기 위한 **설정·사용 가이드**입니다. MCP 서버 본체는 cookjohn의 [Zotero MCP Plugin](https://github.com/cookjohn/zotero-mcp)이며, Claude와는 `mcp-remote` 브릿지로 연결합니다.

---

## 🇰🇷 한국어

### ⚡ 빠른 설치 (스크립트)
이 저장소 파일로 설정을 간소화할 수 있습니다.
- `setup-zotero-mcp.ps1` — mcp-remote 전역 설치 + 붙여넣을 config 블록 출력. 실행: `powershell -ExecutionPolicy Bypass -File .\setup-zotero-mcp.ps1`
- `claude_desktop_config.example.json` — `zotero` 항목 예시 (사용자명만 바꿔 복사)
- ⚠️ Zotero 플러그인(.xpi) 설치와 서버 켜기는 스크립트로 못 하니 아래 "설치 방법"을 따라주세요.

### 구성 개요
- **Zotero MCP Plugin (.xpi)** — Zotero 안에서 MCP 서버(포트 `23120`)를 띄웁니다. (cookjohn/zotero-mcp)
- **mcp-remote** — Claude Desktop(stdio)과 플러그인(HTTP `/mcp`)을 잇는 브릿지.
- ⚠️ 처음 흔히 참고하는 `npx zotero-mcp` + `ZOTERO_LOCAL` 방식은 이 플러그인과 맞지 않습니다(구형 npm 브릿지). 아래 방식이 실제로 동작하는 구성입니다.

### 설치 방법
1. **Zotero 플러그인 설치**
   - [Releases](https://github.com/cookjohn/zotero-mcp/releases)에서 `zotero-mcp-plugin-x.y.z.xpi` 다운로드
   - Zotero → **도구(Tools) → 추가 기능(Add-ons)** → ⚙ → **Install Add-on From File** → .xpi 선택
   - Zotero 재시작
2. **플러그인 서버 켜기**
   - Zotero → 설정 → **Zotero MCP Plugin** → **Enable Server**(포트 `23120`)
   - 태그·가져오기 등 쓰기 작업이 필요하면 **Enable Write Operations**도 켜 뒤 Zotero 재시작
3. **mcp-remote 설치 (전역)**
   ```bat
   npm install -g mcp-remote
   ```
4. **Claude Desktop 설정** — `%APPDATA%\Claude\claude_desktop_config.json` 의 `mcpServers`에 아래 추가
   ```json
   "zotero": {
     "command": "C:\\Program Files\\nodejs\\node.exe",
     "args": [
       "C:\\Users\\<사용자명>\\AppData\\Roaming\\npm\\node_modules\\mcp-remote\\dist\\proxy.js",
       "http://127.0.0.1:23120/mcp"
     ]
   }
   ```
   > Windows에서 `npx`로 서버가 안 뜸는 경우가 있어, node로 직접 실행하는 위 방식을 권장합니다. (표준 방식은 `"command": "npx", "args": ["mcp-remote", "http://127.0.0.1:23120/mcp"]`)
5. **Claude Desktop 완전 종료 후 재실행** (트레이에서 종료 → 재실행)

### 사용 전제
- Zotero 앱이 **실행 중**이고 플러그인 **서버가 켜져** 있어야 합니다(포트 23120).
- 태그·가져오기 등 쓰기 작업은 **Enable Write Operations**가 켜져 있어야 합니다.

### 사용 예시
- "내 라이브러리에서 **coaching** 관련 논문 찾아줘"
- "이 논문 **요약**해줘 / 핵심 근거만 뽑아줘"
- "2023년 이후 **메타분석**만 연도순으로 보여줘"
- "**리더십 코칭** 다루는 것만 골라 02_Leadership 컬렉션에 넣어줘"
- "이 논문 내용에 맞는 **태그** 달아줘"

### 주요 도구
- 읽기: `search_library`, `get_content`(PDF 본문), `get_item_details`, `get_item_abstract`, `get_annotations`, `get_collections`
- 정리: `create_collection`, `add_items_to_collection`, `remove_items_from_collection`, `update_collection`
- 쓰기(쓰기 모드 필요): `write_tag`, `write_note`, `write_metadata`, `write_item`, `add_by_identifier`

### 문제 해결
- **"Connection closed"로 서버 실행 실패** → `npx` 대신 node 직접 실행으로 설정 변경.
- **ping은 되는데 search가 404** → 구형 npm `zotero-mcp` 브릿지 문제. 플러그인(.xpi) 설치 + `mcp-remote` 연결로 전환.
- **태그·가져오기 도구가 안 보임** → 플러그인에서 Enable Write Operations 켜고 Zotero 재시작.
- **설정을 바꿔도 반영 안 됨** → Claude Desktop을 완전 종료 후 재실행.

---

## 🇬🇧 English

### ⚡ Quick setup (scripts)
- `setup-zotero-mcp.ps1` — installs mcp-remote globally and prints the config block to paste. Run: `powershell -ExecutionPolicy Bypass -File .\setup-zotero-mcp.ps1`
- `claude_desktop_config.example.json` — example `zotero` entry (replace the username and copy)
- ⚠️ Installing the Zotero plugin (.xpi) and enabling its server can't be scripted — follow "Installation" below.

### Overview
- **Zotero MCP Plugin (.xpi)** runs an MCP server inside Zotero on port `23120` (cookjohn/zotero-mcp).
- **mcp-remote** bridges Claude Desktop (stdio) to the plugin's HTTP `/mcp` endpoint.
- ⚠️ The commonly-cited `npx zotero-mcp` + `ZOTERO_LOCAL` setup does **not** match this plugin (it's a stale npm bridge). Use the setup below.

### Installation
1. **Install the Zotero plugin**
   - Download `zotero-mcp-plugin-x.y.z.xpi` from the [Releases page](https://github.com/cookjohn/zotero-mcp/releases).
   - Zotero → **Tools → Add-ons** → ⚙ → **Install Add-on From File** → select the .xpi.
   - Restart Zotero.
2. **Enable the plugin server**
   - Zotero → Settings → **Zotero MCP Plugin** → **Enable Server** (port `23120`).
   - For tagging/importing, also enable **Enable Write Operations**, then restart Zotero.
3. **Install mcp-remote (global)**
   ```bat
   npm install -g mcp-remote
   ```
4. **Configure Claude Desktop** — add to `mcpServers` in `%APPDATA%\Claude\claude_desktop_config.json`:
   ```json
   "zotero": {
     "command": "C:\\Program Files\\nodejs\\node.exe",
     "args": [
       "C:\\Users\\<you>\\AppData\\Roaming\\npm\\node_modules\\mcp-remote\\dist\\proxy.js",
       "http://127.0.0.1:23120/mcp"
     ]
   }
   ```
   > On Windows, launching via `npx` sometimes fails, so running node directly (above) is recommended. The standard form is `"command": "npx", "args": ["mcp-remote", "http://127.0.0.1:23120/mcp"]`.
5. **Fully quit and reopen Claude Desktop** (quit from the tray, then relaunch).

### Prerequisites
- Zotero must be **running** with the plugin **server enabled** (port 23120).
- Write actions (tags/import) require **Enable Write Operations**.

### Usage examples
- "Find papers about **coaching** in my library"
- "**Summarize** this paper / pull only the key evidence"
- "Show only **meta-analyses** since 2023, sorted by year"
- "Pick the ones on **leadership coaching** and add them to the 02_Leadership collection"
- "Add **tags** that fit this paper's content"

### Key tools
- Read: `search_library`, `get_content` (PDF text), `get_item_details`, `get_item_abstract`, `get_annotations`, `get_collections`
- Organize: `create_collection`, `add_items_to_collection`, `remove_items_from_collection`, `update_collection`
- Write (needs write mode): `write_tag`, `write_note`, `write_metadata`, `write_item`, `add_by_identifier`

### Troubleshooting
- **Server fails with "Connection closed"** → switch config from `npx` to running node directly.
- **ping works but search returns 404** → stale npm `zotero-mcp` bridge. Install the plugin (.xpi) and connect via `mcp-remote`.
- **Write tools not visible** → enable "Enable Write Operations" and restart Zotero.
- **Config changes don't take effect** → fully quit and relaunch Claude Desktop.

---

## Credits
- MCP server: [cookjohn/zotero-mcp](https://github.com/cookjohn/zotero-mcp)
- Bridge: [mcp-remote](https://www.npmjs.com/package/mcp-remote)
