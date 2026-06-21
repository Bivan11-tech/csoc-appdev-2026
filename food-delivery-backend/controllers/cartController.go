package controllers

import (
	"context"
	"net/http"
	"time"

	"food-delivery-backend/database"
	"food-delivery-backend/models"

	"github.com/gin-gonic/gin"
	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
)

type AddCartRequest struct {
	MenuItemID string `json:"menuItemId" binding:"required"`
	Quantity   int    `json:"quantity" binding:"required"`
}

func AddToCart(c *gin.Context) {
	userIDStr := c.GetString("user_id")
	userID, err := primitive.ObjectIDFromHex(userIDStr)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "invalid user"})
		return
	}

	var req AddCartRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if req.Quantity <= 0 {
		c.JSON(http.StatusBadRequest, gin.H{"error": "quantity must be greater than 0"})
		return
	}

	menuID, err := primitive.ObjectIDFromHex(req.MenuItemID)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "invalid menu item id"})
		return
	}

	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()

	var menuItem models.MenuItem
	err = database.MenuCollection.FindOne(ctx, bson.M{"_id": menuID}).Decode(&menuItem)
	if err != nil {
		c.JSON(http.StatusNotFound,
			gin.H{"error": "menu item not found"})
		return
	}

	var cart models.Cart
	err = database.CartCollection.FindOne(ctx, bson.M{"userId": userID}).Decode(&cart)

	if err != nil {
		cart = models.Cart{
			UserID: userID,
			Items: []models.CartItem{
				{
					MenuItemID:  menuID,
					Name:        menuItem.Name,
					Price:       menuItem.Price,
					Quantity:    req.Quantity,
					Image:       menuItem.Image,
					Description: menuItem.Description,
				}},
			UpdatedAt: time.Now(),
		}

		_, err := database.CartCollection.InsertOne(ctx, cart)
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
			return
		}

		c.JSON(http.StatusCreated, cart)
		return
	}

	found := false
	for i := range cart.Items {
		if cart.Items[i].MenuItemID == menuID {
			cart.Items[i].Quantity += req.Quantity
			found = true
			break
		}
	}

	if !found {
		cart.Items = append(cart.Items,
			models.CartItem{
				MenuItemID:  menuID,
				Name:        menuItem.Name,
				Price:       menuItem.Price,
				Quantity:    req.Quantity,
				Image:       menuItem.Image,
				Description: menuItem.Description,
			},
		)
	}
	cart.UpdatedAt = time.Now()

	_, err = database.CartCollection.UpdateOne(ctx, bson.M{"userId": userID},
		bson.M{"$set": bson.M{
			"items":     cart.Items,
			"updatedAt": cart.UpdatedAt,
		},
		},
	)

	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, cart)
}

func GetCart(c *gin.Context) {
	userIDStr := c.GetString("user_id")
	userID, err := primitive.ObjectIDFromHex(userIDStr)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "invalid user"})
		return
	}

	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()

	var cart models.Cart
	err = database.CartCollection.FindOne(ctx, bson.M{"userId": userID}).Decode(&cart)
	if err != nil {
		c.JSON(http.StatusOK, gin.H{"items": []models.CartItem{}})
		return
	}

	c.JSON(http.StatusOK, cart)
}

type UpdateCartRequest struct {
	MenuItemID string `json:"menuItemId"`
	Quantity   int    `json:"quantity"`
}

func UpdateCartItem(c *gin.Context) {
	userIDStr := c.GetString("user_id")
	userID, _ := primitive.ObjectIDFromHex(userIDStr)
	var req UpdateCartRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if req.Quantity <= 0 {
		c.JSON(http.StatusBadRequest, gin.H{"error": "quantity must be greater than 0"})
		return
	}

	menuID, err := primitive.ObjectIDFromHex(req.MenuItemID)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "invalid menu id"})
		return
	}

	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()

	var cart models.Cart
	err = database.CartCollection.FindOne(ctx, bson.M{"userId": userID}).Decode(&cart)
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "cart not found"})
		return
	}

	for i := range cart.Items {
		if cart.Items[i].MenuItemID == menuID {
			cart.Items[i].Quantity = req.Quantity
			break
		}
	}

	_, err = database.CartCollection.UpdateOne(ctx, bson.M{"userId": userID},
		bson.M{"$set": bson.M{"items": cart.Items}},
	)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "cart updated"})
}

func RemoveCartItem(c *gin.Context) {
	userIDStr := c.GetString("user_id")
	userID, _ := primitive.ObjectIDFromHex(userIDStr)
	itemID := c.Param("menuItemId")
	menuID, err := primitive.ObjectIDFromHex(itemID)

	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "invalid item id"})
		return
	}

	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()

	var cart models.Cart
	err = database.CartCollection.FindOne(ctx, bson.M{"userId": userID}).Decode(&cart)
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "cart not found"})
		return
	}

	newItems := []models.CartItem{}
	for _, item := range cart.Items {
		if item.MenuItemID != menuID {
			newItems = append(newItems, item)
		}
	}
	_, err = database.CartCollection.UpdateOne(ctx, bson.M{"userId": userID},
		bson.M{"$set": bson.M{"items": newItems}})

	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "item removed"})
}

func ClearCart(c *gin.Context) {
	userIDStr := c.GetString("user_id")
	userID, _ := primitive.ObjectIDFromHex(userIDStr)
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()

	_, err := database.CartCollection.DeleteOne(ctx, bson.M{"userId": userID})
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "cart cleared"})
}
