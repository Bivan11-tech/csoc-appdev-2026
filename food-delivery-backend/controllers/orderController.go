package controllers

import (
	"context"
	"food-delivery-backend/database"
	"food-delivery-backend/models"
	"food-delivery-backend/utils"
	"net/http"
	"time"

	"github.com/gin-gonic/gin"
	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
)

type CreateOrderRequest struct {
	Items     []models.OrderItem `json:"items"`
	PromoCode string             `json:"promoCode"`
}

func CreateOrder(c *gin.Context) {
	var req CreateOrderRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	userIDStr := c.GetString("user_id")
	userID, err := primitive.ObjectIDFromHex(userIDStr)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "invalid user id"})
		return
	}

	subtotal := 0.0
	for _, item := range req.Items {
		subtotal += item.Price * float64(item.Quantity)
	}
	discount := utils.GetDiscount(req.PromoCode, subtotal)
	tax := subtotal * 0.05
	delivery := 40.0
	total := subtotal + tax + delivery - discount
	if total < 0 {
		total = 0
	}

	order := models.Order{
		UserID:      userID,
		Items:       req.Items,
		Subtotal:    subtotal,
		Tax:         tax,
		DeliveryFee: delivery,
		Discount:    discount,
		PromoCode:   req.PromoCode,
		Total:       total,
		Status:      "Placed",
		CreatedAt:   time.Now(),
	}

	result, err := database.OrderCollection.InsertOne(context.Background(), order)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	order.ID = result.InsertedID.(primitive.ObjectID)
	c.JSON(http.StatusCreated, order)
}

func GetOrders(c *gin.Context) {
	userIDStr := c.GetString("user_id")
	userID, err := primitive.ObjectIDFromHex(userIDStr)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "invalid user id"})
		return
	}

	cursor, err := database.OrderCollection.Find(context.Background(), bson.M{"userId": userID})
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	var orders []models.Order
	cursor.All(context.Background(), &orders)

	c.JSON(http.StatusOK, orders)
}

func GetOrderByID(c *gin.Context) {
	id := c.Param("id")
	objID, _ := primitive.ObjectIDFromHex(id)

	var order models.Order
	err := database.OrderCollection.FindOne(context.Background(), bson.M{"_id": objID}).Decode(&order)
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "order not found"})
		return
	}

	c.JSON(http.StatusOK, order)
}
