# docker-alist

使用 Docker Compose 部署 [AList](https://alistgo.com/) 官方映像檔 `xhofe/alist:latest`，資料存放於本機 `./data`。

## 檔案

- `docker-compose.yml`：服務定義，掛載 `./data` 至容器的 `/opt/alist/data`。
- `.env.example`：可調整的通訊埠、UID/GID、umask 與時區。
- `set-password.sh`：重設管理員密碼的小工具。

## 使用方式

1. 準備環境變數：

   ```bash
   cp .env.example .env
   ```

   可依需求修改 `.env`：

   | 參數 | 預設值 | 說明 |
   | --- | --- | --- |
   | `ALIST_PORT` | `5244` | 對外host埠號，容器內固定為 `5244` |
   | `PUID` | `0` | 執行程序的使用者 UID |
   | `PGID` | `0` | 執行程序的使用者 GID |
   | `UMASK` | `022` | 檔案權限遮罩 |
   | `TZ` | `Asia/Shanghai` | 時區，例如 `Asia/Taipei`、`UTC` |

2. 啟動服務：

   ```bash
   docker compose up -d
   ```

3. 取得初始管理員資訊：

   ```bash
   docker compose logs alist
   ```

   v3.25.0 以上首次啟動會在日誌中顯示隨機產生的管理員密碼。

4. 開啟 `http://<host-ip>:5244`（或 `.env` 設定的 `ALIST_PORT`）登入。

## 重設密碼

```bash
./set-password.sh
```

不帶參數時會互動式輸入並確認密碼；也可使用以下方式：

```bash
./set-password.sh 'my-new-password'
ALIST_PASSWORD='my-new-password' ./set-password.sh
```

若要改為隨機密碼：

```bash
docker compose exec alist ./alist admin random
```

## 常見操作

```bash
docker compose ps
docker compose logs -f alist
docker compose pull && docker compose up -d
docker compose down
```

## 注意事項

- `./data` 內含資料庫與設定檔，請勿刪除；升級前建議先備份。
- 首次啟動會自動建立 `./data`，若修改 `PUID`/`PGID`，請確認該使用者對 `./data` 有讀寫權限。
- 若 `5244` 已被占用，只需修改 `.env` 中的 `ALIST_PORT`。
