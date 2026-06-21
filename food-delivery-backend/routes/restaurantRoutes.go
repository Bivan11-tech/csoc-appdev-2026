package routes

import (
	"food-delivery-backend/controllers"
	"github.com/gin-gonic/gin"
)

func RestaurantRoutes(router *gin.Engine) {
	api := router.Group("/api")
	api.GET("/restaurants", controllers.GetRestaurants)
	api.GET("/restaurants/:id", controllers.GetRestaurantByID)
	api.GET("/restaurants/:id/menu", controllers.GetRestaurantMenu)
}
