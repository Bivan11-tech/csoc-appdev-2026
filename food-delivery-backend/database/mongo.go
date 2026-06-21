package database

import (
	"context"
	"food-delivery-backend/config"
	"log"
	"time"

	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
)

var (
	UserCollection       *mongo.Collection
	OrderCollection      *mongo.Collection
	RestaurantCollection *mongo.Collection
	MenuCollection       *mongo.Collection
	CartCollection       *mongo.Collection
)

func ConnectDB() {
	client, err := mongo.Connect(context.TODO(), options.Client().ApplyURI(config.GetMongoURI()))
	if err != nil {
		log.Fatal(err)
	}

	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()
	if err = client.Ping(ctx, nil); err != nil {
		log.Fatal(err)
	}

	db := client.Database("food_delivery")

	UserCollection = db.Collection("users")
	OrderCollection = db.Collection("orders")
	RestaurantCollection = db.Collection("restaurants")
	MenuCollection = db.Collection("menu")
	CartCollection = db.Collection("carts")
}
