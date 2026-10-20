package main

import (
	"log"
	"net/http"
	"os"

	"fashionhub-backend/config"
	"fashionhub-backend/db/seeder"
	"fashionhub-backend/internal/handler"
	"fashionhub-backend/internal/middleware"
	"fashionhub-backend/internal/repository"
	"fashionhub-backend/internal/service"

	"github.com/gin-gonic/gin"
	"github.com/joho/godotenv"
)

func main() {
	// Muat file .env jika tersedia
	_ = godotenv.Load()

	// Inisialisasi koneksi PostgreSQL & Auto-Migration
	db := config.ConnectDatabase()

	// Jalankan seeder data produk otomatis
	seeder.SeedDatabase(db)

	// Inisialisasi Repository Layer
	productRepo := repository.NewProductRepository(db)
	cartRepo := repository.NewCartRepository(db)
	orderRepo := repository.NewOrderRepository(db)
	contactRepo := repository.NewContactRepository(db)

	// Inisialisasi Service Layer
	productService := service.NewProductService(productRepo)
	cartService := service.NewCartService(cartRepo, productRepo)
	checkoutService := service.NewCheckoutService(orderRepo, cartRepo)
	contactService := service.NewContactService(contactRepo)

	// Inisialisasi Handler Layer
	productHandler := handler.NewProductHandler(productService)
	cartHandler := handler.NewCartHandler(cartService)
	checkoutHandler := handler.NewCheckoutHandler(checkoutService)
	contactHandler := handler.NewContactHandler(contactService)

	// Setup Gin Router & Middleware
	r := gin.Default()
	r.Use(middleware.CORSMiddleware())
	r.Use(middleware.OptionalAuthGuard())

	// Healthcheck endpoint
	r.GET("/health", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{
			"status":  "UP",
			"service": "FashionHub RESTful API",
		})
	})

	// Spesifikasi API Endpoint (PRD Bagian 6)
	api := r.Group("/api/v1")
	{
		// 6.1. Produk & Katalog
		api.GET("/products", productHandler.GetProducts)
		api.GET("/products/:id", productHandler.GetProductByID)

		// 6.2. Keranjang Belanja
		api.GET("/cart", cartHandler.GetCart)
		api.POST("/cart", cartHandler.AddToCart)
		api.PUT("/cart/:id", cartHandler.UpdateCartItem)
		api.DELETE("/cart/:id", cartHandler.DeleteCartItem)

		// 6.3. Transaksi & Checkout
		api.POST("/checkout", checkoutHandler.Checkout)

		// 6.4. Kontak & Pesan
		api.POST("/contact", contactHandler.SubmitContact)
	}

	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	log.Printf("FashionHub Backend Server berjalan di http://localhost:%s", port)
	if err := r.Run(":" + port); err != nil {
		log.Fatalf("Gagal menjalankan server: %v", err)
	}
}
