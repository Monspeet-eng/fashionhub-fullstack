package config

import (
	"fmt"
	"log"
	"os"

	"fashionhub-backend/internal/model"

	"gorm.io/driver/postgres"
	"gorm.io/gorm"
	"gorm.io/gorm/logger"
)

func ConnectDatabase() *gorm.DB {
	host := getEnv("DB_HOST", "localhost")
	port := getEnv("DB_PORT", "5432")
	user := getEnv("DB_USER", "postgres")
	password := getEnv("DB_PASSWORD", "password123")
	dbname := getEnv("DB_NAME", "fashionhub_db")
	sslmode := getEnv("DB_SSLMODE", "disable")

	dsn := fmt.Sprintf(
		"host=%s user=%s password=%s dbname=%s port=%s sslmode=%s TimeZone=Asia/Jakarta",
		host, user, password, dbname, port, sslmode,
	)

	db, err := gorm.Open(postgres.Open(dsn), &gorm.Config{
		Logger: logger.Default.LogMode(logger.Info),
	})
	if err != nil {
		log.Fatalf("Gagal terhubung ke database PostgreSQL: %v", err)
	}

	log.Println("Berhasil terhubung ke database PostgreSQL.")

	// Auto-migrate ke-6 tabel sesuai spesifikasi PRD Bagian 5
	err = db.AutoMigrate(
		&model.Category{},
		&model.Product{},
		&model.CartItem{},
		&model.Order{},
		&model.OrderItem{},
		&model.ContactMessage{},
	)
	if err != nil {
		log.Fatalf("Gagal menjalankan migrasi database: %v", err)
	}

	log.Println("Migrasi tabel database selesai.")
	return db
}

func getEnv(key, fallback string) string {
	if value, exists := os.LookupEnv(key); exists && value != "" {
		return value
	}
	return fallback
}
