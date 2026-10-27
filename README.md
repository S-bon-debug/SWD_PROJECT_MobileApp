# IoT Monitoring Mobile App

Ứng dụng Flutter hỗ trợ quản lý hệ thống IoT: sites, hubs, sensors, dữ liệu môi trường, cảnh báo và thông báo.

> **Dự án nhóm.** Repository giữ lịch sử Git công khai để thể hiện phần việc của từng thành viên. Các hạng mục bên dưới chỉ mô tả phần tôi trực tiếp tham gia.

## 📌 Mục tiêu

Ứng dụng giúp quản trị viên theo dõi dữ liệu cảm biến, quản lý thiết bị và vị trí triển khai, thiết lập cảnh báo theo ngưỡng, và nhận thông báo khi có sự kiện cần chú ý.

## ✨ Chức năng chính

- Đăng ký, đăng nhập và kết nối REST API
- Dashboard dữ liệu môi trường và biểu đồ lịch sử
- Quản lý sites, hubs và sensors
- Tạo, chỉnh sửa và quản lý alert rules
- Quản lý organizations và users
- Hồ sơ người dùng và notification center
- Firebase Cloud Messaging cho thông báo nền và foreground

## 🛠 Công nghệ sử dụng

| Nhóm | Công nghệ |
|---|---|
| Mobile | Flutter, Dart |
| API | HTTP, REST API |
| Charts | fl_chart |
| Notifications | Firebase Core, Firebase Cloud Messaging |

## 🧩 Kiến trúc tổng quan

```mermaid
flowchart LR
  client[Flutter client] --> api[IoT REST API]
  api --> dashboard[Dashboard data]
  api --> devices[Sites, hubs, sensors]
  api --> alerts[Alert rules and history]
  fcm[Firebase Cloud Messaging] --> client
```

## 👤 Phần việc tôi tham gia

- Tích hợp login API và cập nhật luồng xác thực.
- Cập nhật dashboard dữ liệu môi trường và biểu đồ.
- Tham gia phát triển notification flow, profile, organizations và user management.
- Cập nhật sensors, alerts, hubs và giao diện dashboard/alerts.
- Sửa các lỗi API và hành vi liên quan đến sensors/hubs.

## 🚀 Khởi chạy local

### Yêu cầu

- Flutter SDK tương thích Dart `>=3.2.0 <4.0.0`
- Backend IoT API đang hoạt động
- Firebase configuration hợp lệ cho nền tảng cần chạy

### Chạy ứng dụng

```bash
git clone https://github.com/S-bon-debug/SWD_PROJECT_MobileApp.git
cd SWD_PROJECT_MobileApp
flutter pub get
flutter run
```

## Ghi chú dự án nhóm

Repository có nhiều thành viên đóng góp. Vui lòng xem Git history để biết chi tiết attribution theo từng thay đổi.
