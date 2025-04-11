# Blog API – Ruby on Rails

A lightweight social media backend API built using **Ruby on Rails**, with authentication, post management, and comment functionality. Scheduled jobs (like post auto-deletion) are handled via **Sidekiq** and **Redis**.

---

## Features

### Authentication
- User registration & login via JWT tokens
- User model includes: `name`, `email`, `password`, and `image`
- All endpoints (except authentication) are protected and require JWT access

### Post Management (CRUD)
- Each post contains: `title`, `body`, `author`, `tags`, and `comments`
- Authors can:
  - Create, update, and delete their own posts
  - Add, edit, and delete their own comments
  - Update tags (each post must have at least one tag)
- Comments:
  - Users can comment on any post
  - Only comment authors can update/delete their comments
- Posts auto-delete 24 hours after creation (handled via background job)

---

## 🛠️ Tech Stack

- **Ruby on Rails**
- **PostgreSQL** – database
- **Redis** – job queue backend
- **Sidekiq** – background job processor
- **JWT** – for secure API authentication
- **Swagger** – API documentation

---

## Getting Started with Docker

### Prerequisites
- Docker & Docker Compose installed on your machine

### Run the app:

```bash
docker-compose up --build
```
### This will:

- Build the app

- Run database migrations and seed data

- Start both the Rails server and Sidekiq workers

## API Documentation
### Available at:
👉 [http://0.0.0.0:3000/api-docs](http://0.0.0.0:3000/api-docs)

Interactive Swagger UI where you can explore and test endpoints.

## 📌 Background Jobs Dashboard

You can monitor Sidekiq jobs via:  
👉 [http://0.0.0.0:3000/sidekiq/](http://0.0.0.0:3000/sidekiq/)

## 👤 Author

**Mohamed Ebrahim**  
🔗 [GitHub Profile](https://github.com/mohmedeprahem)

## 📄 License

This project is licensed under the MIT License.
