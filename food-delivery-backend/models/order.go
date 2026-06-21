package models

import (
	"time"

	"go.mongodb.org/mongo-driver/bson/primitive"
)

type OrderItem struct {
	MenuItemID string  `json:"menuItemId" bson:"menuItemId"`
	Name       string  `json:"name" bson:"name"`
	Quantity   int     `json:"quantity" bson:"quantity"`
	Price      float64 `json:"price" bson:"price"`
}

type Order struct {
	ID          primitive.ObjectID `bson:"_id,omitempty" json:"id"`
	UserID      primitive.ObjectID `bson:"userId" json:"userId"`
	Items       []OrderItem        `bson:"items" json:"items"`
	Subtotal    float64            `bson:"subtotal" json:"subtotal"`
	Tax         float64            `bson:"tax" json:"tax"`
	DeliveryFee float64            `bson:"deliveryFee" json:"deliveryFee"`
	PromoCode   string             `bson:"promoCode,omitempty" json:"promoCode"`
	Discount    float64            `bson:"discount" json:"discount"`
	Total       float64            `bson:"total" json:"total"`
	Status      string             `bson:"status" json:"status"`
	CreatedAt   time.Time          `bson:"createdAt" json:"createdAt"`
}
