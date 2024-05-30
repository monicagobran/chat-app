# Chat System Application

This is a chat system application built with Ruby on Rails. The application provides endpoints to create applications, chats, and messages, and to search messages within a specific chat. It utilizes MySQL as the main datastore and Elasticsearch for message searching.

## Features

- **Application Management**: Allows creating new applications with a generated token and a provided name.
- **Chat Management**: Each application can have multiple chats, each uniquely numbered. Chats can be created and retrieved for a specific application.
- **Message Management**: Messages can be added to chats, each with a unique number. Messages can be searched within a specific chat.
- **Database Optimization**: The `chats_count` column in the `applications` table and the `messages_count` column in the `chats` table track the number of chats and messages, respectively, to optimize queries.
- **Concurrency Handling**: Handles race conditions and supports multiple concurrent requests.
- **Containerized Deployment**: Docker and Docker Compose are used for containerization. Simply run `docker-compose up` to start the application stack.

## Prerequisites

Make sure you have Docker and Docker Compose installed on your machine.

## Running the Application

1. Clone this repository to your local machine by running `git clone https://github.com/monicagobran/chat-app.git`.
2. Navigate to the project directory.
3. Run `docker-compose up` to build and start the application stack.
4. Once the containers are up and running, the API will be accessible at `http://localhost:3000`.

## API Endpoints

- **Create Application**: `POST /applications`
  - Request Body Example:
    ```json
    {
      "name": "My App"
    }
    ```
- **Retrieve Applications**: `GET /applications`
- **Retrieve Application**: `GET /applications/:token`
- **Create Chat**: `POST /applications/:token/chats`
- **Retrieve Chats**: `GET /applications/:token/chats`
- **Retrieve Chat**: `GET /applications/:token/chats/:number`
- **Create Message**: `POST /applications/:token/chats/:number/messages`
  - Request Body Example:
    ```json
    {
      "body": "Hello World"
    }
    ```
- **Retrieve Messages**: `GET /applications/:token/chats/:number/messages`
- **Retrieve Message**: `GET /applications/:token/chats/:number/messages/:message_number`
- **Update Message**: `PATCH /applications/:token/chats/:number/messages/:message_number`
  - Request Body Example:
    ```json
    {
      "body": "Hello World!!"
    }
    ```
- **Search Messages**: `GET /applications/:token/chats/:number/messages/search`