package models

import (
	"time"

	"go.mongodb.org/mongo-driver/bson/primitive"
)

type CartItem struct {
	MenuItemID  primitive.ObjectID `bson:"menuItemId" json:"menuItemId"`
	Name        string             `bson:"name" json:"name"`
	Price       float64            `bson:"price" json:"price"`
	Description string             `bson:"description" json:"description"`
	Quantity    int                `bson:"quantity" json:"quantity"`
	Image       string             `bson:"image" json:"image"`
}

type Cart struct {
	ID        primitive.ObjectID `bson:"_id,omitempty" json:"id"`
	UserID    primitive.ObjectID `bson:"userId" json:"userId"`
	Items     []CartItem         `bson:"items" json:"items"`
	UpdatedAt time.Time          `bson:"updatedAt" json:"updatedAt"`
}
