package middleware

import (
	"food-delivery-backend/config"
	"net/http"
	"strings"

	"github.com/gin-gonic/gin"
	"github.com/golang-jwt/jwt/v5"
)

func AuthMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		auth := c.GetHeader("Authorization")
		if auth == "" {
			c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"error": "token missing"})
			return
		}

		tokenString := strings.TrimPrefix(auth, "Bearer ")

		token, err := jwt.Parse(tokenString, func(token *jwt.Token) (any, error) {
			return []byte(config.GetJWTSecret()), nil
		})
		if err != nil || !token.Valid {c.AbortWithStatusJSON(http.StatusUnauthorized,
			gin.H{"error": "invalid token"})
			return
		}

		claims := token.Claims.(jwt.MapClaims)
		userID := claims["user_id"].(string)
		c.Set("user_id", userID)
		c.Next()
	}
}
