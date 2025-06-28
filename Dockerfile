# === Stage 1: Build the MkDocs site ===
FROM astral/uv:0.7-alpine AS builder

WORKDIR /app

# Copy project files and install dependencies
COPY . .

# Install dependencies
RUN uv sync

# Run mkdocs using the virtual environment directly
RUN .venv/bin/mkdocs build

# === Stage 2: Serve with Nginx ===
FROM nginx:1.29-alpine

# Clean default Nginx html and copy site output
RUN rm -rf /usr/share/nginx/html/*
COPY --from=builder /app/site /usr/share/nginx/html

EXPOSE 80
ENTRYPOINT ["nginx", "-g", "daemon off;"]
