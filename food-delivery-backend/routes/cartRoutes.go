package routes

import (
	"food-delivery-backend/controllers"
	"food-delivery-backend/middleware"
	"github.com/gin-gonic/gin"
)

func CartRoutes(router *gin.Engine) {
	api := router.Group("/api")
	api.Use(middleware.AuthMiddleware())

	api.POST("/cart", controllers.AddToCart)
	api.GET("/cart", controllers.GetCart)
	api.PUT("/cart/:menuItemId", controllers.UpdateCartItem)
	api.DELETE("/cart/:menuItemId", controllers.RemoveCartItem)
	api.DELETE("/cart", controllers.ClearCart)
}
