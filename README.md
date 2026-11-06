# windows-time-sync

Keeps the Windows system clock accurate by syncing it with internet time servers every 10 minutes. It does **not** change the time zone.

**Why:** on many PCs the Windows Time service (`w32time`) is stopped, or it syncs only once a week (the default). The clock then drifts by seconds or more, which matters for trading data, logs, and anything that compares timestamps with a server.

## What the script does
1. Enables the Windows Time service and sets it to start automatically at boot.
2. Sets time servers: `time.windows.com`, `time.google.com`, `pool.ntp.org`.
3. Sets the poll interval to 10 minutes (default is 7 days).
4. Creates a scheduled task `gc_time_sync` that runs `w32tm /resync /force` every 10 minutes (safety net).
5. Syncs immediately and prints the status.

It survives reboots. Requires Windows 10/11 and Administrator rights.

## Install
1. Download `setup_time_sync.cmd` (or clone the repo):
   ```
   git clone https://github.com/ValerySl/windows-time-sync.git
   ```
2. Open **Command Prompt as Administrator** (Start, type `cmd`, right click, *Run as administrator*).
3. Run:
   ```
   cd windows-time-sync
   setup_time_sync.cmd
   ```
   The last line should be `DONE. Time will sync every 10 minutes.`

## Useful commands
| What | Command |
|---|---|
| Check sync status | `w32tm /query /status` |
| Force sync now | `w32tm /resync /force` |
| Check the service | `sc query w32time` |
| Check the task | `schtasks /query /tn gc_time_sync` |
| Compare with a server | `w32tm /stripchart /computer:pool.ntp.org /samples:3 /dataonly` |

In the status output, `Last Successful Sync Time` should be recent and `Source` should be one of the servers above.

## Uninstall
In an Administrator Command Prompt:
```
schtasks /delete /tn gc_time_sync /f
sc config w32time start= demand
net stop w32time
```

## Troubleshooting
- *"Need Administrator rights"* — the window was not elevated; use the steps above (double click does not give admin rights).
- Garbled text or "is not recognized" errors — the file must stay ASCII-only (cmd cannot read UTF-8 Cyrillic in batch files).
- `The service has not been started (0x80070426)` — run the script; it starts the service.

## По-русски
Скрипт включает службу времени Windows и синхронизирует часы с интернет-серверами каждые 10 минут. Часовой пояс не меняется. Запускать нужно **от имени администратора**: Пуск, `cmd`, правой кнопкой, «Запуск от имени администратора», затем `setup_time_sync.cmd`. Проверка: `w32tm /query /status`. Удаление: см. раздел Uninstall.

## License
MIT
