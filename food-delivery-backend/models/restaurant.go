package models

import "go.mongodb.org/mongo-driver/bson/primitive"

type Restaurant struct {
	ID           primitive.ObjectID `bson:"_id,omitempty" json:"id"`
	Name         string             `bson:"name" json:"name"`
	Image        string             `bson:"image" json:"image"`
	Rating       float64            `bson:"rating" json:"rating"`
	DeliveryTime int32              `bson:"deliveryTime" json:"deliveryTime"`
	CuisineType  string             `bson:"cuisineType" json:"category"`
}
