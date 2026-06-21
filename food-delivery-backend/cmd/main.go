package main

import (
	"food-delivery-backend/config"
	"food-delivery-backend/database"
	"food-delivery-backend/routes"
	"os"

	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
)

func main() {
	config.LoadEnv()

	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	database.ConnectDB()
	r := gin.Default()

	// CORS middleware
	r.Use(cors.New(cors.Config{
		AllowOrigins:     []string{"*"},
		AllowMethods:     []string{"GET", "POST", "PUT", "DELETE", "OPTIONS"},
		AllowHeaders:     []string{"Origin", "Content-Type", "Authorization"},
		ExposeHeaders:    []string{"Content-Length"},
		AllowCredentials: false,
	}))

	routes.AuthRoutes(r)
	routes.RestaurantRoutes(r)
	routes.CartRoutes(r)
	routes.OrderRoutes(r)

	r.Run("0.0.0.0:" + port)
}