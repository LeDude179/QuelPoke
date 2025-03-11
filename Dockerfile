# Étape 1 : Construction de l'application
FROM golang:1.22 AS builder

# Définir le répertoire de travail
WORKDIR /app

# Copier le fichier go.mod
COPY go.mod ./

# Télécharger les dépendances
RUN go mod download

# Copier le reste du projet
COPY . .

# Compiler l'application
RUN CGO_ENABLED=0 GOOS=linux go build -o QuelPoke

# Étape 2 : Image finale avec alpine (pour debug et shell)
FROM alpine:latest

# Installer les dépendances nécessaires pour le debug
RUN apk --no-cache add ca-certificates

# Copier le binaire compilé
COPY --from=builder /app/QuelPoke /QuelPoke

# Définir le port exposé
EXPOSE 8080

# Commande de démarrage
ENTRYPOINT ["/QuelPoke"]
