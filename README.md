# windows-time-sync

Small Windows script that keeps the system clock accurate. It does **not** change the time zone.

Useful when the Windows Time service is stopped or only syncs once a week (the default), which lets the clock drift by seconds.

## What it does
1. Enables the Windows Time service (`w32time`) and sets it to start automatically.
2. Sets time servers: `time.windows.com`, `time.google.com`, `pool.ntp.org`.
3. Sets the poll interval to 10 minutes (default is 7 days).
4. Creates a scheduled task `gc_time_sync` that runs `w32tm /resync /force` every 10 minutes as a safety net.

## Usage
Run `setup_time_sync.cmd` **as Administrator** (open an elevated Command Prompt and run the file). It survives reboots.

Check status: `w32tm /query /status`

Remove: `schtasks /delete /tn gc_time_sync /f`

## По-русски
Скрипт включает службу времени Windows и синхронизирует часы каждые 10 минут. Часовой пояс не меняется. Запускать от имени администратора.

## License
MIT
