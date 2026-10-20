package handler

import (
	"net/http"

	"fashionhub-backend/internal/service"

	"github.com/gin-gonic/gin"
)

type ContactHandler struct {
	service *service.ContactService
}

func NewContactHandler(service *service.ContactService) *ContactHandler {
	return &ContactHandler{service: service}
}

// POST /api/v1/contact
func (h *ContactHandler) SubmitContact(c *gin.Context) {
	var req service.ContactRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"success": false,
			"message": "Nama, email valid, dan isi pesan wajib diisi",
			"error":   err.Error(),
		})
		return
	}

	msg, err := h.service.SubmitMessage(&req)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"success": false,
			"message": "Gagal menyimpan pesan kontak",
		})
		return
	}

	c.JSON(http.StatusCreated, gin.H{
		"success": true,
		"message": "Pesan Anda berhasil dikirim. Tim FashionHub akan segera menghubungi Anda.",
		"data":    msg,
	})
}
