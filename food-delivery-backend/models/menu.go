package models

import "go.mongodb.org/mongo-driver/bson/primitive"

type MenuItem struct {
	ID           primitive.ObjectID `bson:"_id,omitempty" json:"id"`
	RestaurantID primitive.ObjectID `bson:"restaurantId" json:"restaurantId"`
	Name         string             `bson:"name" json:"name"`
	Description  string             `bson:"description" json:"description"`
	Price        float64            `bson:"price" json:"price"`
	Image        string             `bson:"image" json:"image"`
}