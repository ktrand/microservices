events {}

http {
    upstream user_service {
        server user-service:50051;
    }

    upstream task_service {
        server task-service:50052;
    }

    upstream notification_service {
        server notification-service:50053;
    }

    server {
        listen 80;

        location /api/user/ {
            proxy_pass http://user_service/;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }

        location /api/task/ {
            proxy_pass http://task_service/;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }

        location /api/notification/ {
            proxy_pass http://notification_service/;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }

        error_page 502 /error.html;
        location = /error.html {
            root /usr/share/nginx/html;
            internal;
        }
    }
}
