package config

import (
	"log"
	"os"

	"github.com/joho/godotenv"
)

func LoadEnv() {
	err := godotenv.Load()
	if err != nil {
		log.Fatal("Error loading .env file")
	}
}

func GetMongoURI() string {
	return os.Getenv("MONGO_URI")
}

func GetJWTSecret() string {
	return os.Getenv("JWT_SECRET")
}