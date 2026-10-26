# RTOS Scheduling Labs

以 μC/OS-II 的 Windows／Visual Studio 範例為基底，練習週期性任務、即時排程、非週期性工作與共享資源控制。

## 作業內容

| 作業 | 練習內容 | 輸入範例 |
| --- | --- | --- |
| LAB1 | 建立週期性任務，記錄任務執行與 tick。 | [TaskSet.txt](inputs/LAB1/TaskSet.txt) |
| PA1 | RM／FIFO 排程、任務到達與執行時間追蹤。 | [TaskSet.txt](inputs/PA1/TaskSet.txt) |
| PA2 | EDF 排程與非週期性工作處理。 | [任務與非週期性工作](inputs/PA2/) |
| PA3 | 在 μC/OS-II 的 RM 排程下實作 NPCS 與 CPP，比較共享資源造成的阻塞與排程延遲。 | [TaskSet.txt](inputs/PA3/TaskSet.txt) |

各作業保留當時的原始設定；實際採用的演算法與協定由還原後的 `Micrium/Software/uCOS-II/Source/ucos_ii.h` 中 `ALGORITHM`、`PROTOCOL` 等設定決定。

## 開發環境

- Windows
- Visual Studio 2022（MSVC v143、Windows 10 SDK）
- μC/OS-II V2.92.13

## 程式導覽

主要修改的檔案：

- `main.c`：程式入口與任務建立。
- `app_hooks.c`：排程、tick hook 與實驗邏輯。
- `ucos_ii.h`：任務資料結構與排程設定。
- `os_core.c`、`os_cpu_c.c`：核心與 Win32 port 相關修改。
