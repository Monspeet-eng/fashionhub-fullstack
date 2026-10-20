package model

import "time"

// 5.1. Tabel categories
type Category struct {
	ID   uint   `gorm:"primaryKey" json:"id"`
	Name string `gorm:"type:varchar(100);not null" json:"name"`
	Slug string `gorm:"type:varchar(100);uniqueIndex;not null" json:"slug"`
}

// 5.2. Tabel products
type Product struct {
	ID          uint      `gorm:"primaryKey" json:"id"`
	CategoryID  uint      `gorm:"not null;index" json:"category_id"`
	Category    Category  `gorm:"foreignKey:CategoryID" json:"category"`
	Name        string    `gorm:"type:varchar(200);not null" json:"name"`
	Slug        string    `gorm:"type:varchar(200);uniqueIndex;not null" json:"slug"`
	Description string    `gorm:"type:text" json:"description"`
	Price       int64     `gorm:"not null" json:"price"`
	Stock       int       `gorm:"default:100" json:"stock"`
	ImageURL    string    `gorm:"type:varchar(500)" json:"image_url"`
	CreatedAt   time.Time `json:"created_at"`
}

// 5.3. Tabel cart_items
type CartItem struct {
	ID        uint      `gorm:"primaryKey" json:"id"`
	SessionID string    `gorm:"type:varchar(120);index" json:"session_id"`
	UserID    *uint     `gorm:"index" json:"user_id,omitempty"`
	ProductID uint      `gorm:"not null;index" json:"product_id"`
	Product   Product   `gorm:"foreignKey:ProductID" json:"product"`
	Quantity  int       `gorm:"default:1;not null" json:"quantity"`
	Subtotal  int64     `gorm:"-" json:"subtotal"`
	CreatedAt time.Time `json:"created_at"`
}

// 5.4. Tabel orders
type Order struct {
	ID              uint        `gorm:"primaryKey" json:"id"`
	InvoiceNumber   string      `gorm:"type:varchar(100);uniqueIndex;not null" json:"invoice_number"`
	CustomerEmail   string      `gorm:"type:varchar(150);not null" json:"customer_email"`
	CustomerName    string      `gorm:"type:varchar(150);not null" json:"customer_name"`
	CustomerPhone   string      `gorm:"type:varchar(50)" json:"customer_phone"`
	ShippingAddress string      `gorm:"type:text;not null" json:"shipping_address"`
	PostalCode      string      `gorm:"type:varchar(20)" json:"postal_code"`
	TotalAmount     int64       `gorm:"not null" json:"total_amount"`
	PaymentStatus   string      `gorm:"type:varchar(30);default:'PAID'" json:"payment_status"`
	Items           []OrderItem `gorm:"foreignKey:OrderID" json:"items"`
	CreatedAt       time.Time   `json:"created_at"`
}

// 5.5. Tabel order_items
type OrderItem struct {
	ID        uint    `gorm:"primaryKey" json:"id"`
	OrderID   uint    `gorm:"not null;index" json:"order_id"`
	ProductID uint    `gorm:"not null;index" json:"product_id"`
	Product   Product `gorm:"foreignKey:ProductID" json:"product"`
	Quantity  int     `gorm:"not null" json:"quantity"`
	Price     int64   `gorm:"not null" json:"price"`
}

// 5.6. Tabel contact_messages
type ContactMessage struct {
	ID        uint      `gorm:"primaryKey" json:"id"`
	Name      string    `gorm:"type:varchar(150);not null" json:"name"`
	Email     string    `gorm:"type:varchar(150);not null" json:"email"`
	Phone     string    `gorm:"type:varchar(50)" json:"phone"`
	Message   string    `gorm:"type:text;not null" json:"message"`
	CreatedAt time.Time `json:"created_at"`
}
