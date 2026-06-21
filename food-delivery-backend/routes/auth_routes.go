package routes

import (
	"food-delivery-backend/controllers"
	"food-delivery-backend/middleware"

	"github.com/gin-gonic/gin"
)

func AuthRoutes(r *gin.Engine) {
	auth := r.Group("/api/auth")
	{
		auth.POST("/register", controllers.Register)
		auth.POST("/login", controllers.Login)
		auth.GET("/profile", middleware.AuthMiddleware(), controllers.Profile)
		auth.PUT("/profile", middleware.AuthMiddleware(), controllers.UpdateProfile)
	}
}
