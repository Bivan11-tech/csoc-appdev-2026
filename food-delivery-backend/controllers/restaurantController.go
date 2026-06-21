package controllers

import (
	"context"
	"food-delivery-backend/database"
	"food-delivery-backend/models"
	"net/http"
	"time"

	"github.com/gin-gonic/gin"
	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
)

func GetRestaurants(c *gin.Context) {
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()

	cursor, err := database.RestaurantCollection.Find(ctx, bson.M{})
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	var restaurants []models.Restaurant
	if err := cursor.All(ctx, &restaurants); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, restaurants)
}

func GetRestaurantByID(c *gin.Context) {
	id := c.Param("id")
	objID, err := primitive.ObjectIDFromHex(id)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "invalid id"})
		return
	}

	var restaurant models.Restaurant
	err = database.RestaurantCollection.FindOne(context.Background(), bson.M{"_id": objID}).Decode(&restaurant)
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "restaurant not found"})
		return
	}

	c.JSON(http.StatusOK, restaurant)
}

func GetRestaurantMenu(c *gin.Context) {
	id := c.Param("id")
	restaurantID, err := primitive.ObjectIDFromHex(id)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "invalid id"})
		return
	}

	cursor, err := database.MenuCollection.Find(context.Background(), bson.M{"restaurantId": restaurantID})
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	var menu []models.MenuItem
	cursor.All(context.Background(), &menu)

	c.JSON(http.StatusOK, menu)
}
