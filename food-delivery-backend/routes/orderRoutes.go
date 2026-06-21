package routes

import (
	"food-delivery-backend/controllers"
	"food-delivery-backend/middleware"
	"github.com/gin-gonic/gin"
)

func OrderRoutes(router *gin.Engine) {
	api := router.Group("/api")
	api.Use(middleware.AuthMiddleware())
	
	api.POST("/orders", controllers.CreateOrder)
	api.GET("/orders", controllers.GetOrders)
	api.GET("/orders/:id", controllers.GetOrderByID)
}
